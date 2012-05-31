#!/usr/bin/env bash

mkdir -p /data/ripd
mkdir -p /data/chimpmark/ripd
mkdir -p /data/chimpmark/rawd/{dbpedia,weather/gsod,weather/inventories,wp_corpus,wp_pagecounts}

ln -s /data/ripd/downloads.dbpedia.org/3.7/en      /data/chimpmark/ripd/dbpedia
ln -s /data/ripd/dumps.wikimedia.org/enwiki/latest /data/chimpmark/ripd/wp_corpus
ln -s /data/ripd/wp_pagecounts                     /data/chimpmark/ripd/wp_pagecounts
ln -s /data/ripd/ftp.ncdc.noaa.gov/pub/data        /data/chimpmark/ripd/weather


