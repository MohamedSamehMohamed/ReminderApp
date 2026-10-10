$projectRoot = Split-Path $PSScriptRoot -Parent
$env:PATH = "$projectRoot\.tools\flutter\bin;$projectRoot\.tools\gh\bin;$env:PATH"
$env:ANDROID_HOME = "$projectRoot\.tools\android-sdk"
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
if(Test-Path "$projectRoot/.tools/jdk21") {
  $env:JAVA_HOME=(Get-ChildItem "$projectRoot/.tools/jdk21" -Directory | Select-Object -First 1).FullName
}
$env:PUB_CACHE = "$projectRoot\.tools\pub-cache"
$env:GRADLE_USER_HOME = "$projectRoot\.tools\gradle"
$env:JAVA_TOOL_OPTIONS = '-Djavax.net.ssl.trustStoreType=Windows-ROOT -Djavax.net.ssl.trustStore=NONE'
