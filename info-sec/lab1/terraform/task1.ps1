# Define user groups and users
$users = @{
    "GodMode" = @("SystemsAdmin")
    "Boss" = @("CEO")
    "Administration" = @("Alice", "Gabi")
    "Managers" = @("Anthony", "Elisa", "Jolie", "Tom")
    "Unknown" = @("Supreme")
}

# Create users and groups
foreach ($group in $users.Keys) {
    # Create group
    New-LocalGroup -Name $group -Description "$group group" -ErrorAction SilentlyContinue

    foreach ($user in $users[$group]) {
        # Create user
        New-LocalUser -Name $user -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -FullName $user -Description "$group user" -PasswordNeverExpires
        # Add user to group
        Add-LocalGroupMember -Group $group -Member $user
    }
}

# Create directories
$generalDir = "C:\General"
$specialDir = "C:\Special"
New-Item -Path $generalDir -ItemType Directory -Force
New-Item -Path $specialDir -ItemType Directory -Force

# Set permissions for General directory
icacls $generalDir /grant Everyone:(OI)(CI)F

# Set permissions for Special directory
icacls $specialDir /grant "CEO:(OI)(CI)F" /grant "Alice:(OI)(CI)R" /grant "Gabi:(OI)(CI)R"


# Higher-level group users can read objects from lower-level groups
icacls $generalDir /grant "GodMode:(OI)(CI)F" /grant "Boss:(OI)(CI)R" /grant "Administration:(OI)(CI)R" /grant "Managers:(OI)(CI)R"
icacls $specialDir /grant "GodMode:(OI)(CI)F" /grant "Boss:(OI)(CI)R" /grant "Administration:(OI)(CI)R" /grant "Managers:(OI)(CI)R"

# Complex permission scheme for Unknown (Supreme)
# Example: Full control on Special directory, read-only on General directory
icacls $specialDir /grant "Supreme:(OI)(CI)F"
icacls $generalDir /grant "Supreme:(OI)(CI)R"

# Final message
Write-Host "Script execution completed. Please review the settings and permissions."