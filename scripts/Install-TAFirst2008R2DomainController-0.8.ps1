Function Install-TAFirst2008R2DomainController {
<#

.NOTES
Version: 0.1
Author : Tom Arbuthnot lyncdup.com
Disclaimer: Use completely at your own risk. Test before using on any system.
Do not run any script you don't understand.
Do not use on production systems.

.LINK
#>

# Sets that -Whatif and -Confirm should be allowed
[cmdletbinding(SupportsShouldProcess=$true)]

Param 	(
	 	[Parameter(Mandatory=$True,
                   HelpMessage="Domain name in the form domain.int")]
        [string[]]$Domain,

		[Parameter(Mandatory=$True,
                   HelpMessage="NetBios Domain name e.g. domain")]
        [string[]]$NetBiosDomainName,
		
        [Parameter(Mandatory=$false,
                   HelpMessage="First AD Site Name")]
        [string[]]$ADSite = 'lab-site1',
		
		[Parameter(Mandatory=$false,
                   HelpMessage="This entry specifies the domain functional level. This entry is based on the levels that exist in the forest when a new domain is created in an existing forest.")]
        [string[]]$Domainlevel = '4',
		
		[Parameter(Mandatory=$false,
                   HelpMessage="You must not use this entry when you install a new domain controller in an existing forest. The ForestLevel entry replaces the SetForestVersion entry that is available in Windows Server 2003.")]
        [string[]]$ForestLevel = '4',
		
		[Parameter(Mandatory=$False,
                   HelpMessage="Directory Services Safe Mode Password ")]
        [string[]]$DSSafeModePassword = 'Pa$$w0rd',
		
		
		[Parameter(Mandatory=$false,
                   HelpMessage="Error Log location, default C:\<Command Name>_ErrorLog.txt")]
		[string]$ErrorLog = "c:\$($myinvocation.mycommand)_ErrorLog.txt",
        [switch]$LogErrors
		
		) #Close Parameters

Begin 	{
    	Write-Verbose "Starting $($myinvocation.mycommand)"
		Write-Verbose "Error log will be $ErrorLog"
		
		# Set everytihng ok to true, this is used to stop the script if we have an issue
		# Each Try Catch Finally block, or action (within the process block of the function) depends on $EverythingOK being true
		# A dependancy step will set $everything_ok to $false, therefore other steps will be skipped
		# Variable in the script scope
		$script:EverythingOK = $true
		
		# Catch Actions Function to avoid repeating code, don't need to . source within a script
                    Function ErrorCatch-Actions 
                    {
					Param 	(
							[Parameter(Mandatory=$false,
							HelpMessage="Switch to Allow Errors to be Caught without setting EverythingOK to False, stopping other aspects of the script running")]
							# By default any errors caught will set $EverythingOK to false causing other parts of the script to be skipped
							[switch]$SetEverythingOKVariabletoTrue
							) # Close Parameters
                    # Set Everything OK to false to avoid running dependant actions
				    If ($SetEverythingOKVariabletoTrue) {$script:EverythingOK = $true}
					else {$script:EverythingOK = $false}
                    Write-Output "Everything OK set to $script:EverythingOK"
               	    # Write Errors to Screen
                    Write-Output " "
                    Write-Warning "%%% Error Catch Has Been Triggered (To log errors to text file start script with -LogErrors switch) %%%"
                    Write-Output " "
                    Write-Warning "Last Error was:"
                    Write-Output " "
				    Write-Error $Error[0]
               	       if ($LogErrors) {
									    # Add Date to Error Log File
                                        Get-Date -format "dd/MM/yyyy HH:mm" | Out-File $ErrorLog -Append
									    # Output Error to Error Log file
									    $Error | Out-File $ErrorLog -Append
                                        "%%%%%%%%%%%%%%%%%%%%%%%%%% LINE BREAK BETWEEN ERRORS %%%%%%%%%%%%%%%%%%%%%%%%%%" | Out-File $ErrorLog -Append
                                        " " | Out-File $ErrorLog -Append
									    Write-Warning "Errors Logged to $ErrorLog"
                                        # Clear Error Log Variable
                                        $Error.Clear()
                                        } #Close If
                    } # Close Error-CatchActons Function
		    
		} #Close Function Begin Block

Process {
    		
		
		If ($script:EverythingOK)
		{
		Try 	{
                
					# Install the correct Server Role for DC
			Import-Module ServerManager
			
			# Best to install these by splitting them out
			
			add-windowsfeature GPMC, Backup-Features, Backup, Backup-Tools,DNS,WINS-Server -Verbose
			
			Add-WindowsFeature AS-NET-Framework -Verbose
			
			Add-WindowsFeature AD-Domain-Services, ADDS-Domain-Controller -Verbose
			
			# DomainLevel
			# 0 | 2 | 3
			# No default
			# This entry specifies the domain functional level. This entry is based on the levels that exist in the forest when a new domain is created in an existing forest. Value descriptions are as follows:
			# 0 = Windows 2000 Server native mode
			# 2 = Windows Server 2003
			# 3 = Windows Server 2008
			# $Domainlevel = 4
			
			# http://support.microsoft.com/kb/947034
			
			# ForestLevel
			# 0 | 2 | 3
			# This entry specifies the forest functional level when a new domain is created in a new forest as follows:
			# 0 = Windows 2000 Server
			# 2 = Windows Server 2003
			# 3 = Windows Server 2008
			# You must not use this entry when you install a new domain controller in an existing forest. The ForestLevel entry replaces the SetForestVersion entry that is available in Windows Server 2003.
			
			# $ForestLevel = 4
			
			
			# Build our DC Promo Config file
$DCPromoFile = @"
[DCINSTALL]
InstallDNS=yes
NewDomain=forest
NewDomainDNSName=$Domain
DomainNetBiosName=$NetBiosDomainName
SiteName=$ADSite
ReplicaorNewDomain=domain
ForestLevel=$ForestLevel
DomainLevel=$Domainlevel
ConfirmGC=Yes
SafeModeAdminPassword=$DSSafeModePassword
RebootonCompletion=No
"@
			
			# Output config file to text file
			$DCPromoFile | out-file c:\dcpromoanswerfile.txt  -Force
			
			# Run DCPromo with the correct config
			dcpromo.exe /unattend:c:\dcpromoanswerfile.txt
             
			 } # Close Try Block
			
		Catch 	{ErrorCatch-Actions}
			   
		
		} # Close First If Everthing OK Block
		
		
		# Next Script Action or Try,Catch Block goes here
		
		} #Close Function Process Block

End 	{
    	Write-Verbose "Ending $($myinvocation.mycommand)"
		} #Close Function End Block
	
 
} #End Function
# SIG # Begin signature block
# MIIUigYJKoZIhvcNAQcCoIIUezCCFHcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUhU7P3a/tTZme63/YFyjCse7z
# IfagghHLMIIETzCCA7igAwIBAgIEBydYPTANBgkqhkiG9w0BAQUFADB1MQswCQYD
# VQQGEwJVUzEYMBYGA1UEChMPR1RFIENvcnBvcmF0aW9uMScwJQYDVQQLEx5HVEUg
# Q3liZXJUcnVzdCBTb2x1dGlvbnMsIEluYy4xIzAhBgNVBAMTGkdURSBDeWJlclRy
# dXN0IEdsb2JhbCBSb290MB4XDTEwMDExMzE5MjAzMloXDTE1MDkzMDE4MTk0N1ow
# bDELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
# d3d3LmRpZ2ljZXJ0LmNvbTErMCkGA1UEAxMiRGlnaUNlcnQgSGlnaCBBc3N1cmFu
# Y2UgRVYgUm9vdCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMbM
# 5XPm+9S75S0tMqbf5YE/yc0lSbZxKsPVlDRnogocsF9ppkCxxLeyj9CYpKlBWTrT
# 3JTWPNt0OKRKzE0lgvdKpVMSOO7zSW1xkX5jtqumX8OkhPhPYlG++MXs2ziS4wbl
# CJEMxChBVfvLWokVfnHoNb9Ncgk9vjo4UFt3MRuNs8ckRZqnrG0AFFoEt7oT61EK
# mEFBIk5lYYeBQVCmeVyJ3hlKV9Uu5l0cUyx+mM0aBhakaHPQNAQTXKFx01p8Vdte
# ZOE3hzBWBOURtCmAEvF5OYiiAhF8J2a3iLd48soKqDirCmTCv2ZdlYTBoSUeh10a
# UAsgEsxBu24LUTi4S8sCAwEAAaOCAW8wggFrMBIGA1UdEwEB/wQIMAYBAf8CAQEw
# UwYDVR0gBEwwSjBIBgkrBgEEAbE+AQAwOzA5BggrBgEFBQcCARYtaHR0cDovL2N5
# YmVydHJ1c3Qub21uaXJvb3QuY29tL3JlcG9zaXRvcnkuY2ZtMA4GA1UdDwEB/wQE
# AwIBBjCBiQYDVR0jBIGBMH+heaR3MHUxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw9H
# VEUgQ29ycG9yYXRpb24xJzAlBgNVBAsTHkdURSBDeWJlclRydXN0IFNvbHV0aW9u
# cywgSW5jLjEjMCEGA1UEAxMaR1RFIEN5YmVyVHJ1c3QgR2xvYmFsIFJvb3SCAgGl
# MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly93d3cucHVibGljLXRydXN0LmNvbS9j
# Z2ktYmluL0NSTC8yMDE4L2NkcC5jcmwwHQYDVR0OBBYEFLE+w2kD+L9HAdSYJhoI
# Au9jZCvDMA0GCSqGSIb3DQEBBQUAA4GBAC52hdk3lm2vifMGeIIxxEYHH2XJjrPJ
# VHjm0ULfdS4eVer3+psEwHV70Xk8Bex5xFLdpgPXp1CZPwVZ2sZV9IacDWejSQSV
# Mh3Hh+yFr2Ru1cVfCadAfRa6SQ2i/fbfVTBs13jGuc9YKWQWTKMggUexRJKEFhtv
# Srwhxgo97TPKMIIGsTCCBZmgAwIBAgIQD9eQJnAMTUYPGCMg3R3R2zANBgkqhkiG
# 9w0BAQUFADBzMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkw
# FwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTIwMAYDVQQDEylEaWdpQ2VydCBIaWdo
# IEFzc3VyYW5jZSBDb2RlIFNpZ25pbmcgQ0EtMTAeFw0xMjAzMTQwMDAwMDBaFw0x
# MzAzMTkxMjAwMDBaMH8xCzAJBgNVBAYTAkdCMRYwFAYDVQQIEw1IZXJ0Zm9yZHNo
# aXJlMRIwEAYDVQQHEwlTdGV2ZW5hZ2UxITAfBgNVBAoTGFRob21hcyBDaGFybGVz
# IEFyYnV0aG5vdDEhMB8GA1UEAxMYVGhvbWFzIENoYXJsZXMgQXJidXRobm90MIIB
# IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjmejCa70Nm5qUUTDyXN9+s+N
# H/fGCsfueuvSqeqNVfWe97yo3TbittzZRrHHp5k35l6qOE6KloPufDYE0t3mEkpp
# o5wET7lQS6BkaTe3q713Hpn9BVm7MgAkWbSv3q6jWI+MXFZvTfNrf/3iPTrmckSe
# OeH7Xko4hgK/dzHpEgfnKeIjNH8r1tW2OJpOYJlKiQTkxA9u+ke619L2BozBxHPr
# Ta0+BfhwIYrN07vU+OlnPyaE9vxbVM3NuWAfg8xQyZ0T1jDstCBuEIuoeYXx/U5r
# I57M/INHzLjIjfT4E25nplXJbLUbYpIMPi91fuF0ugx4ylfXVN/mxiFEBtjmywID
# AQABo4IDMzCCAy8wHwYDVR0jBBgwFoAUl0gD6xUIa7myWCPMlC7xxmXSZI4wHQYD
# VR0OBBYEFIHKmIS12dfTzkctyjSzZ4mcctjgMA4GA1UdDwEB/wQEAwIHgDATBgNV
# HSUEDDAKBggrBgEFBQcDAzBpBgNVHR8EYjBgMC6gLKAqhihodHRwOi8vY3JsMy5k
# aWdpY2VydC5jb20vaGEtY3MtMjAxMWEuY3JsMC6gLKAqhihodHRwOi8vY3JsNC5k
# aWdpY2VydC5jb20vaGEtY3MtMjAxMWEuY3JsMIIBxAYDVR0gBIIBuzCCAbcwggGz
# BglghkgBhv1sAwEwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0
# LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIB
# UgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkA
# YwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEA
# bgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMA
# UABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkA
# IABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwA
# aQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8A
# cgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMA
# ZQAuMIGGBggrBgEFBQcBAQR6MHgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRp
# Z2ljZXJ0LmNvbTBQBggrBgEFBQcwAoZEaHR0cDovL2NhY2VydHMuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0SGlnaEFzc3VyYW5jZUNvZGVTaWduaW5nQ0EtMS5jcnQwDAYD
# VR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOCAQEANTLgVekp3Jjy7+yHi/M2WT9q
# vejN+3UL45MRVwj3Xdlh4o+i3NO/Sjt8BdOJAC8v9fInt1e4OPgnOYKl5Mx9FQZu
# 5zcb/kz6fLEKpHrp0KX0pilPOGG5qTFtvvIv8auPnHYCXeNK8zFb/uDSP9dq/bk5
# aT/ggBP73CUWt2osvYYy1XUn0UrQcz3G1mqkL71cd0LF8c4dYn9WPiFwyb3joEVs
# 0zyPBBwVQcUMgTMkGMiu8J/auP2wby0MG/p62fUp48MqdDeS4fMr2vVzkAEJ2bH+
# 0IZ/bljwBfJk7Q3twCNX9bVcLPgP+XYYTF8S+2crHKx6AESZJLnmWUA4A527azCC
# Br8wggWnoAMCAQICEAgcV+5dcOuboLFSDHKcGwkwDQYJKoZIhvcNAQEFBQAwbDEL
# MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
# LmRpZ2ljZXJ0LmNvbTErMCkGA1UEAxMiRGlnaUNlcnQgSGlnaCBBc3N1cmFuY2Ug
# RVYgUm9vdCBDQTAeFw0xMTAyMTAxMjAwMDBaFw0yNjAyMTAxMjAwMDBaMHMxCzAJ
# BgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5k
# aWdpY2VydC5jb20xMjAwBgNVBAMTKURpZ2lDZXJ0IEhpZ2ggQXNzdXJhbmNlIENv
# ZGUgU2lnbmluZyBDQS0xMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# xfkj5pQnxIAUpIAyX0CjjW9wwOU2cXE6daSqGpKUiV6sI3HLTmd9QT+q40u3e76d
# wag4j2kvOiTpd1kSx2YEQ8INJoKJQBnyLOrnTOd8BRq4/4gJTyY37zqk+iJsiMlK
# G2HyrhBeb7zReZtZGGDl7im1AyqkzvGDGU9pBXMoCfsiEJMioJAZGkwx8tMr2IRD
# rzxj/5jbINIJK1TB6v1qg+cQoxJx9dbX4RJ61eBWWs7qAVtoZVvBP1hSM6k1YU4i
# y4HKNqMSywbWzxtNGH65krkSz0Am2Jo2hbMVqkeThGsHu7zVs94lABGJAGjBKTzq
# Pi3uUKvXHDAGeDylECNnkQIDAQABo4IDVDCCA1AwDgYDVR0PAQH/BAQDAgEGMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMIIBwwYDVR0gBIIBujCCAbYwggGyBghghkgBhv1s
# AzCCAaQwOgYIKwYBBQUHAgEWLmh0dHA6Ly93d3cuZGlnaWNlcnQuY29tL3NzbC1j
# cHMtcmVwb3NpdG9yeS5odG0wggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5ACAA
# dQBzAGUAIABvAGYAIAB0AGgAaQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABlACAA
# YwBvAG4AcwB0AGkAdAB1AHQAZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAgAG8A
# ZgAgAHQAaABlACAARABpAGcAaQBDAGUAcgB0ACAARQBWACAAQwBQAFMAIABhAG4A
# ZAAgAHQAaABlACAAUgBlAGwAeQBpAG4AZwAgAFAAYQByAHQAeQAgAEEAZwByAGUA
# ZQBtAGUAbgB0ACAAdwBoAGkAYwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBpAGwA
# aQB0AHkAIABhAG4AZAAgAGEAcgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABlAGQA
# IABoAGUAcgBlAGkAbgAgAGIAeQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wDwYDVR0T
# AQH/BAUwAwEB/zB/BggrBgEFBQcBAQRzMHEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9v
# Y3NwLmRpZ2ljZXJ0LmNvbTBJBggrBgEFBQcwAoY9aHR0cDovL2NhY2VydHMuZGln
# aWNlcnQuY29tL0RpZ2lDZXJ0SGlnaEFzc3VyYW5jZUVWUm9vdENBLmNydDCBjwYD
# VR0fBIGHMIGEMECgPqA8hjpodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRIaWdoQXNzdXJhbmNlRVZSb290Q0EuY3JsMECgPqA8hjpodHRwOi8vY3JsNC5k
# aWdpY2VydC5jb20vRGlnaUNlcnRIaWdoQXNzdXJhbmNlRVZSb290Q0EuY3JsMB0G
# A1UdDgQWBBSXSAPrFQhrubJYI8yULvHGZdJkjjAfBgNVHSMEGDAWgBSxPsNpA/i/
# RwHUmCYaCALvY2QrwzANBgkqhkiG9w0BAQUFAAOCAQEAggXpha+nTL+vzj2y6mCx
# aN5nwtLLJuDDL5u1aw5TkIX2m+A1Av/6aYOqtHQyFDwuEEwomwqtCAn584QRk4/L
# YEBW6XcvabKDmVWrRySWy39LsBC0l7/EpZkG/o7sFFAeXleXy0e5NNn8OqL/UCnC
# CmIE7t6WOm+gwoUPb/wI5DJ704SuaWAJRiac6PD//4bZyAk6ZsOnNo8YT+ixlpIu
# Tr4LpzOQrrxuT/F+jbRGDmT5WQYiIWQAS+J6CAPnvImQnkJPAcC2Fn916kaypVQv
# jJPNETY0aihXzJQ/6XzIGAMDBH5D2vmXoVlH2hKq4G04AF01K8UihssGyrx6TT0m
# RjGCAikwggIlAgEBMIGHMHMxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMjAwBgNVBAMTKURpZ2lD
# ZXJ0IEhpZ2ggQXNzdXJhbmNlIENvZGUgU2lnbmluZyBDQS0xAhAP15AmcAxNRg8Y
# IyDdHdHbMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBTpo8BEvzadGst+m2VP5bKwCkiO2zANBgkq
# hkiG9w0BAQEFAASCAQAMP7VXPPLkvZHj9+Y0YXUGOjyCw+sHsBFm/xcu4Kxo8J/3
# 67x8yfR+pc8X1FQiwH6ZV4TMRP2Q0BxEvH1rkMzCFyMN0HhOdteq0i5+pwuo9pEy
# SMaLBgyhstrGwMhn5T7fhCPyWwc/dL7VDtBEquZZv4CaK+QEAySHAopRbFiaUJC8
# +HxY+j57mb36lwolI6ahAZhQqaHgOwu+xfmrA71VaPhxcAnK0HdVzR1EMK1dHRxo
# 6Miwptj49LdNq0iTkNA9tHUUNa3zFsgwxbVoUBq2VkJ3Esu/bn0MS7zOkCRV4afI
# NuVxuRjmL+44crLL5+12miePwPrh6jC7yjx3yddS
# SIG # End signature block
