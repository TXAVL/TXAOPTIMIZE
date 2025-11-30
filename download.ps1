# --- CẤU HÌNH ---
$DownloadUrl = "https://www.mediafire.com/file/xypc5zyg91t8s3x/TXATool.exe/file"
$SavePath = "$env:TEMP\TXATool.exe"
$VERSION    = "5.2"
$APPNAME    = "TXAAPP"
$TITLE_TEXT = "$APPNAME V$VERSION - Download Tool"

function Set-SafeTitle {
    param([string]$Title)

    # Loại bỏ ký tự điều khiển nguy hiểm (tránh lỗi console)
    $safeTitle = ($Title -replace '[\x00-\x1F\x7F]', '')

    try {
        $Host.UI.RawUI.WindowTitle = $safeTitle
    }
    catch {
        Write-Host "Không thể đặt tiêu đề cửa sổ!" -ForegroundColor Red
    }
}

# Set tiêu đề bằng biến có sẵn
Set-SafeTitle $TITLE_TEXT

# --- SET KÍCH THƯỚC CỬA SỔ NHỎ LẠI ---
try {
    mode con: cols=80 lines=20
    $Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(80, 20)
    $Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(80, 1000)
}
catch {
    # Nếu không set được, bỏ qua
}

# --- FUNCTION CLEAR UI (GIỮ HEADER) ---
function Show-Header {
    Write-Host "------------------------------------------------" -ForegroundColor Cyan
    Write-Host "           $APPNAME V$VERSION                          " -ForegroundColor Green
    Write-Host "------------------------------------------------" -ForegroundColor Cyan
    Write-Host ""
}

function Clear-UIKeepHeader {
    # Clear từ dòng 4 trở đi (giữ 3 dòng header + 1 dòng trống)
    $headerLines = 4  # 3 dòng header + 1 dòng trống
    $bufferHeight = [Console]::BufferHeight
    if ($bufferHeight -le 0) { $bufferHeight = 20 }
    
    # Xóa từ dòng header trở đi
    for ($i = $headerLines; $i -lt $bufferHeight; $i++) {
        try {
            [Console]::SetCursorPosition(0, $i)
            [Console]::Write((" " * 80))
        }
        catch {
            # Nếu không set được, bỏ qua
        }
    }
    
    # Đặt cursor về sau header
    [Console]::SetCursorPosition(0, $headerLines)
}

# --- GIAO DIỆN ---
Clear-Host
Show-Header

# --- FORMAT FUNCTIONS ---
function Format-Size {
    param([long]$Bytes)
    
    if ($Bytes -lt 1024) {
        return "{0:N2} B" -f $Bytes
    }
    elseif ($Bytes -lt 1MB) {
        return "{0:N2} KB" -f ($Bytes / 1KB)
    }
    elseif ($Bytes -lt 1GB) {
        return "{0:N2} MB" -f ($Bytes / 1MB)
    }
    else {
        return "{0:N2} GB" -f ($Bytes / 1GB)
    }
}

function Format-Speed {
    param([double]$BytesPerSecond)
    
    if ($BytesPerSecond -lt 1024) {
        return "{0:N2} B/s" -f $BytesPerSecond
    }
    elseif ($BytesPerSecond -lt 1MB) {
        return "{0:N2} KB/s" -f ($BytesPerSecond / 1KB)
    }
    elseif ($BytesPerSecond -lt 1GB) {
        return "{0:N2} MB/s" -f ($BytesPerSecond / 1MB)
    }
    else {
        return "{0:N2} GB/s" -f ($BytesPerSecond / 1GB)
    }
}

function Format-Time {
    param([double]$Seconds)
    
    if ($Seconds -lt 0) { return "0.00s" }
    
    if ($Seconds -lt 60) {
        return "{0:N2}s" -f $Seconds
    }
    elseif ($Seconds -lt 3600) {
        $minutes = [math]::Floor($Seconds / 60)
        $secs = $Seconds - ($minutes * 60)
        return "{0:N0}m {1:N2}s" -f $minutes, $secs
    }
    elseif ($Seconds -lt 86400) {
        $hours = [math]::Floor($Seconds / 3600)
        $remaining = $Seconds - ($hours * 3600)
        $minutes = [math]::Floor($remaining / 60)
        $secs = $remaining - ($minutes * 60)
        return "{0:N0}h {1:N0}m {2:N2}s" -f $hours, $minutes, $secs
    }
    elseif ($Seconds -lt 2592000) {
        $days = [math]::Floor($Seconds / 86400)
        $remaining = $Seconds - ($days * 86400)
        $hours = [math]::Floor($remaining / 3600)
        $remaining = $remaining - ($hours * 3600)
        $minutes = [math]::Floor($remaining / 60)
        return "{0:N0}d {1:N0}h {2:N0}m" -f $days, $hours, $minutes
    }
    elseif ($Seconds -lt 31536000) {
        $months = [math]::Floor($Seconds / 2592000)
        $remaining = $Seconds - ($months * 2592000)
        $days = [math]::Floor($remaining / 86400)
        return "{0:N0}mo {1:N0}d" -f $months, $days
    }
    else {
        $years = [math]::Floor($Seconds / 31536000)
        $remaining = $Seconds - ($years * 31536000)
        $months = [math]::Floor($remaining / 2592000)
        return "{0:N0}y {1:N0}mo" -f $years, $months
    }
}

function Calculate-ETA {
    param(
        [long]$RemainingBytes,
        [double]$CurrentSpeed,
        [double]$PreviousETA = 0,
        [double]$Alpha = 0.3
    )
    
    if ($CurrentSpeed -le 0) {
        return $PreviousETA
    }
    
    $instantETA = $RemainingBytes / $CurrentSpeed
    
    # Exponential moving average để làm mượt ETA
    if ($PreviousETA -eq 0) {
        return $instantETA
    }
    else {
        return ($Alpha * $instantETA) + ((1 - $Alpha) * $PreviousETA)
    }
}

function Download-FileWithProgress {
    param(
        [string]$Url,
        [string]$OutputPath
    )
    
    try {
        # Sử dụng HttpWebRequest để có control tốt hơn và hiển thị progress
        $request = [System.Net.HttpWebRequest]::Create($Url)
        $request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        $request.Timeout = 300000  # 5 phút
        $request.AllowAutoRedirect = $true  # Tự động follow redirect (cần cho MediaFire)
        
        # Lấy response
        $response = $request.GetResponse()
        $stream = $response.GetResponseStream()
        $fileStream = [System.IO.File]::Create($OutputPath)
        
        $buffer = New-Object byte[] 8192
        $downloaded = 0
        $totalSize = $response.ContentLength
        
        # Biến cho progress tracking
        $startTime = Get-Date
        $lastUpdate = $startTime
        $lastDownloaded = 0
        $lastPercent = -1
        $eta = 0
        $progressBarWidth = 30
        
        # Lưu vị trí dòng hiện tại cho progress (sau "Đang tải xuống...")
        $progressLine = [Console]::CursorTop
        
        while ($true) {
            $read = $stream.Read($buffer, 0, $buffer.Length)
            if ($read -eq 0) { break }
            
            $fileStream.Write($buffer, 0, $read)
            $downloaded += $read
            
            # Update progress mỗi 50ms để mượt hơn
            $now = Get-Date
            $timeDiff = ($now - $lastUpdate).TotalMilliseconds
            
            if ($timeDiff -ge 50) {
                $percent = if ($totalSize -gt 0) { [math]::Round(($downloaded / $totalSize) * 100, 2) } else { -1 }
                
                # Tính tốc độ (bytes per second)
                $elapsed = ($now - $lastUpdate).TotalSeconds
                $bytesDiff = $downloaded - $lastDownloaded
                $currentSpeed = if ($elapsed -gt 0) { $bytesDiff / $elapsed } else { 0 }
                
                # Tính ETA với exponential moving average
                if ($totalSize -gt 0 -and $currentSpeed -gt 0) {
                    $remaining = $totalSize - $downloaded
                    $eta = Calculate-ETA -RemainingBytes $remaining -CurrentSpeed $currentSpeed -PreviousETA $eta
                }
                
                # Vẽ progress bar với ký tự > chèn dần dần
                $filled = if ($totalSize -gt 0) { [math]::Floor(($downloaded / $totalSize) * $progressBarWidth) } else { 0 }
                $empty = $progressBarWidth - $filled
                # Dùng > thay vì # để tạo hiệu ứng chèn dần từ trái sang phải
                $progressBar = "[" + (">" * $filled) + (" " * $empty) + "]"
                
                # Format các giá trị
                $downloadedStr = Format-Size -Bytes $downloaded
                $totalStr = if ($totalSize -gt 0) { Format-Size -Bytes $totalSize } else { "??" }
                $percentStr = if ($percent -ge 0) { "$percent%" } else { "??%" }
                $speedStr = Format-Speed -BytesPerSecond $currentSpeed
                $etaStr = if ($eta -gt 0) { Format-Time -Seconds $eta } else { "??" }
                
                # Tạo status line
                $status = "$progressBar $downloadedStr/$totalStr $percentStr $speedStr ETA: $etaStr"
                
                # Update dòng hiện tại (overwrite, không append)
                # Đảm bảo status line luôn có độ dài cố định để xóa phần còn lại của dòng cũ
                $maxWidth = 80
                $paddedStatus = $status.PadRight($maxWidth)
                
                # Dùng Console để overwrite dòng đã lưu (không phải dòng hiện tại)
                try {
                    # Lưu vị trí cursor hiện tại
                    $savedTop = [Console]::CursorTop
                    $savedLeft = [Console]::CursorLeft
                    
                    # Về đầu dòng progress đã lưu
                    [Console]::SetCursorPosition(0, $progressLine)
                    # Xóa dòng bằng cách viết spaces
                    [Console]::Write((" " * $maxWidth))
                    # Về đầu dòng lại
                    [Console]::SetCursorPosition(0, $progressLine)
                    # Viết status mới với màu (dùng ANSI escape code)
                    $cyanCode = [char]27 + "[36m"  # Cyan color
                    $resetCode = [char]27 + "[0m"   # Reset color
                    [Console]::Write("$cyanCode$paddedStatus$resetCode")
                    
                    # Khôi phục vị trí cursor ban đầu
                    [Console]::SetCursorPosition($savedLeft, $savedTop)
                }
                catch {
                    # Fallback: dùng \r với padding và Write-Host
                    # Lưu vị trí hiện tại
                    $savedTop = [Console]::CursorTop
                    # Về dòng progress
                    [Console]::SetCursorPosition(0, $progressLine)
                    Write-Host $paddedStatus -NoNewline -ForegroundColor Cyan
                    # Khôi phục vị trí
                    [Console]::SetCursorPosition(0, $savedTop)
                }
                
                $lastUpdate = $now
                $lastDownloaded = $downloaded
                $lastPercent = $percent
            }
        }
        
        $fileStream.Close()
        $stream.Close()
        $response.Close()
        
        # Xóa dòng progress sau khi download xong
        try {
            $savedTop = [Console]::CursorTop
            $savedLeft = [Console]::CursorLeft
            [Console]::SetCursorPosition(0, $progressLine)
            [Console]::Write((" " * 80))
            [Console]::SetCursorPosition($savedLeft, $savedTop)
        }
        catch {
            # Nếu không xóa được, bỏ qua
        }
    }
    catch {
        # Fallback: dùng WebClient đơn giản
        Write-Host "Dang tai xuong..." -ForegroundColor Cyan
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
        $webClient.DownloadFile($Url, $OutputPath)
        Write-Host "`rDa tai xong!" -ForegroundColor Green
        Write-Host ""
    }
}

function Get-MediaFireDownloadLink {
    param([string]$MediaFireUrl)
    
    try {
        # MediaFire URL format: https://www.mediafire.com/file/{filekey}/{filename}/file
        # MediaFire thường tự redirect đến direct download link khi request với đúng headers
        
        # Cách 1: Parse HTML để lấy direct download link
        try {
            $html = Invoke-WebRequest -Uri $MediaFireUrl -UseBasicParsing -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            
            # Tìm direct download link trong HTML (MediaFire thường có trong download button)
            if ($html.Content -match 'href="(https?://download[^"]*mediafire[^"]+)"') {
                return $matches[1]
            }
            
            # Tìm trong data attributes hoặc JavaScript
            if ($html.Content -match '"(https?://[^"]*download[^"]*mediafire[^"]*)"') {
                return $matches[1]
            }
        }
        catch { }
        
        # Cách 2: MediaFire tự redirect khi tải, chỉ cần dùng URL gốc
        # Function Download-FileWithProgress sẽ tự follow redirect
        return $MediaFireUrl
    }
    catch {
        return $MediaFireUrl
    }
}

try {
    # Bước 1: Lấy link download
    Clear-UIKeepHeader
    Write-Host "Dang lay link download..." -ForegroundColor Yellow
    
    # Lấy link download thực sự từ MediaFire
    $realDownloadUrl = Get-MediaFireDownloadLink -MediaFireUrl $DownloadUrl
    
    # Bước 2: Báo đang tải và bắt đầu download
    Clear-UIKeepHeader
    Write-Host "Dang tai xuong..." -ForegroundColor Yellow
    Write-Host ""
    
    # Tải file với progress
    Download-FileWithProgress -Url $realDownloadUrl -OutputPath $SavePath

    # Bước 3: Kiểm tra và khởi động
    Clear-UIKeepHeader
    if (Test-Path $SavePath) {
        $fileSize = (Get-Item $SavePath).Length
        if ($fileSize -gt 1024) {
            Write-Host "Da tai xong! ($([math]::Round($fileSize/1MB, 2)) MB)" -ForegroundColor Green
            Write-Host "Dang khoi dong $APPNAME V$VERSION..." -ForegroundColor Yellow
    
            # Tự động chạy file
            Start-Process -FilePath $SavePath -Wait 
        }
        else {
            throw "File tai xuong bi loi (kich thuoc qua nho: $fileSize bytes)"
        }
    }
    else {
        throw "File khong ton tai sau khi tai xuong"
    }
}
catch {
    Write-Host ""
    Write-Host "LOI: Khong the tai hoac khoi dong tool." -ForegroundColor Red
    Write-Host "Chi tiet: " $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Loi thuong gap:" -ForegroundColor Gray
    Write-Host "- Link MediaFire can quyen truy cap" -ForegroundColor Gray
    Write-Host "- Mat mang hoac ket noi khong on dinh" -ForegroundColor Gray
    Write-Host "- File dang chay nen khong the ghi de" -ForegroundColor Gray
    Write-Host ""
    Read-Host "Nhan Enter de thoat..."
}


