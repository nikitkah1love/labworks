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
