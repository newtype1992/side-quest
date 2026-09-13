param([string[]]$Scenes=@('combat','animation-noise','animation-hype','animation-death','animation-fire','animation-reload','animation-roll','animation-hit'))
$ErrorActionPreference='Stop'
$taskProject=Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$taskGame=(Resolve-Path -LiteralPath (Join-Path $taskProject 'work\build\Side Quest.win')).Path
New-Item -ItemType Directory -Path (Join-Path $taskProject 'work\hypeman-v8') -Force | Out-Null
$taskRunner='C:\ProgramData\GameMakerStudio2-LTS2026\Cache\runtimes\runtime-2026.0.0.23\windows\x64\Runner.exe'
foreach($scene in $Scenes) {
  $taskLog=Join-Path $taskProject ('work\hypeman-v8\capture-'+$scene+'.log')
  [IO.File]::WriteAllText($taskLog,'')
  $taskArguments=@('-game',('"'+$taskGame+'"'),'-output',('"'+$taskLog+'"'),'-jsonErrors','--capture','--capture-scene',$scene,'--test-output','capture')
  $taskRun=Start-Process -FilePath $taskRunner -ArgumentList $taskArguments -WorkingDirectory (Split-Path -Parent $taskGame) -WindowStyle Hidden -PassThru
  if(!$taskRun.WaitForExit(20000)){Stop-Process -Id $taskRun.Id;throw "Capture timed out: $scene"}
  if($taskRun.ExitCode -ne 0){throw "Capture failed: $scene"}
  Write-Output "Captured $scene"
}
