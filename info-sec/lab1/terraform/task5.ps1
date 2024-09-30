# Enable auditing for logon events
auditpol /set /subcategory:"Logon" /success:enable /failure:enable

# Enable auditing for system events
auditpol /set /subcategory:"System Integrity" /success:enable /failure:enable

# Verify the settings
auditpol /get /subcategory:"Logon"
auditpol /get /subcategory:"System Integrity"

Write-Host "Event logging for logon and system events has been activated."