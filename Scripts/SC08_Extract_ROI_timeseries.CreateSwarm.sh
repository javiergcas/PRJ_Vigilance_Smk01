# Oct/28/2020 - Javier Gonzalez-Castillo
#
# STEPS
#
# NOTE
#
set -e

NROIs=200
NumROIsID=`printf %04d ${NROIs}`
ORIG_DATA_DIR='/data/SFIM_Vigilance/Data/DSET01/'
subjects=(`ls ${ORIG_DATA_DIR} | tr -s '\n' ' '`)
subjects=("${subjects[@]/'README'}")   # The subject directory contains a README file. This is not a subject ID.
num_subjects=`echo "${#subjects[@]} -1" | bc -l`
echo "Subjects: ${subjects[@]}"

# Create log directory if needed
if [ ! -d ./SC08_Extract_ROI_timeseries.logs ]; then
   mkdir ./SC08_Extract_ROI_timeseries.logs
fi

# Write top comment in Swarm file 
echo "#Creation Date: `date`" > ./SC08_Extract_ROI_timeseries.SWARM.sh
echo "#swarm -f ./SC08_Extract_ROI_timeseries.SWARM.sh -g 32 -t 32 --partition quick,norm --logdir ./SC08_Extract_ROI_timeseries.logs" >> ./SC08_Extract_ROI_timeseries.SWARM.sh

# Write one entry per subject in Swarm file
for SBJ in ${subjects[@]}
do
   if [ ! -d /data/SFIM_Vigilance/PRJ_Vigilance_Smk01/PrcsData/${SBJ}/D02_Preproc_fMRI/DXX_NROIS${NumROIsID} ]; then 
        echo "++ INFO: Folder created [/data/SFIM_Vigilance/PRJ_Vigilance_Smk01/PrcsData/${SBJ}/D02_Preproc_fMRI/DXX_NROIS${NumROIsID}]"
        mkdir /data/SFIM_Vigilance/PRJ_Vigilance_Smk01/PrcsData/${SBJ}/D02_Preproc_fMRI/DXX_NROIS${NumROIsID}
   fi
   for WL in 060 046 030
   do
     echo "export SBJ=${SBJ} WL=${WL} NROIs=${NROIs}; sh ./SC08_Extract_ROI_timeseries.sh" >> ./SC08_Extract_ROI_timeseries.SWARM.sh
   done
done

echo "++ INFO: Script finished correctly."
