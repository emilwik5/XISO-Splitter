# Xbox ISO Splitter
# Splits large XISO files into FATX-safe 3.5 GB chunks.

param([string]$File)
if (-not $File) {
    Write-Host "No ISO file path provided."
    Write-Host "Please drag and drop an ISO onto the batch file or run from PowerShell with:"
    Write-Host "   .\SplitXISO.ps1 'C:\Path\To\Game.iso'"
    Read-Host "`nPress Enter to exit"
    exit
}
if (!(Test-Path $File)) {
    Write-Host "File not found: $File" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

$Limit   = 3584MB
$Buffer  = New-Object byte[] 1MB
$Stream  = [IO.File]::OpenRead($File)
$Part    = 1
$Base    = [IO.Path]::GetFileNameWithoutExtension($File)
$Dir     = [IO.Path]::GetDirectoryName($File)
$Written = 0
$OutPath = Join-Path $Dir ("{0}.{1}.iso" -f $Base,$Part)
$Out     = [IO.File]::OpenWrite($OutPath)

Write-Host "`nSplitting file into 3.5GB parts..." -ForegroundColor Cyan

while (($Read = $Stream.Read($Buffer,0,$Buffer.Length)) -gt 0) {
    if (($Written + $Read) -gt $Limit) {
        $Remain = $Limit - $Written
        $Out.Write($Buffer,0,$Remain)
        $Out.Close()
        $Part++
        $OutPath = Join-Path $Dir ("{0}.{1}.iso" -f $Base,$Part)
        $Out = [IO.File]::OpenWrite($OutPath)
        $Out.Write($Buffer,$Remain,$Read-$Remain)
        $Written = $Read - $Remain
    } else {
        $Out.Write($Buffer,0,$Read)
        $Written += $Read
    }
}

$Out.Close()
$Stream.Close()

Write-Host "Split Done! Files will be saved in the same folder." -ForegroundColor Green
Read-Host "Press Enter to exit"

