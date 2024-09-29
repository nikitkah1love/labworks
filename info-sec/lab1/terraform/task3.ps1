# Task 3: Set password policies in Windows

# Set the minimum password length (e.g., 12 characters)
net accounts /minpwlen:12

# Set the maximum password age (e.g., 30 days)
net accounts /maxpwage:30

# Set the minimum password age (e.g., 1 day)
net accounts /minpwage:1

# Ensure password history (e.g., users must use 5 unique passwords before reuse)
net accounts /uniquepw:5

# Export the current security settings to a temporary configuration file
secedit /export /cfg C:\secpol.cfg

# Modify the file to enforce password complexity (0 = off, 1 = on)
# Complexity ensures passwords contain a mix of uppercase, lowercase, numbers, and symbols
(Get-Content C:\secpol.cfg) -replace "PasswordComplexity = 0", "PasswordComplexity = 1" | Set-Content C:\secpol.cfg

# Apply the modified security settings
secedit /configure /db secedit.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY

# Clean up the temporary configuration file
Remove-Item C:\secpol.cfg
