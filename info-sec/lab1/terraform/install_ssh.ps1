# Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the SSH Server service
Start-Service sshd

# Set the SSH Server service to start automatically
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the firewall rule is configured. It should be created automatically by setup.
if (-not (Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP")) {
    Write-Host "Creating firewall rule for OpenSSH Server"
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

# Optional: Add the current user to the sshd administrators group
# Add-LocalGroupMember -Group "Administrators" -Member $env:USERNAME

Write-Host "OpenSSH Server installation and configuration completed."

#########################################################################################

# Define user groups and users
$users = @{
    "GodMode" = "SysAdmin"
    "Boss" = "CEO"
    "Admin" = @("Alice", "Gabi")
    "Managers" = @("Anthony", "Elisa", "Jolie", "Tom")
    "Unknown" = "Supreme"
}

# Create users
foreach ($group in $users.Keys) {
    if ($users[$group] -is [array]) {
        foreach ($user in $users[$group]) {
            New-LocalUser -Name $user -Password (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -FullName $user -Description "$group User"
            Add-LocalGroupMember -Group $group -Member $user
        }
    } else {
        New-LocalUser -Name $users[$group] -Password (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -FullName $users[$group] -Description "$group User"
        Add-LocalGroupMember -Group $group -Member $users[$group]
    }
}

# Set password policy
Set-LocalUser -Name "CEO" -PasswordNeverExpires $false
net accounts /minpwlen:8 /maxpwage:30

# Create directories
$generalDir = "C:\General"
$specialDir = "C:\Special"

New-Item -ItemType Directory -Path $generalDir
New-Item -ItemType Directory -Path $specialDir

# Set permissions
icacls $generalDir /grant "Everyone:(OI)(CI)F"
icacls $specialDir /grant "CEO:(OI)(CI)F" /grant "Alice:(OI)(CI)R" /grant "Gabi:(OI)(CI)R"

# Prohibit certain actions using Group Policy (this requires administrative privileges)
# Note: This part is typically done via Group Policy Management Console (GPMC) and not directly via PowerShell.
# You can use the following command to open GPMC:
# gpmc.msc

# Enable auditing
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
auditpol /set /subcategory:"System" /success:enable /failure:enable

# Take ownership of files (example)
# Assuming files are created in C:\General by other users
$files = Get-ChildItem -Path $generalDir
foreach ($file in $files) {
    takeown /f $file.FullName
}

# Implement Applocker (requires Windows 10 Enterprise or higher)
# This is a complex task and typically requires a GUI or specific policy settings.

# Logging and session recording for privileged users
# This is typically done through Windows Event Viewer and not directly via PowerShell.

# Final message
Write-Host "Script execution completed. Please review the settings and permissions."