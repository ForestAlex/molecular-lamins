# Analysis on the full trajectories


### RMSD


### RMSF

`cd 2026_03-Ig-fold-M-high-mobility/Analysis/`

`mkdir {9J8M_R1,9J8M_R2,9J8M_R3,9J8M_H1,9J8M_H2,9J8M_H3,9J8M_Q1,9J8M_Q2,9J8M_Q3}/{rmsd,rmsf-lamin,rmsf-DNA,rmsf-BAF}`

- [X] Change into directory: `cd 9J8M_H1`
- [X] Run the RMSD over the complete centered trajectory:
`cp "../../../ptmp_link/Analysis/9J8M_Q3/Q3_cluster_frame0.pdb" . `
- :) Done for: R1, R2, H2, H3, H1, Q1, Q2, Q3
`echo 47 47| gmx rms -s "Q3_cluster_frame0.pdb" -f "../../../ptmp_link/Analysis/9J8M_Q3/Q3_final_centered-130000-frames.xtc" -o "rmsd/rmsd_9J8M_Q3.xvg" -n ../../../ptmp_link/Analysis/expanded_9J8M_Q_DNA-protein.ndx`
  * choose _Group 47 (DNAC3+proteinCA) has 1415 elements (for clustering)_

rms -s md.tpr -f md.xtc -n index.ndx -o rmsd_protein.xvg

`gmx rmsf -s "" -f "" -o rmsf_residue-DNA.xvg -n  -res`
`gmx rmsf -s "" -f "" -o rmsf_residue-BAF.xvg -n  -res`
`gmx rmsf -s "" -f "" -o rmsf_residue-LMNA.xvg -n  -res`

`gmx rmsf -s md.tpr -f md.xtc -n index.ndx -res -o rmsf_residue.xvg`


