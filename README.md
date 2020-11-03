# Vigilance - Samika's DSET 01

This repository containst scripts to process Samika's DSET 1. 

## Anatomical Processing

1. Run Freesurfer in anatomical data.
  * Skull-stripped version of anatomical
  * Ventricles mask (needed for CompCorr / Physiological noise removal)
  * White matter mask (needed for ANATICOR / Scanner instability confounds removal)
  * Potentially also for GM ribbon mask 

2. Run AFNI's @SUMA_Make_Spec_FS to convert Freesurfer outputs into AFNI's format
  * SUMA folder within Freesurfer SUBJECTS_DIR is the main output

3. Run AFNI's @SSwarper to compute non-linear transformation into MNI space

## Functional Preprocessing

Functional pre-processing is accomplished with AFNI's afni_proc.py program, followed by a series of additional steps that are specific to sliding window correlation analyses. 
