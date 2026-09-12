param(
    [ValidateSet('Compile', 'Run', 'Test')][string]$Action = 'Run',
    [string]$RuntimePath = '',
    [string]$UserFolder = ''
)
$ErrorActionPreference = 'Stop'
$taskProject = Split-Path -Parent $PSScriptRoot
$taskBuildRoot = Join-Path $taskProject 'work'
New-Item -ItemType Directory -Path $taskBuildRoot -Force | Out-Null

if (!$RuntimePath) {
    $taskRuntimeConfig = Join-Path $env:ProgramData 'GameMakerStudio2-LTS2026\runtime.json'
    if (!(Test-Path -LiteralPath $taskRuntimeConfig)) {
        throw 'GameMaker LTS 2026 runtime not found. Open the project in GameMaker and use F5, or pass -RuntimePath.'
    }
    $taskConfig = Get-Content -LiteralPath $taskRuntimeConfig -Raw | ConvertFrom-Json
    $RuntimePath = $taskConfig.($taskConfig.active).Split('&')[0]
}
if (!$UserFolder) {
    $taskUserRoot = Join-Path $env:APPDATA 'GameMakerStudio2-LTS2026'
    $taskUsers = @(Get-ChildItem -LiteralPath $taskUserRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName 'local_settings.json')
    })
    if ($taskUsers.Count -eq 1) { $UserFolder = $taskUsers[0].FullName }
    else { throw 'Pass -UserFolder for the GameMaker profile to use, or run from the IDE with F5.' }
}
$taskIgor = Join-Path $RuntimePath 'bin\igor\windows\x64\Igor.exe'
$taskRunner = Join-Path $RuntimePath 'windows\x64\Runner.exe'
$taskCompileLog = Join-Path $taskBuildRoot 'compile.log'
$taskArgs = @("/uf=$UserFolder", "/rp=$RuntimePath", "/project=$taskProject\Side Quest.yyp",
    "/cache=$taskBuildRoot\cache", "/temp=$taskBuildRoot\temp", "/of=$taskBuildRoot\build\SideQuest",
    '--', 'Windows', 'Compile')
& $taskIgor @taskArgs *> $taskCompileLog
$taskCompileText = Get-Content -LiteralPath $taskCompileLog -Raw
if ($LASTEXITCODE -ne 0 -or $taskCompileText -match 'Error|Failed:|non-zero status' -or $taskCompileText -notmatch 'Igor complete') {
    Get-Content -LiteralPath $taskCompileLog -Tail 50
    throw "GameMaker compilation failed. See $taskCompileLog"
}
$taskGame = Join-Path $taskBuildRoot 'build\Side Quest.win'
if (!(Test-Path -LiteralPath $taskGame)) { throw 'Compiler produced no game file.' }
Write-Output "Compiled: $taskGame"
if ($Action -eq 'Compile') { exit 0 }

if ($Action -eq 'Run') {
    # This is the interactive game requested by the user, so show its window.
    Start-Process -FilePath $taskRunner -ArgumentList @('-game', ('"' + $taskGame + '"')) -WorkingDirectory (Split-Path -Parent $taskGame)
    exit 0
}

$taskLog = Join-Path $taskBuildRoot ('test-' + [guid]::NewGuid().ToString('N') + '.log')
$taskRunArgs = @('-game', ('"' + $taskGame + '"'), '-output', ('"' + $taskLog + '"'), '-jsonErrors', '--self-test')
$taskProcess = Start-Process -FilePath $taskRunner -ArgumentList $taskRunArgs -WorkingDirectory (Split-Path -Parent $taskGame) -WindowStyle Hidden -PassThru
if (!$taskProcess.WaitForExit(20000)) {
    Stop-Process -Id $taskProcess.Id
    throw "GameMaker test timed out. See $taskLog"
}
$taskLogText = Get-Content -LiteralPath $taskLog -Raw
($taskLogText -split "`r?`n" | Where-Object { $_ -match '^SQ_' }) | Write-Output
if ($taskProcess.ExitCode -ne 0 -or $taskLogText -match 'SQ_FAIL|Error|FATAL' -or
    $taskLogText -notmatch 'SQ_TEST_RESULTS pass=\d+ fail=0' -or $taskLogText -notmatch 'SQ_RUNTIME_SMOKE_PASS') {
    throw "GameMaker tests failed. See $taskLog"
}
Write-Output "All gameplay checks and the runtime smoke test passed. Log: $taskLog"
