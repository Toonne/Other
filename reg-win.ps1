###
### Copy file somewhere to C:\-disk
### Run PS-command Set-ExecutionPolicy Unrestricted
### Then run this ps1-file
###

#Visual / User preference
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallPaper" -Value "" -Force | Out-Null #No wallpaper
New-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name "Background" -Value "0 0 0" -Force | Out-Null #Black background

#Disable Sticky / Filter / Toggle keys
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "Flags" -PropertyType "String" -Value "122" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -PropertyType "String" -Value "506" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" -Name "Flags" -PropertyType "String" -Value "58" -Force | Out-Null

#Explorer / User visual settings
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -PropertyType "DWORD" -Value "0" -Force | Out-Null #No checkboxes on icons (default on for touch screens)
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Open File Explorer to: [This PC]
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Show file extensions
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Show hidden files
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Show system files
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneShowAllFolders" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Show all folders in navigation pane
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SharingWizardOn" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Disable sharing wizard
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Don't show "multiple desk" ("Task View") button in taskbar
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -PropertyType "DWORD" -Value "2" -Force | Out-Null #Never combine taskbar
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Small icons
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "WebView" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Disable Web View
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbnailCache" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Disable creation of thumbs.db files
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Show seconds in system tray
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 -Force | Out-Null #Start button location (Left/Center, Win11)
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Value "0" -PropertyType DWORD -Force | Out-Null #Hide "people" in tray
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Never hide icons in tray
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Don't show search icon in taskbar
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -PropertyType "String" -Value 200 -Force | Out-Null #Faster menu experience
New-Item			   "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Value "" -Force | Out-Null #Disable Win11 context menu

#Privacy / User - settings
New-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -PropertyType "DWORD" -Value "1" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -PropertyType "DWORD" -Value "1" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -PropertyType "DWORD" -Value "0" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -PropertyType "DWORD" -Value "0" -Force | Out-Null
New-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -PropertyType "DWORD" -Value "1" -Force | Out-Null
New-Item			   "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null #Create path
New-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Feedback Frequency
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Force | Out-Null
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Force | Out-Null

#System / Misc - settings
New-Item			   "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Force | Out-Null #Create path
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "DisableSR" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Disable system restore
New-Item			   "HKLM:\Software\Policies\Microsoft\Windows NT\SystemRestore" -Force | Out-Null #Create path
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\SystemRestore" -Name "DisableSR" -PropertyType "DWORD" -Value "1" -Force | Out-Null #Disable system restore
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion" -Name "DevicePath" -PropertyType "ExpandString" -Value "%SystemRoot%\inf;D:\drivers" -Force | Out-Null #Update DevicePath
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Disable system restore
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Disable hibernate
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -PropertyType "DWORD" -Value "0" -Force | Out-Null #Disable hibernate

#Privacy / System - settings
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -PropertyType "DWORD" -Value "0" -Force | Out-Null

#Remove OneDrive
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT #mount HKCR (for OneDrive removal)
taskkill.exe /F /IM OneDrive.exe
#Start-Process -FilePath "C:\Windows\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait
Remove-Item -Path ("C:\Users\" + $env:USERNAME + "\OneDrive") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ("C:\OneDriveTemp") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ("C:\Users\" + $env:USERNAME + "\AppData\Local\Microsoft\OneDrive") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ("C:\ProgramData\Microsoft OneDrive") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}}" -Recurse -Force -ErrorAction SilentlyContinue

#Disable paging file
$computer = Get-WmiObject Win32_computersystem -EnableAllPrivileges
$computer.AutomaticManagedPagefile = $false
$computer.Put()
$currentPageFile = Get-WmiObject -Query "select * from Win32_PageFileSetting where name='C:\\pagefile.sys'"
$currentPageFile.delete()

#Services
Set-Service "WSearch" -StartupType Disabled #Disable Windows Search

#Other
fsutil behavior set disablecompression 1 #Disable NTFS compression
Disable-ComputerRestore -Drive "C:\" #Disable system restore

#Winget
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Script -Name winget-install -Force
winget-install.ps1
