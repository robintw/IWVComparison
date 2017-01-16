for WORD in `cat to_download.txt`:
do
echo $WORD
wget --ftp-user=USERHERE --ftp-password=PASSWORDHERE -r ftp://ftp.ceda.ac.uk/badc/ukmo-rad/data/${WORD%?}
done