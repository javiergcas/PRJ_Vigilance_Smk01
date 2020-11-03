# Vigilance - Samika's DSET 01

This repository containst scripts to process Samika's DSET 1. 

## Anatomical Processing

1. Run _Freesurfer_ in anatomical data [**SC00a_Freesurfer**]
  * Skull-stripped version of anatomical
  * Ventricles mask (needed for CompCorr / Physiological noise removal)
  * White matter mask (needed for ANATICOR / Scanner instability confounds removal)
  * Potentially also for GM ribbon mask 

2. Run AFNI's _@SUMA_Make_Spec_FS_ to convert Freesurfer outputs into AFNI's format
  * SUMA folder within Freesurfer SUBJECTS_DIR is the main output

3. Run AFNI's _@SSwarper_ to compute non-linear transformation into MNI space

## Functional Preprocessing

Functional pre-processing is accomplished with AFNI's afni_proc.py program, followed by a series of additional steps that are specific to sliding window correlation analyses. 

1. AFNI's afni_proc.py
  * Spike Removal
  * Time Shift Correction (ensure TR and slice timing information is available in file headers)
  * Compute alignment between Anatomical and EPI data
  * Estimate Head Motion
  * Bring Motion corrected data into MNI Space
  * Spatial Smoothing (FWHM = 4mm)
  * Compute Full Brain Masks
  * Scale timeseries to signal percent change
  * Nuisance regression: motion, first derivative of motion, 3 PCA's from ventricles (_CompCorr_), local white matter (_ANATICOR_), bandpass filtering (0.01 - 0.1Hz)
  * Generate Quality Control HTML reports
  
2. Additional pre-processing
  * Generate pre-processed timeseries with other filtering schemes
  * For 60s sliding windows [0.017 - 0.18 Hz]
  * For 46s sliding windows [0.022 - 0.18 Hz]
  * For 30s sliding windows [0.033 - 0.18 Hz]
  
3. Find voxels with excessive variance (i.e., big vasculature)
  * Find voxels with stdev > 3
  * Remove such voxels from final full brain mask
  

