# Define new user groups and users
$newUsers = @{
    "Developers" = @("Dev1")
    "Support" = @("Support1")
}

# Create new users and groups
foreach ($group in $newUsers.Keys) {
    # Create group
    New-LocalGroup -Name $group -Description "$group group" -ErrorAction SilentlyContinue

    foreach ($user in $newUsers[$group]) {
        # Create user
        New-LocalUser -Name $user -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -FullName $user -Description "$group user" -PasswordNeverExpires
        # Add user to group
        Add-LocalGroupMember -Group $group -Member $user
    }
}

# Create directories for new groups
$devDir = "C:\Developers"
$supportDir = "C:\Support"
New-Item -Path $devDir -ItemType Directory -Force
New-Item -Path $supportDir -ItemType Directory -Force

# Set permissions for Developers directory
icacls $devDir /grant "Developers:(OI)(CI)F" /grant "GodMode:(OI)(CI)R"

# Set permissions for Support directory
icacls $supportDir /grant "Support:(OI)(CI)F" /grant "GodMode:(OI)(CI)R"

# Final message
Write-Host "New groups and users created, and permissions set."