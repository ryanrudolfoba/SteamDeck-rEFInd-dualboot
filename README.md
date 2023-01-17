# Steam Deck - Installing rEFInd for Dual Boot Between SteamOS and Windows


## About

This repository contains the instructions and scripts on how to install [rEFInd - a graphical boot manager.](https://www.rodsbooks.com/refind/)

This will mostly benefit Steam Deck users who have setup a dual boot and wants to have a graphical way to select which OS to boot from.
> **NOTE**\
> If you are going to use this script for a video tutorial, PLEASE reference on your video where you got the script! This will make the support process easier!


## Screenshots
**Windows and SteamOS**
![image](https://user-images.githubusercontent.com/98122529/213034110-db07aa55-5a63-474c-9882-92dd86fa35f9.png)

**Windows, SteamOS and Batocera (microSD)**
![image](https://user-images.githubusercontent.com/98122529/213034356-3dc7afe4-d1a7-4cf6-bd60-0c924122c26b.png)

**SteamOS, Batocera (microSD) and Windows (external SSD)**
![image](https://user-images.githubusercontent.com/98122529/213034779-b24acdc7-543d-454a-92e7-6e547ebf9aa7.png)



## Disclaimer

1. Do this at your own risk!
2. This is for educational and research purposes only!


## But Why Create Another rEFInd Script?!? What's Different?
> **NOTE**\
> This was inspired from the rEFInd script available [here.](https://github.com/jlobue10/SteamDeck_rEFInd)

1. Re-wrote the script and removed unneeded components (3rd party systemd scripts / ~~powershell scripts~~ / EasyUEFI).
2. This contains the same techniques I learned when writing the [Clover install script!](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot)
3. When the dual boot breaks, just boot back manually to SteamOS and it will fix the dual boot entries on its own!
2. All-in-One script - install, disable / re-enable, uninstall!
3. Simplified config file so it is easy to read, understand and modify.
4. Doesn't rely on pacman repositories - uses the [official rEFInd ISO](http://sourceforge.net/projects/refind/files/0.13.3.1/refind-cd-0.13.3.1.zip/download) image.
5. Doesn't use hardcoded menu entries - this allows Windows on microSD / external SSD to get detected automatically!
6. misc - Added a cool Matrix Morpheus wallpaper, custom icon for Windows, SteamOS and Batocera.

## !!! WARNING - WARNING - WARNING !!!
> **WARNING!**\
> Please carefully read the items below!
1. The script has been thoroughly tested on a fresh SteamOS and Windows install.
2. If your SteamOS has prior traces of rEFInd or scripts / systemd services related to rEFInd, it is suggested to uninstall / remove those first before proceeding.
3. If your Windows install has scripts or programs related to rEFInd / EasyUEFI, it is suggested to uninstall / remove those first before proceeding.

This is a complete rewrite and it doesn't rely on systemd services /  3rd party apps. I don't know what the behavior will be if those are present in the system. Remove them first before using this script!

## Prerequisites for SteamOS and Windows
**Prerequisites for SteamOS**
1. No prior traces of rEFInd or scripts / systemd services related to rEFInd.
2. sudo password should already be set by the end user. If sudo password is not yet set, the script will ask to set it up.

**Prerequisites for Windows**
> **NOTE**\
> This applies to Windows installed on the internal SSD / external SSD / microSD.
1. No scripts / scheduled tasks related to rEFInd or EasyUEFI.
2. APU / GPU drivers has been installed and screen orientation set to Landscape.
3. This is VERY IMPORTANT! Do not skip this step -
    * Open command prompt with admin privileges and enter the command -\
        bcdedit.exe -set {globalsettings} highestmode on
        

## Using the Script
> **NOTE1 - please read carefully below**
> 1. Make sure you fully read and understand the disclaimer, warnings and prerequisites!
> 2. The script will create a directory called ~/1rEFInd-tools with scripts to enable / disable Windows EFI and an uninstall to reverse any changes made. Do not delete this folder!


> **For the SteamOS side**\
> The script copies files to the /esp/efi/clover location and manipulates the EFI boot orders. No files are renamed / moved.\
> Extra scripts are saved in ~/1rEFInd-tools which manipulates the EFI boot orders, and an uninstall to reverse any changes made.\
> There are no extra systemd scripts created, ~~no extra power shell scripts needed~~ and no need for EasyUEFI.

> **For the Windows side**\
> The script creates a folder called C:\1rEFInd-tools and creates a Scheduled Task.\
> The Scheduled Task runs the powershell script saved in C:\1rEFInd-tools. The powershell script queries the EFI entries and sets rEFInd to be the next boot entry.

> **NOTE2**\
> The installation is divided into 2 parts - 1 for SteamOS, and 1 for Windows.\
> The recommended way is to do the steps on SteamOS first, and then do the steps for Windows.


**Installation Steps for SteamOS**

1. Go into Desktop Mode.
2. Open a konsole terminal.
3. Clone the github repo. \
   cd ~/ \
   git clone https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot
   
3. Execute the script! \
   cd ~/SteamDeck-rEFInd-dualboot \
   chmod +x install-rEFInd.sh \
   ./install-rEFInd.sh
   ![image](https://user-images.githubusercontent.com/98122529/213032448-1d030119-da77-4d81-b57b-37d645c88028.png)

4. The script will check if sudo passwword is already set.\
   **4a.**
         If it is already set, enter the current sudo password and the script will continue.\
         If wrong password is provided the script will exit immdediately. Re-run the script and enter the correct sudo password!
         ![image](https://user-images.githubusercontent.com/98122529/213032508-d436f3a6-3b10-4c8a-bcee-70cbcaf7e5af.png)

   **4b.**
         If the sudo password is blank / not yet set by the end user, the script will prompt to setup the sudo password. Re-run the script to continue.
         ![image](https://user-images.githubusercontent.com/98122529/213032571-6f2213a6-c1ec-47ae-8a91-38a6cfdfd6ea.png)

   **4c.**
         Script will continue to run and perform sanity checks all throughout the install process.
         ![image](https://user-images.githubusercontent.com/98122529/213032647-51bb2b0e-9b75-4774-8f3a-4d4407f1804f.png)

         
5. Reboot the Steam Deck. rEFInd is installed and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice.
![image](https://user-images.githubusercontent.com/98122529/213034159-ca98ad01-a6af-4172-af83-e251b28c6b77.png)


**Installation Steps for Windows**
1. Download the ZIP by pressing the GREEN CODE BUTTON, then select Download ZIP.
![image](https://user-images.githubusercontent.com/98122529/213036054-581579ff-ea23-4a0e-a9ca-f9020a7b7d25.png)

2. Go to your Downloads folder and then extract the zip.
3. Right click rEFIndWindows.bat and select RUNAS Administrator.

![image](https://user-images.githubusercontent.com/98122529/213036416-c306e095-34ec-4ec2-83a9-4d864ea0ecd9.png)

4. The script will automatically create the C:\1rEFInd-tools folder and copy the files in there.\
5. It will also automatically create the Scheduled Task called rEFIndTask-donotdelete
![image](https://user-images.githubusercontent.com/98122529/213036461-cf81f8f8-6ef5-42af-b3c8-9ba91596da64.png)

6. Go to Task Scheduler and the rEFIndTask will show up in there.
7. Right-click the rEFIndTask and select Properties.
![image](https://user-images.githubusercontent.com/98122529/213036710-e1b4c0b6-e42e-4d16-a1c2-8f3a38590472.png)

8. Under the General tab, make sure it looks like this. Change it if it doesn't then press OK.
![image](https://user-images.githubusercontent.com/98122529/213036769-87cfb18e-b423-48f5-8d1e-cd9434bdfa52.png)

9. Right click the task and select RUN.

![image](https://user-images.githubusercontent.com/98122529/213036820-ec06a5fb-55d7-42f1-9cfb-d11ec500ef06.png)

10. Close Task Scheduler. Go to C:\1rEFInd-tools and look for the file called status.txt.

11. Open status.txt and the rEFInd GUID should be the same as the bootsequence. Sample below.
![image](https://user-images.githubusercontent.com/98122529/213036895-fd7f5f00-e263-47aa-b5da-0accc476d848.png)

12. Reboot and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.
![image](https://user-images.githubusercontent.com/98122529/213034195-bc4e3fe3-95ce-4402-8a61-72726c638e2e.png)



## FAQ / Troubleshooting
Read this for your Common Questions and Answers! This will be regularly updated and some of the answers in here are contributions from the [WindowsOnDeck reddit community!](https://www.reddit.com/r/WindowsOnDeck/)


### Q0. How do I check that the ISO is not tampered?

Use a hash file calculator. Verify that the hash matches -\
MD5 - 4e5bc6cf04b9263bd0555960f27c10c4\
SHA1 - 2be1a0db421b56e15cf4a14e1c3fbf6a0198f687\
SHA256 - 2c33e5316216dfc8f9cc0c0af3aaa8213f4ff0fb24a380673a7ba21a64ab7a33\
SHA384 - a9ecd691474cfe5132b60022d002d1ed62a592b76aab9f31ad7ce8eec8d38bdfbe835624bfc61ee4a66c8b1c91297353\

### Q1. Windows shows strange vertical lines at the center when booting up!
![image](https://user-images.githubusercontent.com/98122529/211201387-36311ba8-7ac4-44e7-938c-25d5ed2a3e5f.png)

1. Boot to Windows.
2. Open command prompt with admin privileges and enter the command -\
   bcdedit.exe -set {globalsettings} highestmode on
      

### Q2. Windows boots up in garbled graphics!
![image](https://user-images.githubusercontent.com/98122529/211198222-5cce38ff-3f20-4386-8715-c408fea6a4b0.png)

1. Boot into SteamOS.
2. Go to Desktop Mode.
3. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/213035343-3c868d97-c527-471e-9852-6e0e3ca80714.png)
   
4. Reboot the Steam Deck and it will boot directly to Windows.
6. Open command prompt with admin privileges and enter the command -\
   bcdedit.exe -set {globalsettings} highestmode on

7. Make sure screen orientation is set to Landscape.
8. Reboot and it will go back to rEFInd!

### Q3. I need to perform a GPU / APU driver upgrade in Windows. What do I do?

1. Boot into SteamOS.
2. Go to Desktop Mode.
3. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/213035373-012f014b-5390-4614-a954-f8493d55eb6a.png)
   
3. Reboot the Steam Deck and it will automatically load Windows.
4. Install the GPU / APU driver upgrade and reboot Windows.
5. After the reboot it will go back to rEFInd.
6. Select Windows and wait until it loads.
7. Make sure screen orientation is set to Landscape.
8. If everything looks good, reboot and it will go back to rEFInd.

       
### Q4. I reinstalled Windows and now it boots directly to Windows instead of rEFInd!

1. Follow the steps for the Windows install.

### Q5. Windows automatically installed updates and on reboot it goes automatically to Windows!
1. Manually boot into SteamOS and it will automatically fix the dual boot entries.
2. On the next reboot it will go to rEFInd.

### Q6. There was a SteamOS update and it wiped all my boot entries!
This happens even if not using dualboot / Clover / rEFInd.
1. Turn OFF the Steam Deck. While powered OFF, press VOLUP + POWER.
2. Go to Boot from File > efi > steamos > steamcl.efi
3. Wait until SteamOS boots up and it will automatically fix the dual boot entries.
4. On the next reboot it will go to rEFInd.

### Q7. I hate rEFInd / I want to just dual boot the manual way / A better script came along and I want to uninstall your work!

1. Boot into SteamOS.
2. Open a konsole terminal and run the uninstall script - \
   cd ~/1rEFInd-tools \
   ./uninstall-rEFInd.sh\
   ![image](https://user-images.githubusercontent.com/98122529/213035452-e01238ed-0e33-4845-a1f7-9bfbc64d0175.png)
   
3. Reboot the Steam Deck and it will automatically load Windows. rEFInd has been uninstalled!

### Q8. I like your work how do I show a token of appreciation?
You can send me a message on reddit / discord to say thanks!
