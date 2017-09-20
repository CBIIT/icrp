#Run as root

#Save custom directory
cp -rp modules/custom/ /tmp/custom-hold/
cp -rp vendor /tmp/vendor-hold/
rm -rf modules/*
cp -rp /tmp/custom-hold/ modules/custom/
