# NAMAR [Network Adapter Monitor and Restarter]
---What is it?


NAMAR [Network Adapter Monitor and Restarter] was created to reduce server downtime associated with stalled network interfaces.  NAMAR runs as a scheduled task; it checks communication with its default gateway at regular intervals and automatically restarts any network interfaces if communication with the default gateway cannot be established.  NAMAR sends email alerts upon successful NIC repair and logs its own activity. NAMAR is designed for Windows machines running powershell 4 or newer.

--How do I set it up?

For a single instance:

1. Create a folder in  C:\  named NAMAR
2. Move NAMAR.ps1 to C:\NAMAR
3. Set the variables within the NAMAR.ps1 script (needed for email alerts and consolidated logging)
4. Open the windows task scheduler and import the NAMAR.xml file; modify the default schedule if desired (the default schedule runs NAMAR.ps1 every 10 minutes.) 

For multiple instances it is recommended to use Group Policy to deploy the NAMAR.xml file and the NAMAR.ps1 file to all desired machines within any given OU(s).

--Considerations?

If NAMAR finds that it can't reach the default gateway it will disable all network adapters and then enable all network adapters present on the machine; this is important to remember if you have multiple NICs, some of which you don't want activated.  The script can be modified to target specific scripts; however, keep in mind (if you're deploying NAMAR with group policy) that the NAMAR.ps1 file on individual servers may be overwritten with the GPO version of the script during each GPupdate thus wiping out your targeted NIC parameters (depending on how you've setup the GPO).  

While NAMAR can help minimize downtime in the event of unexpected NIC stall; resolving the root cause of the issue is always better. If you are seeing spiritic stalled NICs across a VMware environment this can be caused by version mismatch within ESXi hosts and between ESXi hosts and Vcenter.  If you have version mismatching within your VMware environment, consider the benifits of harmonizing all of your version numbers.
