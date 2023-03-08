#!/usr/local/bin/pwsh

# Update PowerShell with PowerShell
# First published in The Radical Admin, March 2023
# https://community.jumpcloud.com/t5/radical-admin-blog/bg-p/radical-admin

# All blame to Charles Mangin
# Mastodon: https://oldbytes.space/@option8
# Provided without warranties, guarantees, or manatees.


$AvailableVersion = ((Invoke-WebRequest "https://api.github.com/repos/PowerShell/PowerShell/releases/latest").Content | ConvertFrom-Json).tag_name
$InstalledVersion = "v" + $PSVersionTable.PSVersion

if ($AvailableVersion -eq $InstalledVersion) {
    Write-Output "Installed version $InstalledVersion is the latest."
 #   Exit # Nothing to do.
}

Write-Output "Available version $AvailableVersion is newer than installed version $InstalledVersion."
# All that's left to do is everything.

# Build the download URL
# eg: https://github.com/PowerShell/PowerShell/releases/download/v7.3.3/powershell-7.3.3-osx-arm64.pkg

# Filename depends on the CPU architecture.
if ($PSVersionTable.OS.Contains("ARM64")) {
    $Architecture = "arm64" # CPU is Apple Silicon
} else {
    $Architecture = "x64" # CPU is Intel
}

# Build the filename - version number without "v"
$PKGFileName = "powershell-" + $AvailableVersion.Replace("v","") + "-osx-" + $Architecture + ".pkg"

# Complete the URL/path - including version number *with* "v"
$DownloadURL = "https://github.com/PowerShell/PowerShell/releases/download/" + $AvailableVersion + "/" + $PKGFileName

# Download the PKG
Write-Output "Downloading $DownloadURL"
Invoke-WebRequest $DownloadURL -OutFile "/tmp/powershell-latest.pkg"

# Install the PKG
sudo /usr/sbin/installer -pkg /tmp/powershell-latest.pkg -target /

# Success or Failure?
if ($LASTEXITCODE -ne 0) {
    Write-Output "There was an error installing PowerShell. Check install.log for more information."
    Exit 1 # Danger, Will Robinson!
} else {
    Write-Output "Successfully installed PowerShell version $AvailableVersion"
    # On success, clean up the download
    Remove-Item "/tmp/powershell-latest.pkg"
}