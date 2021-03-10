# NMAR [NIC Monitor and Restarter]
## What is it?

NMAR [NIC Monitor and Restarter] was created to reduce windows server downtime associated with stalled network interfaces. NMAR runs as a scheduled task; it checks communication with its default gateway at regular intervals and automatically restarts any network interfaces if communication with the default gateway cannot be established. NMAR sends email alerts upon successful connection repair and logs its own activity. NMAR is designed for Windows machines running PowerShell 4 or newer but can be used on older machines (i.e. server 2008) using the NMAR-Legacy-Server2008.ps1 script.  NMAR can be run on any windows machine that has powershell.

## How do I set it up?

For a single instance:

  1. Create a folder in C:\ named 'NMAR'
  2. Move NMAR.ps1 to C:\NMAR
  3. If you need email alerts and consolidated logging, set the variables within the NMAR.ps1 script (see comments within script for more details)
  4. Open the windows task scheduler and import the NMAR.xml file; modify the default schedule if desired (the default schedule runs NMAR.ps1 every 10 minutes.)

For multiple instances it is recommended to use Group Policy to deploy the NMAR.xml file and the NMAR.ps1 file to all desired machines within any given OU(s).

## Considerations?

If NMAR finds that it can't reach the default gateway it will disable all network adapters and then enable all network adapters present on the machine; this is important to remember if you have multiple NICs, some of which you don't want activated. The script can be modified to target specific network adapters by replacing the wildcard * with the interface name - i.e. 'Local area connection' ; however, keep in mind (if you're deploying NMAR with group policy) that the NMAR.ps1 file on individual servers may be overwritten with the GPO version of the script during each GPupdate thus wiping out your targeted NIC parameters (depending on how you've setup the GPO).


While NMAR can help minimize downtime in the event of unexpected NIC stall; resolving the root cause of the issue is always better. If you are seeing sporadic stalled NICs across a VMware environment this can be caused by version mismatch within ESXi hosts and between ESXi hosts and Vcenter. If you have version mismatching within your VMware environment, consider the benefits of harmonizing all of your version numbers.


## Script failure?

If the Get-NetRoute command, disable-netadapter, or -ExpandProperty Nexthop flag lines produce an error for you, this probably means your powershell version is out of date and does not support those newer featues. Use the NMAR-Legacy-Server2008 version, you will need to rename the NMAR-Legacy-Server2008.ps1 file to NMAR.ps1, define the variables, and place it in C:\NMAR.

