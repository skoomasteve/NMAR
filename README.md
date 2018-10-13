# NMAR
---What is it?


NMAR [NIC Monitor and Restarter] was created to reduce server downtime associated with stalled network interfaces.  NMAR runs as a scheduled task; it checks communication with its default gateway at regular intervals and automatically restarts any network interfaces if communication with the default gateway cannot be established.  NMAR sends email alerts upon succesfull NIC repair and logs its own activity. NMAR is designed for Windows machines running powershell 4 or newer.

--How do I set it up?

For a single instance:

1. Create a folder in  C:\  named NMAR
2. Move NMAR.ps1 to C:\NMAR
3. Set the variables within the NMAR.ps1 script (needed for email alerts and consolodated logging)
4. Open the windows task scheduler and import the NMAR.xml file; modify the default schedule if desired (the default schedule runs NMAR.ps1 every 10 minutes.) 

For multiple instances it is recommended to use group policy to deploy the NMAR.xml file and the NMAR.ps1 file to all desired machines within any given OU(s)

--Considerations?

If NMAR finds that it can't reach the default gateway it will disable all nic's and then enable all nic's present on the machine; this is important to remember if you have muliple nics- some of which you don't want activated.  The script can be modified to target specific scripts; however, keep in mind (if you're deploying NMAR with group policy) that the NMAR.ps1 file may be overwritten during the next GPupdate thus wiping out your targeted NIC paramaters (depending on how you've setup the GPO).  

