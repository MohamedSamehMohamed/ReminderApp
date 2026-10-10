param([switch]$Release)
$ErrorActionPreference='Stop'
if (Test-Path "$PSScriptRoot/../.tools/flutter/bin/flutter.bat") { . "$PSScriptRoot/env.ps1" }
flutter pub get
if($LASTEXITCODE -ne 0){throw 'Package restore failed'}
flutter gen-l10n
dart run build_runner build
if($LASTEXITCODE -ne 0){throw 'Code generation failed'}
flutter analyze
if($LASTEXITCODE -ne 0){throw 'Analysis failed'}
flutter test --coverage
if($LASTEXITCODE -ne 0){throw 'Tests failed'}
if($Release){
  if(!(Test-Path "$PSScriptRoot/../android/key.properties")){throw 'Owner signing config android/key.properties is required for a production release.'}
  flutter build apk --release
}else{flutter build apk --debug}
if($LASTEXITCODE -ne 0){throw 'APK build failed'}
