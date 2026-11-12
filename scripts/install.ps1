param([Parameter(Mandatory=$true)][string]$Version)
$ErrorActionPreference = 'Stop'
if ($Version -notmatch '^v[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$') { throw 'Choose a published version, e.g. v0.1.0' }
$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
switch ($architecture) { 'X64' {$arch='amd64'} 'Arm64' {$arch='arm64'} default {throw 'Unsupported CPU architecture'} }
$name = "archinario_$($Version.Substring(1))_windows_$arch.zip"
$base = "https://github.com/archinario/archinario-agent/releases/download/$Version"
$work = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
New-Item -ItemType Directory $work | Out-Null
try {
  $archive = Join-Path $work $name
  Invoke-WebRequest "$base/$name" -OutFile $archive
  Invoke-WebRequest "$base/SHA256SUMS" -OutFile (Join-Path $work 'SHA256SUMS')
  $line = Get-Content (Join-Path $work 'SHA256SUMS') | Where-Object { ($_ -split '\s+')[1] -ceq $name }
  if (@($line).Count -ne 1) { throw 'Missing or duplicate release checksum' }
  $expected = ($line -split '\s+')[0]
  if ($expected -notmatch '^[a-fA-F0-9]{64}$' -or (Get-FileHash $archive -Algorithm SHA256).Hash -ine $expected) { throw 'Checksum mismatch; nothing installed' }
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zip = [IO.Compression.ZipFile]::OpenRead($archive)
  try {
    $entry = $zip.GetEntry('archinario.exe')
    if (!$entry) { throw 'Binary missing from archive' }
    $temporaryBinary = Join-Path $work 'archinario.exe'
    [IO.Compression.ZipFileExtensions]::ExtractToFile($entry,$temporaryBinary,$true)
  } finally { $zip.Dispose() }
  $destination = if ($env:ARCHINARIO_INSTALL_DIR) { $env:ARCHINARIO_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'Archinario\bin' }
  New-Item -ItemType Directory -Force $destination | Out-Null
  $binary = Join-Path $destination 'archinario.exe'
  Copy-Item $temporaryBinary $binary -Force
  & $binary version
  Write-Output "Installed: $binary. Use this absolute path in MCP settings."
} finally { Remove-Item -Recurse -Force $work }
