#!/bin/bash

clear

echo rEFInd Install Script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot
sleep 2

# Password sanity check - make sure sudo password is already set by end user!

if [ "$(passwd --status deck | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	read -s -p "Please enter current sudo password: " current_password ; echo
	echo Checking if the sudo password is correct.
	echo -e "$current_password\n" | sudo -S -k ls &> /dev/null

	if [ $? -eq 0 ]

	then
		echo Sudo password is good!
	else
		echo Sudo password is wrong! Re-run the script and make sure to enter the correct sudo password!
		exit
	fi

else
	echo Sudo password is blank! Setup a sudo password first and then re-run script!
	passwd
	exit
fi

# sudo password is already set by the end user, all good let's go!
echo -e "$current_password\n" | sudo -S ls &> /dev/null
if [ $? -eq 0 ]
then
	echo 1st sanity check. So far so good!
else
	echo Something went wrong on the 1st sanity check! Re-run script!
	exit
fi

# mount rEFInd ISO
sudo mkdir ~/temp-refind && sudo mount refind-cd-0.13.3.1.iso ~/temp-refind &> /dev/null
if [ $? -eq 0 ]
then
	echo 2nd sanity check. ISO has been mounted!
else
	echo Error mounting ISO!
	sudo umount ~/temp-refind
	rmdir ~/temp-refind
	exit
fi

# copy rEFInd files to EFI system partition
sudo mkdir -p /esp/efi/refind/backgrounds && sudo cp -Rf ~/temp-refind/refind/{drivers_x64,icons,refind_x64.efi,tools_x64} /esp/efi/refind && sudo cp custom/refind.conf /esp/efi/refind && sudo cp custom/icons/*.png /esp/efi/refind/icons && sudo cp custom/backgrounds/background.png /esp/efi/refind/backgrounds

if [ $? -eq 0 ]
then
	echo 3rd sanity check. rEFInd has been copied to the EFI system partition!
else
	echo Error copying files. Something went wrong.
	sudo umount ~/temp-refind
	rmdir ~/temp-refind
	exit
fi

sudo cp /esp/efi/steamos/steamcl.efi /esp/efi/steamos/grubx64.efi

# cleanup temp directories created
sudo umount ~/temp-refind
sudo rmdir ~/temp-refind

# remove previous rEFInd entries before re-creating them
for entry in $(efibootmgr | grep -i "rEFInd" | colrm 9 | colrm 1 4)
do
	sudo efibootmgr -b $entry -B &> /dev/null
done

# Sanity check - is SteamOS EFI entry exists?
efibootmgr | grep "Steam" &> /dev/null

if [ $? -eq 0 ]
then
	echo 4th sanity check. SteamOS EFI entry is good, no action needed!
else
	echo 4th sanity check. SteamOS EFI entry does not exist! Re-creating SteamOS EFI entry.
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi" &> /dev/null
fi

# install rEFInd to the EFI system partition
sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "rEFInd - GUI Boot Manager" -l "\EFI\refind\refind_x64.efi" &> /dev/null

# make rEFInd the next boot option!
rEFInd=$(efibootmgr |  grep -i rEFInd | colrm 9 | colrm 1 4)
sudo efibootmgr -n $rEFInd &> /dev/null

# Final sanity check
efibootmgr | grep "rEFInd - GUI" &> /dev/null

if [ $? -eq 0 ]
then
	echo 5th sanity check. rEFInd has been successfully installed to the EFI system partition!
else
	echo Whoopsie something went wrong. rEFInd is not installed.
	exit
fi

sleep 2
echo \****************************************************************************************************
echo Post install scripts saved in 1rEFInd-tools. Use them as needed -
echo \****************************************************************************************************
echo enable-windows-efi.sh   -   Use this script to re-enable Windows EFI entry and temp disable rEFInd.
echo uninstall-rEFInd.sh     -   Use this to completely uninstall rEFInd from the EFI system partition.
echo \****************************************************************************************************
echo \****************************************************************************************************

#################################################################################
################################ post install ###################################
#################################################################################

# create ~/1rEFInd-tools and place the scripts in there
mkdir ~/1rEFInd-tools &> /dev/null
rm ~/1rEFInd-tools/*.sh &> /dev/null

# enable-windows-efi.sh
cat > ~/1rEFInd-tools/enable-windows-efi.sh << EOF
#!/bin/bash

# make Windows the next boot option!
Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
sudo efibootmgr -n \$Windows &> /dev/null
echo rEFInd has been deactivated and Windows EFI entry has been re-enabled!
EOF

# uninstall-rEFInd.sh
cat > ~/1rEFInd-tools/uninstall-rEFInd.sh << EOF
#!/bin/bash

# remove rEFInd from the EFI system partition
sudo rm -rf /esp/efi/refind
sudo rm -rf /esp/efi/steamos/grubx64.efi

for entry in \$(efibootmgr | grep "rEFInd - GUI" | colrm 9 | colrm 1 4)
do
	sudo efibootmgr -b \$entry -B &> /dev/null
done

grep -v 1rEFInd-tools ~/.bash_profile > ~/.bash_profile.temp
mv ~/.bash_profile.temp ~/.bash_profile

rm -rf ~/1rEFInd-tools/*

# make Windows the next boot option!
Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
sudo efibootmgr -n \$Windows &> /dev/null
echo rEFInd has been uninstalled and the Windows EFI entry has been restored!
EOF

# post-install-rEFInd.sh
cat > ~/1rEFInd-tools/post-install-rEFInd.sh << EOF
#!/bin/bash
echo -e "$current_password\n" | sudo -S ls &> /dev/null

date  > ~/1rEFInd-tools/status.txt

echo BIOS Version : \$(sudo dmidecode -s bios-version) >> ~/1rEFInd-tools/status.txt

# Sanity Check - are the needed EFI entries available?

efibootmgr | grep -i rEFInd &> /dev/null
if [ \$? -eq 0 ]
then
	echo rEFInd EFI entry exists! No need to re-add rEFInd. >> ~/1rEFInd-tools/status.txt
else
	echo rEFInd EFI entry is not found. Need to re-ad rEFInd. >> ~/1rEFInd-tools/status.txt
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "rEFInd - GUI Boot Manager" -l "\EFI\refind\refind_x64.efi" &> /dev/null
fi

efibootmgr | grep -i Steam &> /dev/null
if [ \$? -eq 0 ]
then
	echo SteamOS EFI entry exists! No need to re-add SteamOS. >> ~/1rEFInd-tools/status.txt
else
	echo SteamOS EFI entry is not found. Need to re-add SteamOS. >> ~/1rEFInd-tools/status.txt
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi" &> /dev/null
fi

# make rEFInd the next boot option!
rEFInd=\$(efibootmgr | grep -i rEFInd | colrm 9 | colrm 1 4)
sudo efibootmgr -n \$rEFInd &> /dev/null

echo "*** Current state of EFI entries ****" >> ~/1rEFInd-tools/status.txt
efibootmgr >> ~/1rEFInd-tools/status.txt
EOF

grep 1rEFInd-tools ~/.bash_profile &> /dev/null
if [ $? -eq 0 ]
then
	echo Post install script already present no action needed! rEFInd install is done!
else
	echo Post install script not found! Adding post install script!
	echo "~/1rEFInd-tools/post-install-rEFInd.sh" >> ~/.bash_profile
	echo Post install script added! rEFInd install is done!
fi

chmod +x ~/1rEFInd-tools/*
