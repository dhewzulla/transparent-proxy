timestamp=$(date +%s)
# rsync -azvv /etc/pf.anchors/  /Volumes/WD/macbookpro/etc/pf.anchors/pf.anchors-$timestamp/
# sudo cp /Users/dilshathewzulla/bin/transparent-proxy/pf.anchors/com.apple /etc/pf.anchors/com.apple
# sudo cp /Users/dilshathewzulla/bin/transparent-proxy/pf.anchors/910.custom /etc/pf.anchors/910.custom

# sudo pfctl -f /etc/pf.anchors/910.custom

sudo pfctl -f /Users/dilshathewzulla/bin/transparent-proxy/pf.anchors/910.custom