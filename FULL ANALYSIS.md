# Analysis on the full trajectories

`cd 2026_03-Ig-fold-M-high-mobility/Analysis/`

### RMSD

- [X] Change into directory: `cd 9J8M_H1`
- [X] Run the RMSD over the complete centered trajectory:
`cp "../../../ptmp_link/Analysis/9J8M_Q3/Q3_cluster_frame0.pdb" . `
- :) Done for: R1, R2, H2, H3, H1, Q1, Q2, Q3
`echo 47 47| gmx rms -s "Q3_cluster_frame0.pdb" -f "../../../ptmp_link/Analysis/9J8M_Q3/Q3_final_centered-130000-frames.xtc" -o "rmsd/rmsd_9J8M_Q3.xvg" -n ../../../ptmp_link/Analysis/expanded_9J8M_Q_DNA-protein.ndx`
  * choose _Group 47, 47 (DNAC3+proteinCA) has 1415 elements (for alignment and RMSD calculation)_


### RMSF

- in master directory (_Analysis_): 
`mkdir {9J8M_R1,9J8M_R2,9J8M_R3,9J8M_H1,9J8M_H2,9J8M_H3,9J8M_Q1,9J8M_Q2,9J8M_Q3}/{rmsd,rmsf-lamin,rmsf-DNA,rmsf-BAF}`

- in master directory (_Analysis):
- [X] Make index entries for BAF & C$\alpha$: `gmx make_ndx -f "9J8M_H1/raven_md_9J8M_H1.tpr" -o "expanded-rmsd-H.ndx" -n "expanded_9J8M_H_DNA-protein.ndx"`
 - [X] choose `40 & 3`
 - [X] choose `33 & 3`
 * :) Done for: H, R, Q 

 *  _46 C3-DNA:   368 atoms_
 *  _48 BAF_dimer_&_C-alpha:   176 atoms_
 *  _36 LMNA_&_C-alpha:   119 atoms_
 *  _49 HISTONES_&_C-alpha:   752 atoms_

- [X] Now change directory: `cd 9J8M_H1`
- [X] For DNA: `echo 46|gmx rmsf -s "R3_cluster_frame0.pdb" -f "../../../ptmp_link/Analysis/9J8M_R3/R3_final_centered-130000-frames.xtc" -o "rmsf-DNA/rmsf_residue-R3-DNA.xvg" -n "../expanded-rmsd-R.ndx"` (-fit yes automatic default)
 * Done for: Q1, Q3, Q2, H3, H2, H1, R1, R2, R3
- [X] For BAF: `echo 48|gmx rmsf -s "Q3_cluster_frame0.pdb" -f "../../../ptmp_link/Analysis/9J8M_Q3/Q3_final_centered-130000-frames.xtc" -o "rmsf-BAF/rmsf_residue-Q3-BAF.xvg" -n "../expanded-rmsd-Q.ndx"`
 * Done for: R3, R2, R1, H1, H2, H3, Q1, Q2, Q3
- [X] For LMNA: `echo 36|gmx rmsf -s "R1_cluster_frame0.pdb" -f "../../../ptmp_link/Analysis/9J8M_R1/R1_final_centered-130000-frames.xtc" -o "rmsf-lamin/rmsf_residue-R1-lamin.xvg" -n "../expanded-rmsd-R.ndx"`
 * Done for: Q3, Q2, Q1, H1, H2, H3, R3, R2, R1



