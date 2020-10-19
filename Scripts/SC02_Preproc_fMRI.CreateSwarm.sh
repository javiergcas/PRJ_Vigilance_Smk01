set -e

module load afni

PRJDIR='/data/SFIM_Vigilance/PRJ_Vigilance_Smk01/'

echo "#swarm -f ./SC02_Preproc_fMRI.SWARM.sh -g 32 -t 32 --partition quick" > ./SC02_Preproc_fMRI.SWARM.sh

if [ ! -d SC02_Preproc_fMRI ]; then 
   mkdir SC02_Preproc_fMRI
fi

ORIG_DATA_DIR='/data/SFIM_Vigilance/Data/DSET01/'
subjects=(`ls ${ORIG_DATA_DIR}/sub* | tr -s '\n' ' '`)

for SBJ in ${subjects[@]}
do
  ANAT_PROC_DIR=`echo ${PRJDIR}/PrcsData/${SBJ}/D01_Anatomical`
  FMRI_ORIG_DIR=`echo ${PRJDIR}/PrcsData/${SBJ}/D00_OriginalData`
  # Create D00_OriginalData Directory if needed
  if [ ! -d ${FMRI_ORIG_DIR} ]; then
     mkdir ${FMRI_ORIG_DIR}
  fi
  # Create a BRIK/HEAD version of the input data if needed
  INPUT_PATH=`echo ${FMRI_DATA_DIR}/${SBJ}_ses-sleep-task-spatatt+orig.HEAD`
  if [ ! -e ${INPUT_PATH} ]; then
     3dcopy ${ORIG_DATA_DIR}/${SBJ}/ses-sleep/func/${SBJ}_ses-sleep_task-spialattention_bold.nii.gz \
            ${INPUT_PATH}
  fi

  # Run afni_proc.py to generate the pre-processing script for this particular run
  OUT_DIR=`echo ${PRJDIR}/PrcsData/${SBJ}/D02_Preproc_fMRI`
  afni_proc.py                                                                  \
             -subj_id ${SBJ}                                                    \
             -copy_anat ${ANAT_PROC_DIR}/anatSS.${SBJ}.nii                      \
             -anat_has_skull no                                                 \
             -anat_follower anat_w_skull anat ${ORIG_DIR}/${SBJ}_Anat+orig      \
             -dsets ${INPUT_PATH}                                               \
             -blocks tshift align tlrc volreg blur mask regress                 \
             -radial_correlate_blocks tcat volreg                               \
             -tcat_remove_first_trs 0                                           \
             -align_opts_aea -AddEdge -cost lpc+ZZ -giant_move -check_flip      \
             -align_epi_strip_method 3dSkullStrip                               \
             -tlrc_base MNI152_2009_template_SSW.nii.gz                         \
             -tlrc_NL_warp                                                      \
             -tlrc_NL_warped_dsets ${ANAT_PROC_DIR}/anatQQ.${SBJ}.nii           \
                 ${ANAT_PROC_DIR}/anatQQ.${SBJ}.aff12.1D                        \
                 ${ANAT_PROC_DIR}/anatQQ.${SBJ}_WARP.nii                        \
    	     -tshift_opts_ts -tpattern alt+z2                                   \
             -volreg_align_to first                                             \
             -mask_epi_anat yes                                                 \
             -blur_size 4.0                                                     \
             -regress_opts_3dD -jobs 32                                         \
             -regress_motion_per_run                                            \
             -regress_censor_motion 0.1                                         \
             -regress_censor_outliers 0.05                                      \
             -regress_apply_mot_types demean deriv                              \
             -regress_make_ideal_sum sum_ideal.1D                               \
             -regress_est_blur_epits                                            \
             -regress_est_blur_errts                                            \
             -regress_run_clustsim no                                           \
             -html_review_style pythonic                                        \
             -out_dir ${OUT_DIR}                                                \
             -script  SC04_Preproc_fMRI.${SBJ}.sh                               \
    	     -volreg_compute_tsnr yes \
             -regress_compute_tsnr yes \
             -mask_segment_anat yes \
             -mask_segment_erode yes \
             -regress_make_cbucket yes \
             -mask_intersect WM_inFB brain WM \
             -mask_intersect GM_inFB brain GM \
             -mask_intersect CSF_inFB brain CSF \
             -mask_intersect WMe_inFB brain WMe \
             -mask_intersect GMe_inFB brain GMe \
             -mask_intersect CSFe_inFB brain CSFe \
             -scr_overwrite                                         
      sed -i 's/-cenmode ZERO/-cenmode NTRP/g' SC02_Preproc_fMRI.${SBJ}.sh
      mv SC02_Preproc_fMRI.${SBJ}.sh SC02_Preproc_fMRI/
      echo "module load afni; tcsh -xef ./SC02_Preproc_fMRI/SC02_Preproc_fMRI.${SBJ}.sh 2>&1 | tee ./SC02_Preproc_fMRI/output.SC02_Preproc_fMRI.${SBJ}.txt" >> ./SC02_Preproc_fMRI.SWARM.sh
done
