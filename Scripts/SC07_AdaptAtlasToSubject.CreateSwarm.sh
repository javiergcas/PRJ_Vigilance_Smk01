# Oct/28/2020 - Javier Gonzalez-Castillo
#
# STEPS
#
# NOTE
#
set -e

NROIs=200
NumROIsID=`printf %04d ${NROIS}`
ORIG_DATA_DIR='/data/SFIM_Vigilance/Data/DSET01/'
subjects=(`ls ${ORIG_DATA_DIR} | tr -s '\n' ' '`)
subjects=("${subjects[@]/'README'}")   # The subject directory contains a README file. This is not a subject ID.
num_subjects=`echo "${#subjects[@]} -1" | bc -l`
echo "Subjects: ${subjects[@]}"

# Create log directory if needed
if [ ! -d ./SC07_AdaptAtlasToSubject.logs ]; then
   mkdir ./SC07_AdaptAtlasToSubject.logs
fi

# Write top comment in Swarm file 
echo "#Creation Date: `date`" > ./SC07_AdaptAtlasToSubject.SWARM.sh
echo "#swarm -f ./SC07_AdaptAtlasToSubject.SWARM.sh -g 32 -t 32 --partition quick,norm --logdir ./SC07_AdaptAtlasToSubject.logs" >> ./SC07_AdaptAtlasToSubject.SWARM.sh

# Write one entry per subject in Swarm file
for i in `seq 0 1 ${num_subjects}`
do
   if [ ! -z ${subjects[i]} ]; then
      echo "export SBJ=${subjects[i]} NROIS=200; sh ./SC07_AdaptAtlasToSubject.sh" >> ./SC07_AdaptAtlasToSubject.SWARM.sh
   fi
done

echo "++ INFO: Script finished correctly."
