$ErrorActionPreference = 'Stop'
$installer = Join-Path (Split-Path -Parent $PSScriptRoot) 'install.ps1'
$originalHome = $env:USERPROFILE
$tempHome = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $tempHome | Out-Null
$env:USERPROFILE = $tempHome

try {
    & $installer -Platform pi,codex,claude
    $piAgent = Join-Path $tempHome '.pi/agent/agents/researcher.md'
    $codexAgent = Join-Path $tempHome '.codex/agents/researcher.toml'
    $claudeAgent = Join-Path $tempHome '.claude/agents/researcher.md'
    $skill = Join-Path $tempHome '.claude/skills/tdd'
    foreach ($path in @($piAgent, $codexAgent, $claudeAgent, $skill)) {
        if (-not (Get-Item -LiteralPath $path).LinkType) { throw "Not linked: $path" }
    }

    & $installer
    Remove-Item -LiteralPath $claudeAgent
    Set-Content -LiteralPath $claudeAgent -Value 'outdated'
    Remove-Item -LiteralPath $piAgent
    New-Item -ItemType SymbolicLink -Path $piAgent -Target $claudeAgent | Out-Null
    Remove-Item -LiteralPath $skill
    New-Item -ItemType Directory -Path $skill | Out-Null
    try {
        & $installer -Platform claude | Out-Null
        throw 'Expected directory collision to fail'
    } catch {
        if ($_.Exception.Message -notlike 'Refusing to replace directory:*') { throw }
    }
    Remove-Item -LiteralPath $skill
    & $installer -Platform pi,claude | Out-Null
    $repo = Split-Path -Parent $PSScriptRoot
    if ((Get-Item -LiteralPath $claudeAgent).Target -ne (Join-Path $repo 'agents/researcher.md')) { throw 'Existing file not replaced' }
    if ((Get-Item -LiteralPath $piAgent).Target -ne (Join-Path $repo 'agents/researcher.md')) { throw 'Different link not replaced' }
    if ((Get-Item -LiteralPath $skill).Target -ne (Join-Path $repo 'skills/tdd')) { throw 'Skill not linked' }
    Write-Host 'Windows installer smoke test passed'
} finally {
    $env:USERPROFILE = $originalHome
    foreach ($directory in @('.pi/agent/agents', '.codex/agents', '.claude/agents', '.pi/agent/skills', '.agents/skills', '.claude/skills')) {
        $path = Join-Path $tempHome $directory
        if (Test-Path -LiteralPath $path) {
            Get-ChildItem -LiteralPath $path -Force | Where-Object LinkType | Remove-Item -Force
        }
    }
    Remove-Item -LiteralPath $tempHome -Recurse -Force
}
