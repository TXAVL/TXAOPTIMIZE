[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$exePath = "$env:TEMP\Unikey-TXA.exe"
$exeUrl = "https://raw.githubusercontent.com/TXAVL/TXAOPTIMIZE/main/Unikey%20-%20TXA.exe"

Write-Output "Đang tải file..."
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

Write-Output "Tải thành công! Đang chạy..."
Start-Process $exePath
