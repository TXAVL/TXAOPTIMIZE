$exePath = "$env:TEMP\Unikey-TXA.exe"
$exeUrl = "https://raw.githubusercontent.com/TXAVL/TXAOPTIMIZE/main/Unikey%20-%20TXA.exe"

Write-Host "Đang tải file..."
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

Write-Host "Tải thành công! Đang chạy..."
Start-Process $exePath
