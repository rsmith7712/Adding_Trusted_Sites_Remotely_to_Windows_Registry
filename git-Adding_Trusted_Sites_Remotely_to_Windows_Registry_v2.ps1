<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.129
	 Created on:   	10/27/2016 2:46 PM
	 Created by:   	Richard Smith
	 Organization: 	
	 Filename:     	git-Adding_Trusted_Sites_Remotely_to_Windows_Registry_v2.ps1
	===========================================================================
	.DESCRIPTION
		Script copies files to remote systems and adds Trusted Sites to Windows Registry
#>

# Elevating script permissions to bypass UAC roadblocks
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
	Echo "This script needs to be run As Admin"
	Break
}

# Enable PowerShell Remote Sessions
Enable-PSRemoting -Force;

# Set Execution Policy to Unrestricted
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Sets the Server Inclusion List from a Text File
$ServerList = Get-Content "\\FILE_SERVER\Shares\UTILITY\list_Remote_TrustedSites_ADD.txt"

ForEach ($Server in $ServerList)
{
	## Office.com Entries
	set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	set-location ZoneMap\Domains
	new-item office.com
	set-location office.com
	new-itemproperty . -Name * -Value 2 -Type DWORD
	
	## Microsoft.com Entries
	set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	set-location ZoneMap\Domains
	new-item microsoft.com
	set-location microsoft.com
	new-itemproperty . -Name * -Value 2 -Type DWORD
}