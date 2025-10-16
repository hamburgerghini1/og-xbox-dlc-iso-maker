# make-xbox-isos.ps1
# Converts all folders in Downloads (except extract-xiso) into ISO files for xemu
# Requires extract-xiso.exe to be in the "extract-xiso-Win64_Release" folder.

$basePath = "C:\Users\tommi\Downloads"
$extractXisoPath = Join-Path $basePath "extract-xiso-Win64_Release\artifacts\extract-xiso.exe"

if (!(Test-Path $extractXisoPath)) {
    Write-Error "extract-xiso.exe not found at $extractXisoPath"
    exit 1
}

# Output folder for ISOs
$outputDir = Join-Path $basePath "xemu_isos"
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Process each folder except extract-xiso
Get-ChildItem -Path $basePath -Directory | Where-Object {
    $_.Name -ne "extract-xiso-Win64_Release"
} | ForEach-Object {
    $folder = $_.FullName
    $isoName = "$($_.Name).iso"
    $isoPath = Join-Path $outputDir $isoName

    Write-Host "Creating ISO for '$($_.Name)'..."
    & $extractXisoPath -c "$folder" "$isoPath"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Created: $isoPath"
    } else {
        Write-Host "❌ Failed: $($_.Name)"
    }
}

Write-Host "`nAll done! ISOs saved in: $outputDir"
