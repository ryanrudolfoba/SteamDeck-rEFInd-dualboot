# This will make the rEFInd boot entry to be the next available option on boot!
# put a sleep delay so it doesnt interfere with other rEFInd scheduled task if it is present.
# but ideally the other rEFInd scheduled task should be disabled.
# sleep 60
#
# some crazy string manipulation to filter for the rEFInd EFI entry
$rEFIndstatus="C:\1rEFInd-tools\status.txt"
$rEFIndtmp="C:\1rEFInd-tools\rEFIndtmp.txt"
$queryrEFInd = bcdedit.exe /enum firmware | Select-String -pattern refind_x64.efi -Context 2 | out-file $rEFIndtmp
$rEFInd = get-content $rEFIndtmp | select-string -pattern Volume -context 2 | findstr identifier ; `
$rEFInd = $rEFInd -replace 'identifier' ; $rEFInd = $rEFInd -replace ' '
rm $rEFIndtmp
bcdedit /set "{fwbootmgr}" bootsequence "$rEFInd" /addfirst
#
# create log file for troubleshooting
"*** rEFInd log file for troubleshooting ***" | out-file $rEFIndstatus
"Provide the contents of this text file when reporting issues." | out-file -append $rEFIndstatus
get-date | out-file -append $rEFIndstatus
"rEFInd GUID $rEFInd" | out-file -append $rEFIndstatus
bcdedit /enum firmware | Select-String -pattern bootsequence | out-file -append $rEFIndstatus
