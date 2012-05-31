
weather_urlbase="ftp://ftp.ncdc.noaa.gov/pub/data/gsod"
weather_filenames="country-list.txt VERY-IMPORTANT-NOTICE.TXT ish-history.csv ish-history.txt readme.txt"

for filename in $weather_filenames ; do
  echo $filename
  wget -r -l3 -np -nc -nv -a /tmp/wget-weather.log $weather_urlbase/$filename &
done 

wget -r -l2 -np -nc -nv -a /tmp/wget-weather.log ftp://ftp.ncdc.noaa.gov/pub/data/inventories/

  
