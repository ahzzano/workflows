param(
    [ValidateSet('pi', 'omp', 'codex', 'claude')]
    [string[]] $Platform = @('pi', 'omp', 'codex', 'claude')
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
            # Only the old per-file layout (symlinks) may be replaced.
            $children = @(Get-ChildItem -LiteralPath $target -Force)
            if ($children | Where-Object { -not $_.LinkType }) {
                throw "Refusing to replace directory: $target"
            }
            $children | Remove-Item -Force
        }
        Remove-Item -LiteralPath $target -Force
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
    Write-Host "Installed $target"
}

function Install-Tool($dir, $instructions, $skillsDir = (Join-Path $dir 'skills')) {
    Install-Link (Join-Path $repo 'skills') $skillsDir
    Install-Link (Join-Path $repo 'agents') (Join-Path $dir 'agents')
    Install-Link (Join-Path $repo 'AGENTS.md') (Join-Path $dir $instructions)
}

foreach ($tool in $Platform) {
    switch ($tool) {
        pi { Install-Tool (Join-Path $homeDir '.pi/agent') 'AGENTS.md' }
        omp { Install-Tool (Join-Path $homeDir '.omp/agent') 'AGENTS.md' }
        codex { Install-Tool (Join-Path $homeDir '.codex') 'AGENTS.md' (Join-Path $homeDir '.agents/skills') }
        claude { Install-Tool (Join-Path $homeDir '.claude') 'CLAUDE.md' }
    }
}
