# Simulation Tutorial for Lamin A-containing Complexes

We use GROMACS 2025.2 with the CHARMM force field.

- [X] Go to PyMol and fetch the *7Z21* PDB structure.
- [X] Remove Chain C, Chain F, the four chlorine atoms, and remove the hydrogen atoms.
- [X] Save this as .pdb.

### Mutations
- [X] Change the 522 CSD > Cysteine (use the mutagenesis tool in PyMol).
- [X] Change the 3x Threonine T > A Alanine (pos. 12 BAF).

### Preparations on server
- [X] Log into the Max Planck Garching ROBIN cluster (https://rvs.mpcdf.mpg.de/rv/)
- Note: The ROBIN cluster is better, because it runs equilibration faster.
- [X] Make a new directory `mkdir 2026_09-Ig-fold-7Z21`
- [X] In this directory, make folders:
  - box
  - data
  - gro
  - solv
  - ions
  - top
  - wrap
- [X] Make 3 x 3 subdirectories for wild-type and mutant (e.g. **Ig-fold-R**, **Ig-fold-R2**, **Ig-fold-R3**, **Ig-fold-H**, **Ig-fold-H2**, **Ig-fold-H3**, **Ig-fold-Q**, **Ig-fold-Q2**, **Ig-fold-Q3**) thus we will produce nine replicas in total
- Note: We equilibrate all uniquely. This is better than just initializing with random velocities.

### Pre-equilibrations
- [X] Load gromacs in the command line `module load gromacs/2025.2`
- [X]  
