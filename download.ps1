[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$exeUrl = "https://raw.githubusercontent.com/TXAVL/TXAOPTIMIZE/main/Unikey%20-%20TXA.exe"
$exePath = "$env:TEMP\Unikey-TXA.exe"

Write-Output "Dang tai file cai dat..."

# WebRequest de lay progress dung moi phien ban PowerShell
$req = [System.Net.HttpWebRequest]::Create($exeUrl)
$res = $req.GetResponse()
$total = $res.ContentLength
$stream = $res.GetResponseStream()

$fs = New-Object IO.FileStream($exePath, 'Create')
$buffer = New-Object byte[] 8192
$read = 0

while (($count = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
    $fs.Write($buffer, 0, $count)
    $read += $count
    $percent = [math]::Round(($read / $total) * 100, 2)
    Write-Progress -Activity "Dang tai Unikey TXA" -Status "$percent% hoan tat" -PercentComplete $percent
}

$fs.Close()
$stream.Close()
$res.Close()

Write-Output "Tai xong: $exePath"

$confirm = Read-Host "Ban co muon chay file nay? (Y/N)"
if ($confirm -eq "Y") {
    Start-Process $exePath
} else {
    Write-Output "Da huy thuc thi file."
}
