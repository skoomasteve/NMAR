#______________________________________________
#      NMAR - NIC Monitor and Restarter
#______________________________________________
#
#Author: Steven Soward    --------   MIT License
#
#
#   
#              INSTRUCTIONS
#+++++++++++++++++++++++++++++++++++++++#
#Step 1 -- Define the $variables below if you need alerts and/or consolidated logging
#    
#
#Step 2 -- Ensure NMAR.ps1 (this file) exists in C:\NMAR [or] edit the .xml to call a different .ps1 location
#
#
#Step 3 -- import the NMAR.xml file into the Windows task scheduler
#---------------------------------------#
#
# OPTIONAL -- It is advisable to deploy NMAR using Group Policy when you need it on multiple computers.  
# Deploy the .xml task and write this NMAR.ps1 file (once the variables are defined) to servers within 
# desired OU(s) using group policy
#
# If you do this it is recommended to define the $ConsolidatedLogPath variable to a network location
#
#---------------------------------------#
#
#          OPTIONAL VARIABLES
#+++++++++++++++++++++++++++++++++++++++#

$SMTPServerAddress = #"somesmtpserver@contoso.com"
#this is the fqdn of your smtp server; remove the hash, keep the quotes

#---------------------------------------#

$AlertRecipients = ##"sampleemailaddress@something.net, sampledistrogroup@something.edu"
#alerts will go to who you specify above; use the format above removing the hashes and keeping the quotes

#---------------------------------------#

$AlertsFrom = ###"fromthisaddr@something.com"
#email alerts will appear to be from this address; remove the hashes, keep the quotes

#---------------------------------------#

$ConsolidatedLogPath = #"\\someserver\c$\NMAR\"

#Successful NIC repair events will be written to this network path
#--No need to define this if you are deploying this on only one machine as the logs are always written 
#locally in the C:\NMAR path



#___________________________________________________________________________________________
#___________________________________________________________________________________________
Start-Transcript -path c:\NMAR\Verbose-NICLog.txt -append

$defaultgateway=(Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty Nexthop)
if (test-Connection -ComputerName $defaultgateway -Count 2 -Quiet ) {
write-Host "Default Gateway is active " -ForegroundColor Green
}

else
	
    {
    write-Host "Default Gateway is unreachable || Resetting All Network Connections " -ForegroundColor Magenta
    disable-NetAdapter * -Confirm:$false
    Start-Sleep -s 7
    enable-NetAdapter * -Confirm:$false
    Start-Sleep -s 17
	$date = Get-Date -Format MM-dd-yyy-HH:mm
	$smtpServer = "$SMTPServerAddress"
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $msg.From = "$AlertsFrom"
    #$msg.ReplyTo = "deployerofNMAR@domain.com"
    $msg.To.Add("$AlertRecipients")
    $msg.Subject = "NIC Reset:$env:computername || $date "
    $msg.body = "	
    -----------------Connection Reestablished---------------------
--Network Adapters on $env:computername have been sucessfuly reset following NIC failure ||  $date--



+Verbose and standard Log files for this machine are located at: \\$env:computername\C$\NMAR




________________________________________________________________
             
			Alert generated by NMAR  
			 
 ==============================================================="
    $smtp.Send($msg)
	    $msg.IsBodyHTML = $true
	    $style = "<style>BODY{font:arial 10pt;}</style>"
	    $servermessage = "NIC Reset:$env:computername || $date"
	    "$env:computername Default Gateway Unreachable | NIC reset attempted - $date " >> C:\NMAR\downed-nics.txt
        "- Network connection on $env:computername repaired succesfully - $date " >> "$ConsolidatedLogPath\NMAR\downed-nics.txt"
        $defaultgateway=(Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty Nexthop)
if (test-Connection -ComputerName $defaultgateway -Count 2 -Quiet ) {
write-Host "Network connection repaired succesfully" -ForegroundColor Green
"- Network connection on $env:computername repaired succesfully -$date" >> C:\NMAR\downed-nics.txt
}
    
	}       
 
 Stop-Transcript



