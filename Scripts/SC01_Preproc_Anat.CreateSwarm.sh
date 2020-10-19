set -e

ORIG_DATA_DIR='/data/SFIM_Vigilance/Data/DSET01/'

subjects=(`ls ${ORIG_DATA_DIR} | tr -s '\n' ' '`)
num_subjects=`echo "${#subjects[@]} -1" | bc -l`
echo "#swarm -f ./SC01_Preproc_Anat.SWARM.sh -g 32 -t 32 --partition quick,normal" > ./SC01_Preproc_Anat.SWARM.sh
for i in `seq 0 1 ${num_subjects}`
do
   echo "export SBJ=${subjects[i]}; sh ./SC01_Preproc_Anat.sh" >> ./SC01_Preproc_Anat.SWARM.sh
done
