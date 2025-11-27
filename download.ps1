[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$exePath = "$env:TEMP\Unikey-TXA.exe"
$exeUrl = "https://raw.githubusercontent.com/TXAVL/TXAOPTIMIZE/main/Unikey%20-%20TXA.exe"
f
echo "Dang tai file..."
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

echo "Tai thanh cong! Dang chay..."
Start-Process $exePath

