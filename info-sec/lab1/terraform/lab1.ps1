# Task 1: Create users and set permissions using Computer Management and icacls

New-LocalUser -Name "CEO" -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force)
New-LocalUser -Name "Administrator_Alice" -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force)
New-LocalUser -Name "Manager_Anthony" -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force)
New-LocalUser -Name "Unknown_Supreme" -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force)
# Add users to the appropriate groups
Add-LocalGroupMember -Group "Administrators" -Member "CEO"
Add-LocalGroupMember -Group "Administrators" -Member "Administrator_Alice"
Add-LocalGroupMember -Group "Users" -Member "Manager_Anthony"
Add-LocalGroupMember -Group "Users" -Member "Unknown_Supreme"

# Task 2: Assign directory permissions

$CEOPath = "C:\CEO_Folder"
New-Item -Path $CEOPath -ItemType "Directory"
icacls $CEOPath /grant Administrator_Alice:(W)

# Task 3: Set password policies according to modern requirements

net accounts /minpwlen:12 /maxpwage:30 /minpwage:1 /uniquepw:5
# Enable password complexity
secedit /export /cfg C:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 0", "PasswordComplexity = 1") | sc C:\secpol.cfg
secedit /configure /db secedit.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY

# Task 4: Prohibit employees from performing specific actions

gpedit.msc /gpobject:User /name:"RestrictDisplaySettings"


# Task 5: Enable event logging

auditpol /set /subcategory:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /subcategory:"System" /success:enable /failure:enable

# Task 6: Take ownership of files created by other employees

$OtherFile = "C:\Users\OtherUser\Documents\File.txt"
takeown /f $OtherFile
icacls $OtherFile /grant CEO:(F)

# Task 7: Add additional users and implement complex access control schemes

New-LocalUser -Name "NewUser1" -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force)
New-LocalUser -Name "NewUser2" -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force)
$PathToProtect = "C:\SensitiveFolder"
New-Item -Path $PathToProtect -ItemType "Directory"
icacls $PathToProtect /grant NewUser1:(M) /deny NewUser2:(R)

# Task 8: Implement logging and session recording for privileged users

auditpol /set /subcategory:"Special Logon" /success:enable /failure:enable

# Task 9: Implement specified commands/tools

gpedit.msc /gpobject:User /name:"SetAppLockerRules"

# Task 10: Limit user accounts with AppLocker

$AppLockerRules = New-AppLockerPolicy -Path C:\Windows\System32\Applocker -Xml
Set-AppLockerPolicy -PolicyObject $AppLockerRules

# Task 11: Use NTFS Permissions Reporter to check the permissions you have granted

Start-Process "C:\Program Files (x86)\NTFS Permissions Reporter\NTFSPermReporter.exe"

# End of script