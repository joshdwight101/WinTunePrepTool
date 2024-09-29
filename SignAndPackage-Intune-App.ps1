# Check if the script is running as an Administrator
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch the script with administrator rights
    Start-Process PowerShell -Verb RunAs -ArgumentList "-File",("`"" + $MyInvocation.MyCommand.Path + "`"")
    Exit
}

# Script Options
$initial_Directory = 'C:\Temp'	# Set this to the directory you want the dialog to open in by default

# Set the path to where you have WinTunePrepTool located / should also be where this script is located
$intune_path = '\Path\Where\Location\WinTunePrepTool' # do not use the exe in path as we do that automatically in our script
$output_directory = 'C:\Temp'	# this is the directory you want the intune app files to be exported to once packaged


# Open File Browser to Choose the Package Install Script for Intune
Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = ("$initial_Directory")
$dialog.Filter = "PowerShell script files (*.ps1)|*.ps1|All files (*.*)|*.*"
$dialog.Title = "Select the PowerShell script to be used as the install script for the Intune App Package"
$dialog.ShowDialog() | Out-Null
$selectedFile = $dialog.FileName

# Get the Project Directory from the file chosen
if (-not [string]::IsNullOrEmpty($selectedFile)) {
    $projectDirectory = Split-Path -Path $selectedFile -Parent
    Write-Host "Project directory: $projectDirectory"
}

# This script is set to sign using the signature that is stored in "CurrentUser\My"
$cert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
# Sign all Powershell Scripts in Project Directory and Subdirectories
Get-ChildItem -Path "$projectDirectory" -Recurse -Filter *.ps1 | ForEach-Object {
    $file = $_.FullName
    Write-Host "Signing $file"
    Set-AuthenticodeSignature -FilePath $file -Certificate $cert
}

# Arguments for Intune Prep Tool
$intune_app = "$intune_path\IntuneWinAppUtil.exe"
$source_path = "$projectDirectory"
$install_script = "$selectedFile"
$output_path = "$output_directory"

# Run Intune Prep Tool with the "-Overwrite" parameter
Start-Process "$intune_app" -ArgumentList "-c `"$source_path`" -s `"$install_script`" -o `"$output_path`" -q"
