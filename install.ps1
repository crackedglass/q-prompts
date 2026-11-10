# Install skills, agent definitions, and hook assets (PowerShell 5.1+).
[CmdletBinding()]
param(
    [ValidateSet('codex', 'claude', 'opencode', 'qwen', 'all')]
    [string[]]$Agent = @('codex'),
    [string]$Destination,
    [string[]]$Skill = @(),
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$sourceRoot = Join-Path $PSScriptRoot 'skills'
$separator = [System.IO.Path]::DirectorySeparatorChar
$comparison = [System.StringComparison]::OrdinalIgnoreCase
$repository = [System.IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\', '/')
$selectedAgents = @($Agent | ForEach-Object {
    if ($_ -eq 'all') { 'codex'; 'claude'; 'opencode'; 'qwen' } else { $_ }
} | Select-Object -Unique)
if ($selectedAgents.Count -eq 0) { throw 'Select at least one agent.' }
$customDestination = $PSBoundParameters.ContainsKey('Destination')
if ($customDestination -and ([string]::IsNullOrWhiteSpace($Destination) -or $selectedAgents.Count -ne 1)) {
    throw '-Destination requires a nonempty directory and exactly one agent.'
}
if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Skills directory not found: $sourceRoot"
}
if ($Skill.Count -eq 0) {
    $Skill = @(Get-ChildItem -LiteralPath $sourceRoot -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf } |
        Select-Object -ExpandProperty Name)
}
if ($Skill.Count -eq 0) { throw 'No skills found.' }
foreach ($name in $Skill) {
    if ([string]::IsNullOrWhiteSpace($name) -or $name -in @('.', '..') -or $name -match '[/\\:]') {
        throw "Invalid skill name: $name"
    }
    if (-not (Test-Path -LiteralPath (Join-Path (Join-Path $sourceRoot $name) 'SKILL.md') -PathType Leaf)) {
        throw "Unknown skill: $name"
    }
}

function Initialize-InstallDirectory([string]$Directory) {
    $fullPath = [System.IO.Path]::GetFullPath($Directory)
    if (($fullPath.TrimEnd('\', '/') + $separator).StartsWith($repository + $separator, $comparison)) {
        throw 'Destination must be outside the source repository.'
    }
    # Avoid writing through Windows junctions/symlinks into the source checkout.
    $ancestor = $fullPath
    while ($ancestor) {
        if (Test-Path -LiteralPath $ancestor) {
            $item = Get-Item -LiteralPath $ancestor -Force
            if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
                throw "Destination cannot traverse a symbolic link or junction: $ancestor"
            }
        }
        $ancestor = [System.IO.Path]::GetDirectoryName($ancestor)
    }
    $null = New-Item -ItemType Directory -Path $fullPath -Force
    return $fullPath
}

function Install-StoreItem([string]$Source, [string]$Target) {
    if (($repository + $separator).StartsWith($Target.TrimEnd('\', '/') + $separator, $comparison)) {
        throw "Destination would overwrite the source: $Target"
    }
    $existing = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
    if ($null -ne $existing) {
        if (-not $Force) {
            Write-Host "Skipped $Target (already exists; use -Force to replace)."
            return
        }
        if ($existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            throw "Cannot replace a symbolic link or junction: $Target"
        }
        Remove-Item -LiteralPath $Target -Recurse -Force
    }
    Copy-Item -LiteralPath $Source -Destination $Target -Recurse -Force
    Write-Host "Installed $Target"
}

function Install-Assets([string]$Source, [string]$Target) {
    $Target = Initialize-InstallDirectory $Target
    if (-not (Test-Path -LiteralPath $Source -PathType Container)) { return }
    foreach ($entry in Get-ChildItem -LiteralPath $Source -Force) {
        if ($entry.Name -eq '.gitkeep') { continue }
        $assetTarget = Join-Path $Target $entry.Name
        if ($entry.PSIsContainer -and -not ($entry.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
            Install-Assets $entry.FullName $assetTarget
        } else {
            Install-StoreItem $entry.FullName $assetTarget
        }
    }
}

foreach ($tool in $selectedAgents) {
    switch ($tool) {
        codex {
            $configRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
            $skillsDestination = Join-Path $HOME '.agents/skills'
        }
        claude {
            $configRoot = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
            $skillsDestination = Join-Path $configRoot 'skills'
        }
        opencode {
            $configBase = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME '.config' }
            $configRoot = Join-Path $configBase 'opencode'
            $skillsDestination = Join-Path $configRoot 'skills'
        }
        qwen {
            $configRoot = Join-Path $HOME '.qwen'
            $skillsDestination = Join-Path $configRoot 'skills'
        }
    }
    if ($customDestination) { $skillsDestination = $Destination }
    Write-Host "Installing for $tool"
    $skillsDestination = Initialize-InstallDirectory $skillsDestination
    if ($customDestination) { $configRoot = Split-Path -Parent $skillsDestination }
    foreach ($name in $Skill) {
        Install-StoreItem (Join-Path $sourceRoot $name) (Join-Path $skillsDestination $name)
    }
    Install-Assets (Join-Path $PSScriptRoot "agents/$tool") (Join-Path $configRoot 'agents')
    Install-Assets (Join-Path $PSScriptRoot "hooks/$tool") (Join-Path $configRoot 'hooks')
}
Write-Host 'Done. Hook assets require registration in the selected tool configuration.'
