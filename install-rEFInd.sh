#!/bin/bash

clear

echo rEFInd Install Script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot
sleep 2

# Password sanity check. Make sure the sudo password is blank or set as "deck" (without quotes).

if [ "$(passwd --status deck | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	echo Sudo password is already set!
else
	echo Sudo password is blank!
	echo Setting sudo password deck:deck
	echo -e "deck\ndeck" | passwd deck &> /dev/null
	echo Sudo password has been set!
fi

echo Checking if the sudo password is correct. . .
echo -e "deck\n" | sudo -S steamos-readonly disable &> /dev/null
if [ $? -eq 0 ]
then
	echo Sudo password is good!
	echo Proceeding to the next step - mounting the rEFInd ISO!
else
	echo Sudo password is wrong! Make sure the sudo password is blank or set as \"deck\" \(without quotes\), then re-run the script again!
	exit
fi

# mount rEFInd ISO
echo -e "deck\n" | sudo -S steamos-readonly disable &> /dev/null
sudo mkdir ~/temp-refind && sudo mount refind-cd-0.13.3.1.iso ~/temp-refind &> /dev/null
if [ $? -eq 0 ]
then
	echo So far so good. ISO has been mounted!
	echo Proceeding to the next step - installing rEFInd to the EFI system  partition!
else
	echo Error mounting ISO!
	rmdir ~/temp-refind
	exit
fi

# copy rEFInd files to EFI system partition
sudo mkdir -p /esp/efi/refind/backgrounds
sudo cp -Rf ~/temp-refind/refind/{drivers_x64,icons,refind_x64.efi,tools_x64} /esp/efi/refind
sudo cp custom/refind.conf /esp/efi/refind
sudo cp custom/icons/*.png /esp/efi/refind/icons
sudo cp custom/backgrounds/background.png /esp/efi/refind/backgrounds

# cleanup temp directories created
sudo umount ~/temp-refind
sudo rmdir ~/temp-refind

# disable Windows EFI
sudo cp /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft/Boot/bootmgfw.efi.orig &> /dev/null
sudo mv /esp/efi/boot/bootx64.efi /esp/efi/boot/bootx64.efi.orig &> /dev/null
sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft &> /dev/null
sudo cp /esp/efi/steamos/steamcl.efi /esp/efi/steamos/grubx64.efi &> /dev/null
sync ; sleep 5

# remove previous rEFInd entries before re-creating them
for entry in $(efibootmgr | grep "rEFInd - GUI" | colrm 9 | colrm 1 4)
do
	sudo efibootmgr -b $entry -B &> /dev/null
done

# install rEFInd to the EFI system partition
#sudo mount -o rw,remount /sys/firmware/efi/efivars
sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "rEFInd - GUI Boot Manager" -l "\EFI\refind\refind_x64.efi" &> /dev/null
sudo steamos-readonly enable &> /dev/null

# Final sanity check
efibootmgr | grep "rEFInd - GUI" &> /dev/null

if [ $? -eq 0 ]
then
	echo rEFInd has been successfully installed!
else
	echo Whoopsie something went wrong. rEFInd is not installed.
	exit
fi

sleep 2
echo \****************************************************************************************************
echo Post install scripts saved in 1rEFInd-tools. Use them as needed -
echo \****************************************************************************************************
echo enable-windows-efi.sh   -   Use this script to re-enable Windows EFI entry and temp disable rEFInd.
echo disable-windows-efi.sh  -   Use this script to disable Windows EFI entry and re-enable rEFInd.
echo uninstall-rEFInd.sh     -   Use this to completely uninstall rEFInd from the EFI system partition.
echo \****************************************************************************************************
echo \****************************************************************************************************
echo If you want to uninstall rEFInd, use the enable-windows-efi.sh script first then perform a reboot.
echo Manually boot into SteamOS and then Use the uninstall-rEFInd.sh script to complete the uninstall.
echo \****************************************************************************************************

################################ post install ###################################

mkdir ~/1rEFInd-tools &> /dev/null
cat > ~/1rEFInd-tools/enable-windows-efi.sh << EOF
#!/bin/bash

if [ "\$(passwd --status deck | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	echo Sudo password is already set!
else
	echo Setting sudo password deck:deck
	echo -e "deck\ndeck" | passwd deck &> /dev/null
	sleep 2
	echo Sudo password has been set!
fi

echo -e "deck\n" | sudo -S steamos-readonly disable &> /dev/null
sudo mv /esp/efi/boot/bootx64.efi.orig /esp/efi/boot/bootx64.efi &> /dev/null
sudo mv /esp/efi/Microsoft/bootmgfw.efi /esp/efi/Microsoft/Boot &> /dev/null
sync ; sleep 5
sudo steamos-readonly enable &> /dev/null
echo rEFInd has been deactivated and Windows EFI entry has been re-enabled!
echo Run the script disable-windows-efi.sh to reactivate rEFInd!
EOF

cat > ~/1rEFInd-tools/disable-windows-efi.sh << EOF
#!/bin/bash

if [ "\$(passwd --status deck | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	echo Sudo password is already set!
else
	echo Setting sudo password deck:deck
	echo -e "deck\ndeck" | passwd deck &> /dev/null
	sleep 2
	echo Sudo password has been set!
fi

echo -e "deck\n" | sudo -S steamos-readonly disable &> /dev/null
sudo mv /esp/efi/boot/bootx64.efi /esp/efi/boot/bootx64.efi.orig &> /dev/null
sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft/ &> /dev/null
sync ; sleep 5
sudo steamos-readonly enable &> /dev/null
echo rEFInd has been activated and Windows EFI entry has been disabled!
echo Run the script enable-windows-efi.sh to re-enable Windows EFI.
EOF

cat > ~/1rEFInd-tools/uninstall-rEFInd.sh << EOF
#!/bin/bash

if [ "\$(passwd --status deck | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	echo Sudo password is already set!
else
	echo Setting sudo password deck:deck
	echo -e "deck\ndeck" | passwd deck &> /dev/null
	sleep 2
	echo Sudo password has been set!
fi

echo -e "deck\n" | sudo -S steamos-readonly disable &> /dev/null

# remove rEFInd from the esp partition
sudo rm -rf /esp/efi/refind
sudo rm /esp/efi/steamos/grubx64.efi &> /dev/null
sudo mv /esp/efi/boot/bootx64.efi.orig /esp/efi/boot/bootx64.efi &> /dev/null
sudo mv /esp/efi/Microsoft/bootmgfw.efi /esp/efi/Microsoft/Boot &> /dev/null
sync ; sleep 5

for entry in \$(efibootmgr | grep "rEFInd - GUI" | colrm 9 | colrm 1 4)
do
	sudo efibootmgr -b \$entry -B &> /dev/null
done

sudo steamos-readonly enable &> /dev/null

echo rEFInd has been uninstalled and the Windows EFI entry has been restored!
EOF

chmod +x ~/1rEFInd-tools/*
