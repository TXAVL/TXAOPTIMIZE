[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# URLs
$scriptRaw = "https://raw.githubusercontent.com/TXAVL/TXAOPTIMIZE/main/download.ps1"
$exeUrl = "https://raw.githubusercontent.com/TXAVL/TXAOPTIMIZE/main/Unikey%20-%20TXA.exe"

# Paths
$exePath = "$env:TEMP\Unikey-TXA.exe"
$scriptPath = "$env:TEMP\download.ps1"

Write-Output "Dang tai file cai dat (Co tien trinh)..."

$webClient = New-Object System.Net.WebClient
$webClient.DownloadProgressChanged += {
    Write-Progress -Activity "Dang tai Unikey TXA" -Status "$($_.ProgressPercentage)% hoan tat" -PercentComplete $_.ProgressPercentage
}
$webClient.DownloadFileCompleted += {
    Write-Output "Tai xong!"
}
$webClient.DownloadFileAsync($exeUrl, $exePath)

# Cho den khi file tai xong
while ($webClient.IsBusy) { Start-Sleep -Milliseconds 200 }

# Hoi nguoi dung co muon chay hay khong
$confirm = Read-Host "Ban co muon chay phan mem vua tai? (Y/N)"

if ($confirm -eq "Y") {
    Start-Process $exePath
} else {
    Write-Output "Da huy thuc thi file."
}

# ====== Auto Update Script ======
Write-Output "`nKiem tra cap nhat script..."
Invoke-WebRequest -Uri $scriptRaw -OutFile $scriptPath -UseBasicParsing
Write-Output "Script moi da tai: $scriptPath"
