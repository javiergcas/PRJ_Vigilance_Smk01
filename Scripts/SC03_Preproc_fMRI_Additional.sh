#!/bin/bash

set -e

cd /data/SFIM_Vigilance/PRJ_Vigilance_Smk01/PrcsData/${SBJ}/D02_Preproc_fMRI

# # 1) Do radcorr on the fully clean data
# # =====================================
if [ -d radcor.pb06.fanaticor ]; then
    rm -rf radcor.pb06.fanaticor
fi
 
@radial_correlate -nfirst 0 -do_clean yes -rdir radcor.pb06.fanaticor -mask full_mask.${SBJ}+tlrc. errts.${SBJ}.fanaticor+tlrc
# 
# # 2) Add this additional result to the report
# # ===========================================
# apqc_make_tcsh.py -review_style pythonic -SBJ_dir . \
#         -uvar_json out.ss_review_uvars.json
# tcsh @ss_review_html |& tee out.review_html
# apqc_make_html.py -qc_dir QC_${SBJ}

# 3) Create additional clean datasets with other filterings for SWC analyses
# ==========================================================================
NUM_ACQ=`3dinfo -nt errts.${SBJ}.fanaticor+tlrc | awk '{print $0}'`
TR=`3dinfo -tr errts.${SBJ}.fanaticor+tlrc | awk '{print $0}'`
# 3.1) WL = 60s ==> 30 time-points per window
# -------------------------------------------
# hpass 1/60 = 0.017 
1dBport -nodata ${NUM_ACQ} ${TR} -band 0.017 0.18 -invert -nozero > bandpass_rall.wl060s.1D

3dDeconvolve -overwrite -input pb05.${SBJ}.r*.scale+tlrc.HEAD                         \
    -censor censor_${SBJ}_combined_2.1D                                  \
    -ortvec bandpass_rall.wl060s.1D bandpass160s                          \
    -ortvec ROIPC.FSvent.r01.1D ROIPC.FSvent.r01                          \
    -ortvec mot_demean.r01.1D mot_demean_r01                              \
    -ortvec mot_deriv.r01.1D mot_deriv_r01                                \
    -polort 5                                                             \
    -num_stimts 0                                                         \
    -jobs 32                                                              \
    -fout -tout -x1D X.xmat.wl060s.1D -xjpeg X.wl060s.jpg                 \
    -x1D_uncensored X.nocensor.xmat.wl060s.1D                             \
    -fitts fitts.wl060s.${SBJ}                                             \
    -errts errts.wl060s.${SBJ}                                           \
    -x1D_stop                                                             \
    -cbucket all_betas.wl060s.${SBJ}                                       \
    -bucket stats.wl060s.${SBJ}

3dTproject -overwrite -polort 0 -input pb05.${SBJ}.r*.scale+tlrc.HEAD                 \
           -censor censor_${SBJ}_combined_2.1D -cenmode NTRP             \
           -ort X.nocensor.xmat.wl060s.1D -prefix errts.${SBJ}.wl060s.tproject

# display any large pairwise correlations from the X-matrix
1d_tool.py -show_cormat_warnings -infile X.xmat.wl060s.1D |& tee out.cormat_warn.wl060s.txt

# display degrees of freedom info from X-matrix
1d_tool.py -show_df_info -infile X.xmat.wl060s.1D |& tee out.df_info.wl060s.txt

# -- use 3dTproject to project out regression matrix --
#    (make errts like 3dDeconvolve, but more quickly)
3dTproject -overwrite -polort 0 -input pb05.${SBJ}.r*.scale+tlrc.HEAD                 \
           -censor censor_${SBJ}_combined_2.1D -cenmode NTRP             \
           -dsort Local_FSWe_rall+tlrc                                    \
           -ort X.nocensor.xmat.wl060s.1D -prefix errts.${SBJ}.wl060s.fanaticor

# 3.2) WL = 46s ==> 23 time-points per window
# -------------------------------------------
# hpass 1/46 = 0.022
1dBport -nodata ${NUM_ACQ} ${TR} -band 0.022 0.18 -invert -nozero > bandpass_rall.wl046s.1D

3dDeconvolve -overwrite -input pb05.${SBJ}.r*.scale+tlrc.HEAD                         \
    -censor censor_${SBJ}_combined_2.1D                                  \
    -ortvec bandpass_rall.wl046s.1D bandpass160s                          \
    -ortvec ROIPC.FSvent.r01.1D ROIPC.FSvent.r01                          \
    -ortvec mot_demean.r01.1D mot_demean_r01                              \
    -ortvec mot_deriv.r01.1D mot_deriv_r01                                \
    -polort 5                                                             \
    -num_stimts 0                                                         \
    -jobs 32                                                              \
    -fout -tout -x1D X.xmat.wl046s.1D -xjpeg X.wl046s.jpg                 \
    -x1D_uncensored X.nocensor.xmat.wl046s.1D                             \
    -fitts fitts.wl046s.${SBJ}                                             \
    -errts errts.wl046s.${SBJ}                                           \
    -x1D_stop                                                             \
    -cbucket all_betas.wl046s.${SBJ}                                       \
    -bucket stats.wl046s.${SBJ}

3dTproject -overwrite -polort 0 -input pb05.${SBJ}.r*.scale+tlrc.HEAD                 \
           -censor censor_${SBJ}_combined_2.1D -cenmode NTRP             \
           -ort X.nocensor.xmat.wl046s.1D -prefix errts.${SBJ}.wl046s.tproject

# display any large pairwise correlations from the X-matrix
1d_tool.py -show_cormat_warnings -infile X.xmat.wl046s.1D |& tee out.cormat_warn.wl046s.txt

# display degrees of freedom info from X-matrix
1d_tool.py -show_df_info -infile X.xmat.wl046s.1D |& tee out.df_info.wl046s.txt

# -- use 3dTproject to project out regression matrix --
#    (make errts like 3dDeconvolve, but more quickly)
3dTproject -overwrite -polort 0 -input pb05.${SBJ}.r*.scale+tlrc.HEAD                 \
           -censor censor_${SBJ}_combined_2.1D -cenmode NTRP             \
           -dsort Local_FSWe_rall+tlrc                                    \
           -ort X.nocensor.xmat.wl046s.1D -prefix errts.${SBJ}.wl046s.fanaticor

# 3.3) WL = 30s ==> 15 time-points per window
# -------------------------------------------
# hpass 1/30 = 0.033
1dBport -nodata ${NUM_ACQ} ${TR} -band 0.033 0.18 -invert -nozero > bandpass_rall.wl030s.1D

3dDeconvolve -overwrite -input pb05.${SBJ}.r*.scale+tlrc.HEAD                         \
    -censor censor_${SBJ}_combined_2.1D                                  \
    -ortvec bandpass_rall.wl030s.1D bandpass160s                          \
    -ortvec ROIPC.FSvent.r01.1D ROIPC.FSvent.r01                          \
    -ortvec mot_demean.r01.1D mot_demean_r01                              \
    -ortvec mot_deriv.r01.1D mot_deriv_r01                                \
    -polort 5                                                             \
    -num_stimts 0                                                         \
    -jobs 32                                                              \
    -fout -tout -x1D X.xmat.wl030s.1D -xjpeg X.wl030s.jpg                 \
    -x1D_uncensored X.nocensor.xmat.wl030s.1D                             \
    -fitts fitts.wl030s.${SBJ}                                             \
    -errts errts.wl030s.${SBJ}                                           \
    -x1D_stop                                                             \
    -cbucket all_betas.wl030s.${SBJ}                                       \
    -bucket stats.wl030s.${SBJ}

3dTproject -overwrite -polort 0 -input pb05.${SBJ}.r*.scale+tlrc.HEAD                 \
           -censor censor_${SBJ}_combined_2.1D -cenmode NTRP             \
           -ort X.nocensor.xmat.wl030s.1D -prefix errts.${SBJ}.wl030s.tproject

# display any large pairwise correlations from the X-matrix
1d_tool.py -show_cormat_warnings -infile X.xmat.wl030s.1D |& tee out.cormat_warn.wl030s.txt

# display degrees of freedom info from X-matrix
1d_tool.py -show_df_info -infile X.xmat.wl030s.1D |& tee out.df_info.wl030s.txt

# -- use 3dTproject to project out regression matrix --
#    (make errts like 3dDeconvolve, but more quickly)
3dTproject -overwrite -polort 0 -input pb05.${SBJ}.r*.scale+tlrc.HEAD                 \
           -censor censor_${SBJ}_combined_2.1D -cenmode NTRP             \
           -dsort Local_FSWe_rall+tlrc                                    \
           -ort X.nocensor.xmat.wl030s.1D -prefix errts.${SBJ}.wl030s.fanaticor
