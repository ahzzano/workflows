param(
    [ValidateSet('pi', 'codex', 'claude')]
    [string[]] $Platform = @('pi', 'codex', 'claude')
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$homeDir = $env:USERPROFILE

function Install-Link($source, $target) {
    if ($source -eq $target) { return }
    $existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if ($existing -and $existing.LinkType -and @($existing.Target) -contains $source) { return }
    if ($existing) {
        if ($existing.PSIsContainer -and -not $existing.LinkType) {
            throw "Refusing to replace directory: $target"
        }
        Remove-Item -LiteralPath $target -Force
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
    Write-Host "Installed $target"
}

function Install-Agents($destination, $extension) {
    foreach ($source in Get-ChildItem -LiteralPath (Join-Path $repo 'agents') -File -Filter "*.$extension") {
        Install-Link $source.FullName (Join-Path $destination $source.Name)
    }
}

function Install-Skills($destination) {
    foreach ($source in Get-ChildItem -LiteralPath (Join-Path $repo 'skills') -Directory) {
        if (Test-Path -LiteralPath (Join-Path $source.FullName 'SKILL.md') -PathType Leaf) {
            Install-Link $source.FullName (Join-Path $destination $source.Name)
        }
    }
}

foreach ($tool in $Platform) {
    switch ($tool) {
        pi {
            Install-Agents (Join-Path $homeDir '.pi/agent/agents') 'md'
            Install-Skills (Join-Path $homeDir '.pi/agent/skills')
        }
        codex {
            Install-Agents (Join-Path $homeDir '.codex/agents') 'toml'
            Install-Skills (Join-Path $homeDir '.agents/skills')
        }
        claude {
            Install-Agents (Join-Path $homeDir '.claude/agents') 'md'
            Install-Skills (Join-Path $homeDir '.claude/skills')
        }
    }
}
