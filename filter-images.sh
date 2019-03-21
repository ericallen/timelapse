#!/bin/bash

filename="aic01-*.jpg"
#filename format cameraname-YYYY-MM-DD-HH-mm-ss.jgp   example aic01-2018-11-26-23-49-04.jpg

orig_path="orig"
filtered_path="filtered"
numbered_path="numbered"

hour_start="0"
hour_end="23"

#create filtered_path and numbered_path if they don't exist
if [ ! -d $filtered_path ];then
	mkdir $filtered_path
fi

if [! -d $numbered_path ];then
	mkdir $numbered_path
fi

#filter images from camera and get only the ones on certain minutes
#only have one if filter enabled at a time.
echo "Filtering images"
for i in $(find $orig_path -name $filename)
	do
	hourcheck=$(printf $i | cut -d '-' -f5)
	minutecheck=$(printf $i | cut -d '-' -f6)

	if [ "$hourcheck" -ge "$hour_start" -a "$hourcheck" -le "$hour_end" ]
	then
		#filter images for every 5 minutes
		if [ "$minutecheck" == "00" ] || [ "$minutecheck" == "05" ] ||  [ "$minutecheck" == "10" ] || [ "$minutecheck" == "15" ] || [ "$minutecheck" == "20" ] || [ "$minutecheck" == "25" ] || [ "$minutecheck" == "30" ] || [ "$minutecheck" == "35" ] || [ "$minutecheck" == "40" ] || [ "$minutecheck" == "45" ] || [ "$minutecheck" == "50" ] || [ "$minutecheck" == "55" ]
		#filter images for every 10 minutes
		#if [ "$minutecheck" == "00" ] || [ "$minutecheck" == "10" ] || [ "$minutecheck" == "20" ] || [ "$minutecheck" == "30" ] || [ "$minutecheck" == "40" ] || [ "$minutecheck" == "50" ]
		#filter images for every 30 minutes
		#if [ "$minutecheck" == "00" ] ||  [ "$minutecheck" == "30" ]
		#filter images for every hour
		#if [ "$minutecheck" == "00" ]
		then
			file=$(basename $i)
			cp $orig_path/$file $filtered_path/$file
		fi
	fi
done


#Renumbering images for ffmpeg to have them in numerical order
echo "Renumbering images"
x=1
for i in $filtered_path/*.jpg
    do
        counter=$(printf "%05d" $x)
        cp $i $numbered_path/img"$counter".jpg
        x=$(($x+1))
done

echo "Images are ready for encoding"
