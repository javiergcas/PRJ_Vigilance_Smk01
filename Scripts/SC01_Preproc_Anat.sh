set -e
module load afni
PRJDIR='/data/SFIM_Vigilance/PRJ_Vigilance_Smk01/'
ORIG_DATA_DIR='/data/SFIM_Vigilance/Data/DSET01/'
PRCS_DATA_DIR=`echo ${PRJDIR}/PrcsData`

SBJ_DIR=`echo ${PRCS_DATA_DIR}/${SBJ}`
ANAT_DATA_DIR=`echo ${SBJ_DIR}/D01_Anatomical`

echo "++ Working on Subject ${SBJ}... pre-processing anatomical data"

# Create subject directory if needed
if [ ! -d ${SBJ_DIR} ]; then
   echo "++ INFO: New Subject directory created [${SBJ_DIR}]"
   mkdir ${SBJ_DIR}
fi

# Create directory for outputs of anatomical pre-processing if needed
if [ ! -d ${ANAT_DATA_DIR} ]; then 
   echo "++ INFO: New Anatomical Preprocessing directory created [${ANAT_DATA_DIR}]"
   mkdir ${ANAT_DATA_DIR}
fi

# Enter destination folder
cd ${ANAT_DATA_DIR}

# @SSwarper works best with BRIK/HEAD files... we need to transform the nii files
if [ ! -e ${ANAT_DATA_DIR}/${SBJ}_Anat+orig.HEAD ]; then
   echo "++INFO: Making a copy of original anatomical dataset in BRIK/HEAD format"
   3dcopy ${ORIG_DATA_DIR}/${SBJ}/ses-sleep/anat/${SBJ}_ses-sleep_T1w.nii ${SBJ}_Anat+orig
fi

# Run @SSwarper, which will compute transformation into MNI space
@SSwarper                                    \
   -input  ${SBJ}_Anat+orig                  \
   -base   MNI152_2009_template_SSW.nii.gz   \
   -subid  ${SBJ}                            \
   -odir   ${ANAT_DATA_DIR}                       \
   -warpscale 0.5                            \
   -verb
