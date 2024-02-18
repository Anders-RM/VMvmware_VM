Start-Transcript -Path $PSScriptRoot"\powershell.log" -Append -IncludeInvocationHeader

# Check if VMware.PowerCLI is installed
if (-not (Get-Module -ListAvailable -Name VMware.PowerCLI)) {
    # If not installed, install VMware.PowerCLI
    Install-Module VMware.PowerCLI -Scope CurrentUser -Confirm:$false
}

Import-Module VMware.PowerCLI

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'VMware Connection'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

# Localhost button
$localhostButton = New-Object System.Windows.Forms.Button
$localhostButton.Location = New-Object System.Drawing.Point(10,10)
$localhostButton.Size = New-Object System.Drawing.Size(120,40)
$localhostButton.Text = 'Localhost'
$localhostButton.Add_Click({
    Connect-VIServer -Server "localhost"
    $form.Close()
})
$form.Controls.Add($localhostButton)

# Remote server button
$remoteButton = New-Object System.Windows.Forms.Button
$remoteButton.Location = New-Object System.Drawing.Point(140,10)
$remoteButton.Size = New-Object System.Drawing.Size(120,40)
$remoteButton.Text = 'Remote Server'
$remoteButton.Add_Click({
    $form.Close()
    # Remote server connection
    $inputBox = New-Object System.Windows.Forms.Form
    $inputBox.Text = 'Remote Server Details'
    $inputBox.Size = New-Object System.Drawing.Size(300,200)
    $inputBox.StartPosition = 'CenterScreen'

    # Server input
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Enter vCenter Server:'
    $inputBox.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $inputBox.Controls.Add($textBox)

    # Confirm button
    $confirmButton = New-Object System.Windows.Forms.Button
    $confirmButton.Location = New-Object System.Drawing.Point(10,70)
    $confirmButton.Size = New-Object System.Drawing.Size(260,30)
    $confirmButton.Text = 'Connect'
    $confirmButton.Add_Click({
        $vcServer = $textBox.Text
        $credential = Get-Credential -Message "Enter your credentials for $vcServer"
        Connect-VIServer $vcServer -Credential $credential
        $inputBox.Close()
    })
    $inputBox.Controls.Add($confirmButton)

    $inputBox.ShowDialog()
})
$form.Controls.Add($remoteButton)

$form.ShowDialog()

Stop-Transcript