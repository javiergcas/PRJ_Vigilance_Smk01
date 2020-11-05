#!/bin/bash

module load firefox
# Construct a list of all subjects to view
export all_files=(`ls /data/SFIM_Vigilance/PRJ_Vigilance_Smk01/PrcsData/sub-*/D02_Preproc_fMRI/QC_sub-*/index.html`)
num_files=`echo "${#all_files[@]} - 1" | bc -l`
for ff in `seq 0 1 ${num_files}`
do
    sleep 0.1      # this helps *all* windows open properly
    if [ $ff == 0 ];then
       echo "++ Opening Window: $ff --> ${all_files[ff]}"
       firefox -new-window ${all_files[ff]} &
    else
       echo "++ Opening Tab: $ff --> ${all_files[ff]}"
       firefox -new-tab ${all_files[ff]} &
    fi
done
