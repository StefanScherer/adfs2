# https://msmvps.com/blogs/richardsiddaway/archive/2009/08/30/enable-ping.aspx

$fw = New-Object -ComObject HNetCfg.FWPolicy2 
#$fw.Rules | Format-Table Name, Enabled, Direction -AutoSize 

$fw.Rules | where {$_.Name -like "File and Printer Sharing (Echo Request - ICMPv4-In)"} |  
foreach {$_.Enabled = $true} 

$fw.Rules | where {$_.Name -like "File and Printer Sharing (Echo Request - ICMPv4-In)"} |  
Format-Table Name, Direction, Protocol, Profiles, Enabled -AutoSize 
