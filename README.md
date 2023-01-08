# Steam Deck - Installing rEFInd for Dual Boot Between SteamOS and Windows


## About

This repository contains the instructions and scripts on how to install [rEFInd - a graphical boot manager.](https://www.rodsbooks.com/refind/)

This will mostly benefit Steam Deck users who have setup a dual boot and wants to have a graphical way to select which OS to boot from.
> **NOTE**\
> If you are going to use this script for a video tutorial, PLEASE reference on your video where you got the script! This will make the support process easier!


## Disclaimer

1. Do this at your own risk!
2. This is for educational and research purposes only!


## But Why Create Another rEFInd Script?!? What's Different?
> **NOTE**\
> This was inspired from the rEFInd script available [here.](https://github.com/jlobue10/SteamDeck_rEFInd)

1. Re-wrote the script and removed unneeded components (3rd party systemd scripts / powershell scripts / EasyUEFI).
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
2. deck account should have a blank password, or change the password to "deck" (without the quotes).

**Prerequisites for Windows**
> **NOTE**\
> This applies to Windows installed on the internal SSD / microSD / external SSD.
1. No scripts / scheduled tasks related to rEFInd or EasyEUFI.
2. APU / GPU drivers has been installed and screen orientation set to Landscape.
3. Configure Unbranded Boot. This is to minimize the graphical glitches when booting Windows.
    * Go to Control Panel > Programs and Features > Turn Windows Features On or Off.
    * Expand "Device Lockdown", and then put a check mark on "Unbranded Boot"
    * Open command prompt with admin privileges and enter the commands to disable the boot graphics animation-\
        bcdedit.exe -set {globalsettings} bootuxdisabled on\
        bcdedit.exe -set {bootmgr} noerrordisplay on

## Using the Script
> **NOTE - please read carefully below**
> 1. Make sure you fully read and understand the disclaimer, warnings and pre-requisites!
> 2. The script will create a directory called ~/1rEFInd-tools with scripts to enable / disable Windows EFI and to uninstall rEFInd. Do not delete this folder!

> **IMPORTANT**\
> Once the install is completed, do not change the password for the deck account! Leave it as "deck" (without quotes).\
> This password is also used by the post install scripts located in ~/1rEFInd-tools

Using the script is fairly easy -

1. Open a konsole terminal.
2. Clone the github repo. \
   cd ~/ \
   git clone https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot
   
3. Execute the script! \
   cd ~/SteamDeck-rEFInd-dualboot \
   chmod +x install-rEFInd.sh \
   ./install-rEFInd.sh
   ![image](https://user-images.githubusercontent.com/98122529/211203081-98175143-aa34-466d-be3a-6076e274cd67.png)

4. Wait for script to finish the install.
   ![image](https://user-images.githubusercontent.com/98122529/211203142-3887be83-e8c9-41b9-b7ab-25d393bfe954.png)

5. Reboot the Steam Deck. rEFInd is installed and you should see a GUI to select which OS to boot from! Use the DPAD / trackpad and press A to confirm your choice.


## Screenshots
**SteamOS and Windows**
![image](https://user-images.githubusercontent.com/98122529/211200363-d3e5522e-8317-4972-a0fd-f4f2e65e162a.png)

**SteamOS, Windows and Batocera (microSD)**
![image](https://user-images.githubusercontent.com/98122529/211200404-fc8d3cda-2ea6-4459-8b93-2ddbbe350c98.png)

**SteamOS, Windows (internal SSD) and Windows (external SSD)**
![image](https://user-images.githubusercontent.com/98122529/211200487-64b992ec-c43c-4112-bcb8-1aabe9b2d492.png)

**Windows (internal SSD), Batocera (microSD) and Windows (external SSD)**
![image](https://user-images.githubusercontent.com/98122529/211200544-bbd29f5f-ee1e-42a1-b716-3f8d86ffb413.png)

## FAQ / Troubleshooting
Read this for your Common Questions and Answers!

### Q0. Why did you rename / move the Windows EFI file?
EFI/Microsoft/Boot/bootmgfw.efi — Many EFI implementations use it as a fallback boot loader in addition to or instead of EFI/BOOT/bootarch.efi. In fact, some give it such a high precedence that you can't boot anything that's not given this name! [Taken from the official rEFInd documentation.](https://www.rodsbooks.com/refind/installing.html#naming)

### Q0. How do I check that the ISO is not tampered?

Use a hash file calculator. Verify that the hash matches -\
MD5 - 4e5bc6cf04b9263bd0555960f27c10c4\
SHA1 - 2be1a0db421b56e15cf4a14e1c3fbf6a0198f687\
SHA256 - 2c33e5316216dfc8f9cc0c0af3aaa8213f4ff0fb24a380673a7ba21a64ab7a33\
SHA384 - a9ecd691474cfe5132b60022d002d1ed62a592b76aab9f31ad7ce8eec8d38bdfbe835624bfc61ee4a66c8b1c91297353\

### Q1. Windows shows strange vetical lines at the center when booting up!
![image](https://user-images.githubusercontent.com/98122529/211201387-36311ba8-7ac4-44e7-938c-25d5ed2a3e5f.png)

1. Boot to Windows.
2. Go to Control Panel > Programs and Features > Turn Windows Features On or Off.
3. Expand "Device Lockdown", and then put a check mark on "Unbranded Boot"
![image](https://user-images.githubusercontent.com/98122529/211198710-68105c60-3710-4e9d-bf44-11ab7bc1e67e.png)
4. Open command prompt with admin privileges and enter the commands to disable the boot graphics animation -\
   bcdedit.exe -set {globalsettings} bootuxdisabled on\
   bcdedit.exe -set {bootmgr} noerrordisplay on

### Q2. Windows boots up in garbled graphics!
![image](https://user-images.githubusercontent.com/98122529/211198222-5cce38ff-3f20-4386-8715-c408fea6a4b0.png)

1. Boot into SteamOS.
8. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203305-b112fe52-874d-43db-b4f2-def24b254bd3.png)
   
3. Reboot the Steam Deck and it will boot directly to Windows.
4. Make sure screen orientation is set to Landscape.
5. Make sure Unbranded Boot is configured and enabled.
6. Power off the Steam Deck. 
7. While powered off press VOLDOWN + Power and manually boot into SteamOS / rEFInd.
8. Open a konsole terminal and disable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./disable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203335-fa6133cd-46e8-4423-9918-84bf78bd136c.png)
         
8. Reboot Steam Deck and it will boot back to the rEFInd graphical menu.

### Q3. I need to perform a GPU / APU driver upgrade in Windows. What do i do?

1. Boot into SteamOS.
2. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203305-b112fe52-874d-43db-b4f2-def24b254bd3.png)
   
3. Reboot the Steam Deck and it will automatically load Windows.
4. Install the GPU / APU driver upgrade and reboot Windows.
5. After the reboot it will automatically load Windows.
6. Make sure screen orientation is set to Landscape.
7. Power off the Steam Deck.
8. While powered off press VOLDOWN + Power and manually boot into SteamOS / rEFInd.
9. Open a konsole terminal and disable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./disable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203335-fa6133cd-46e8-4423-9918-84bf78bd136c.png)
   
7. Reboot Steam Deck and it will boot back to the rEFInd graphical menu.
       
### Q4. I reinstalled Windows and now it boots directly to Windows instead of rEFInd!

1. Power off the Steam Deck. 
2. While powered off press VOLDOWN + Power and manually boot into SteamOS / rEFInd.
3. Open a konsole terminal and disable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./disable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203335-fa6133cd-46e8-4423-9918-84bf78bd136c.png)

3. Reboot the Steam Deck and it will boot back to the rEFInd graphical menu.

### Q5. Windows automatically installed updates and on reboot it goes automatically to Windows!
This is similar to Q4. Refer to Q4 on how to fix it.

### Q6. I don't like the bundled icons / background and I want to change them!

1. Go to the directory / folder where rEFInd script is located - usually this is SteamDeck-rEFInd-dualboot.
2. Open the custom folder and replace the icons / background image with the ones you want to use.
3. Open a konsole terminal and re-run the install script! \
   cd ~/SteamDeck-rEFInd-dualboot \
   ./install-rEFInd.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203484-fd969a72-f97f-41ab-98f5-58c57911d6bd.png)
         
4. Reboot the Steam Deck and enjoy your new custom icons / background!
      
### Q7. I messed up the background / icons and I want to revert back to the defaults!

1. Delete the existing SteamDeck-rEFInd-dualboot folder.
2. Follow the steps on how to install the script.

### Q8. I hate rEFInd / I want to just dual boot the manual way / A better script came along and I want to uninstall your work!

1. Boot into SteamOS.
2. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1rEFInd-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203305-b112fe52-874d-43db-b4f2-def24b254bd3.png)
   
3. Reboot the Steam Deck and it will automatically load Windows.
4. Power off the Steam Deck.
8. While powered off press VOLDOWN + Power and manually boot into SteamOS / rEFInd.
9. Open a konsole terminal and run the uninstall script - \
   cd ~/1rEFInd-tools \
   ./uninstall-rEFInd.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211203628-eec48450-d5a6-4941-85ad-8df6d17742e2.png)
   
7. Reboot Steam Deck and it will boot directly to Windows. rEFInd has been uninstalled!

### Q9. I like your work how do I show a token of appreciation?
You can send me a message on reddit / discord to say thanks!
