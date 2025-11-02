<#
.SYNOPSIS
Basic anonymization of log files for AI testing.
Replaces IPs, usernames, hostnames, and environment names with placeholders.
#>

param(
    [string]$InputFolder = "sample_logs",
    [string]$OutputFolder = "sample_logs/anonymized"
)

# Create output folder if it doesn't exist
if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# Process each .log file
Get-ChildItem $InputFolder -Filter *.log | ForEach-Object {
    $content = Get-Content $_.FullName

    # Replace example patterns
    $content = $content -replace '\b\d{1,3}(\.\d{1,3}){3}\b', '<IP>'
    $content = $content -replace '\buser[A-Za-z0-9]+\b', '<USER>'
    $content = $content -replace '\bhost[A-Za-z0-9]+\b', '<HOST>'
    $content = $content -replace '\bENV_[A-Za-z0-9]+\b', '<ENV>'

    $outputFile = Join-Path $OutputFolder $_.Name
    $content | Set-Content $outputFile
}

Write-Host "Anonymization complete. Check $OutputFolder"
