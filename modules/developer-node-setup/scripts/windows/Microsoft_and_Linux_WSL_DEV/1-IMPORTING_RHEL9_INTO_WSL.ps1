# IMPORTING_RHEL9_INTO_WSL.ps1
# Script 1 (PowerShell)
# This script is designed to be run on Windows 10/11 with WSL2 enabled.
# It installs 7-Zip, extracts a .tar.gz file, and sets up WSL with RHEL9.
# Ensure you have the necessary permissions to run this script.
# This script requires administrative privileges to run successfully.
# Make sure to run this script in an elevated PowerShell session.
# Run as Administrator

# Define paths and variables
$sevenZipUrl = "https://www.7-zip.org/a/7z2301-x64.msi" # Check for latest version manually
$installerPath = "$env:TEMP\7zip.msi"
$sevenZipPath = "${env:ProgramFiles}\7-Zip\7z.exe"
$tarGzFile = "RHEL9-x86_64.tar.gz"
$tarFile = "RHEL9-x86_64.tar"
$defaultWSLPath = "$env:LOCALAPPDATA\Packages\RHEL9.LocalState"

# Check if 7-Zip is installed, install if missing
if (!(Test-Path $sevenZipPath)) {
 Write-Host "Downloading and installing 7-Zip..."
 Invoke-WebRequest -Uri $sevenZipUrl -OutFile $installerPath
 Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $installerPath /qn" -Wait
 Remove-Item -Path $installerPath -Force
}

# Extract the .tar.gz file to a .tar file
Write-Host "Extracting $tarGzFile..."
Start-Process -FilePath $sevenZipPath -ArgumentList "e $tarGzFile" -Wait

# Enable WSL and required features
Write-Host "Enabling WSL..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Update WSL
wsl --update
wsl --set-default-version 2

# Import the extracted tar file into WSL's default directory
Write-Host "Importing RHEL9-x86_64 into WSL..."
wsl --import RHEL9-x86_64 $defaultWSLPath $tarFile --version 2

Write-Host "RHEL9-x86_64 has been successfully imported into WSL at the default location!"

#End of script



