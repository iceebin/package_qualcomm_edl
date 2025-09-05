param(
    [string]$Publisher,
    [string]$Version,
    [string]$Tip
)

# 检查参数
if ([string]::IsNullOrWhiteSpace($Publisher) -or [string]::IsNullOrWhiteSpace($Version) -or [string]::IsNullOrWhiteSpace($Tip)) {
    Write-Host "参数: [string]Publisher [string]Version [string]Tip" -ForegroundColor Red
    exit 1
}

$ConfigPath = "Config.xml"
$CurrentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DistDir = Join-Path $CurrentDir "dist"
if (!(Test-Path $DistDir)) {
    New-Item -ItemType Directory -Path $DistDir | Out-Null
}
$PublishDate = [long](([datetime]::UtcNow - [datetime]'1970-01-01').TotalMilliseconds)

# 读取并修改Config.xml
[xml]$xml = [System.IO.File]::ReadAllText($ConfigPath, [System.Text.Encoding]::UTF8)
$packetInfo = $xml.GeekFlashPacket.PacketInfo
if ($packetInfo -eq $null) {
    Write-Host "Config.xml 格式错误，未找到 PacketInfo 节点！" -ForegroundColor Red
    exit 1
}
$packetInfo.Publisher = $Publisher
$packetInfo.PublishVersion = $Version
$packetInfo.Tip = $Tip
$packetInfo.PublishDate = $PublishDate.ToString()
$xml.Save($ConfigPath)

# 获取所有需要压缩的文件（排除dist文件夹）
$items = Get-ChildItem -Path $CurrentDir -Exclude "dist" | Select-Object -ExpandProperty FullName

# 压缩到dist文件夹
$ZipName = "GeekFlashPacket_$($Version)_$(Get-Date -Format yyyyMMddHHmmss).zip"
$ZipPath = Join-Path $DistDir $ZipName
Compress-Archive -Path $items -DestinationPath $ZipPath

Write-Host ("发布完成，生成文件：{0}" -f $ZipPath) -ForegroundColor Green