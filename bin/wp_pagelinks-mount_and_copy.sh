#!/usr/bin/env bash

#
# wikistats part III:
# create volume from snap-f57dec9a
# create instance, attach it to /dev/sdf
#
sudo mkdir -p /data/wp_pageviews_v3  ; sudo mount -t ext3 /dev/sdf1 /data/wp_pageviews_v3

#
# on local machine
#
rsync -alvi --rsh='ssh -i ~/.chef/keypairs/spidermonkey.pem' ubuntu@72.44.56.164:/data/wp_pageviews_v3/wikistats/pagecounts-2011010* /data/ripd/wp_pagecounts/v3/
