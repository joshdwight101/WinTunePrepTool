
# Import the necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

$buttonWidth = 200

# Create a function to get the workstation name
function Get-WorkstationName {
    $env:COMPUTERNAME
}

# Create a function to get the MAC address
function Get-MacAddress {
    $macAddress = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | Select-Object -ExpandProperty MacAddress
    $macAddress
}

# Create a function to get the hardware hash
function Get-HardwareHash {
    # Replace this with your logic to obtain the hardware hash
    # For demonstration purposes, I'll use a placeholder value
    "YourHardwareHashHere"
}

# Create a function to get the serial number
function Get-SerialNumber {
    $serialNumber = Get-WmiObject Win32_BIOS | Select-Object -ExpandProperty SerialNumber
    $serialNumber
}

<#
# Create a function to get the AutoPilot Hash
function Get-AutoPilotHash {
    # Ensure that NuGet provider is installed and up to date
    # This is required in order to get the hardware hash
    Write-Host "Ensuring that NuGet provider is installed and up to date."
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Import-PackageProvider NuGet -Force
    # Install the Get-WindowsAutoPilotInfo script from PowerShell Gallery
    Write-Host "Installing the Get-WindowsAutoPilotInfo script from PowerShell Gallery."
    Install-Script -Name Get-WindowsAutoPilotInfo -Force
    # Run the script and copy the output to the clipboard
    Write-Host "Running the script and copying the output to clipboard."
    Get-WindowsAutoPilotInfo | Set-Clipboard
    Write-Host "Autpilot Hardware Hash has been copied to clipboard."
}
#>

# Create the GUI form
$form = New-Object Windows.Forms.Form
$form.Text = "Workstation Info Tool by Joshua Dwight"
$form.Size = New-Object Drawing.Size(400, 250)

# Create buttons
$btnWorkstationName = New-Object Windows.Forms.Button
$btnWorkstationName.Text = "Workstation Name"
$btnWorkstationName.Location = New-Object Drawing.Point(20, 20)
$btnWorkstationName.Width = $buttonWidth
$btnWorkstationName.Add_Click({
    Get-WorkstationName | Set-Clipboard
})

# Create label for Workstation Name
$btnWorkstationNameLabel = New-Object Windows.Forms.Label
$btnWorkstationNameLabel.Text = Get-WorkstationName
$btnWorkstationNameLabel.Location = New-Object Drawing.Point(250, 25)

#Create Button for Mac Address
$btnMacAddress = New-Object Windows.Forms.Button
$btnMacAddress.Text = "Mac Address"
$btnMacAddress.Location = New-Object Drawing.Point(20, 60)
$btnMacAddress.Width = $buttonWidth
$btnMacAddress.Add_Click({
    Get-MacAddress | Set-Clipboard
})

# Create Label for Mac Address
$btnMacAddressLabel = New-Object Windows.Forms.Label
$btnMacAddressLabel.Text = Get-MacAddress
$btnMacAddressLabel.Width = 150
$btnMacAddressLabel.Location = New-Object Drawing.Point(250, 65)

# Create a button for the hardware hash
$btnHardwareHash = New-Object Windows.Forms.Button
$btnHardwareHash.Text = "Hardware Hash"
$btnHardwareHash.Location = New-Object Drawing.Point(20, 100)
$btnHardwareHash.Width = $buttonWidth
$btnHardwareHash.Add_Click({
    # Get-AutoPilotHash
    Write-Host "This is currently a work-in-progress..."
})

$btnSerialNumber = New-Object Windows.Forms.Button
$btnSerialNumber.Text = "Serial Number"
$btnSerialNumber.Location = New-Object Drawing.Point(20, 140)
$btnSerialNumber.Width = $buttonWidth
$btnSerialNumber.Add_Click({
    Get-SerialNumber | Set-Clipboard
})

# Create Label for Serial Number
$btnSerialNumberLabel = New-Object Windows.Forms.Label
$btnSerialNumberLabel.Text = Get-SerialNumber
$btnSerialNumberLabel.Width = 150
$btnSerialNumberLabel.Location = New-Object Drawing.Point(250, 145)

# Add buttons to the form
$form.Controls.Add($btnWorkstationName)
$form.Controls.Add($btnWorkstationNameLabel)
$form.Controls.Add($btnMacAddress)
$form.Controls.Add($btnMacAddressLabel)
$form.Controls.Add($btnHardwareHash)
$form.Controls.Add($btnSerialNumber)
$form.Controls.Add($btnSerialNumberLabel)

# Show the form
$form.ShowDialog()
