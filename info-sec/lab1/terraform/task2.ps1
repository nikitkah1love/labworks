# Create the CEO folder
$ceoFolder = "C:\CEO"
New-Item -Path $ceoFolder -ItemType Directory -Force

# Set permissions for the CEO folder
# CEO: Full control
# Alice: Write permissions

# Remove existing permissions
icacls $ceoFolder /inheritance:r

# Grant CEO full control
icacls $ceoFolder /grant "CEO:(OI)(CI)F"

# Grant Alice write permissions
icacls $ceoFolder /grant "Alice:(OI)(CI)W"

# Final message
Write-Host "Folder 'C:\CEO' created and permissions set."