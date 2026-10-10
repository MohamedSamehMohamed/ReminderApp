param([string]$RepositoryName='ReminderApp')
$ErrorActionPreference='Stop'
$projectRoot=Split-Path $PSScriptRoot -Parent
if(Test-Path "$projectRoot/.tools/gh/bin/gh.exe"){$env:PATH="$projectRoot/.tools/gh/bin;$env:PATH"}
Set-Location $projectRoot
gh auth status
if($LASTEXITCODE -ne 0){throw 'Complete gh auth login before publishing.'}
$apk=Join-Path $projectRoot 'artifacts/reminders-1.0.0-test.apk'
if(!(Test-Path $apk)){throw 'Build and verify the test APK before publishing.'}
gh auth setup-git
if($LASTEXITCODE -ne 0){throw 'Git authentication setup failed.'}
if($IsWindows){git config --local http.sslBackend schannel}
gh repo create $RepositoryName --private --source $projectRoot --remote origin --push --description 'Offline Flutter reminders for Android, with English and Arabic support.'
if($LASTEXITCODE -ne 0){throw 'Repository creation or push failed; check the result before retrying.'}
$repoUrl=gh repo view --json url --jq .url
if($LASTEXITCODE -ne 0){throw 'Could not read the created repository.'}
gh release create v1.0.0-test $apk --repo $repoUrl --target main --prerelease --title 'Reminders 1.0.0 test build' --notes-file "$projectRoot/docs/RELEASE_NOTES.md"
if($LASTEXITCODE -ne 0){throw 'APK release upload failed.'}
Write-Output $repoUrl
