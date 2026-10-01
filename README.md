# Simulation Tutorial for Lamin A-containing Complexes

We use GROMACS 2025.2 with the CHARMM force field.

- [X] Go to PyMol and fetch the *7Z21* PDB structure.
- [X] Remove Chain C, Chain F, the four chlorine atoms, and remove the water molecules.
- [X] Save this as .pdb.

### Mutations
- [X] Change the 522 CSD > Cysteine (use the mutagenesis tool in PyMol).
- [X] Change the 3x Threonine T > A Alanine (pos. 12 BAF).

### Preparations on server
- [X] Log into the Max Planck Garching ROBIN cluster (https://rvs.mpcdf.mpg.de/rv/)
- Note: The ROBIN cluster is better, because it runs equilibration faster.
- [X] Make a new directory `mkdir 2026_09-Ig-fold-7Z21`
- [X] Make 3 x 3 subdirectories for wild-type and mutant (e.g. **R**, **R2**, **R3**, **H**, **H2**, **H3**, **Q**, **Q2**, **Q3**) thus we will produce nine replicas in total (Optional: I added the **7Z21_R**, **7Z21_R2**, **7Z21_R3** to see BAF mutations in new force field).
- Note: We equilibrate all uniquely. This is better than just initializing with random velocities.
- [X] In this directory, make folders to now populate:
  - box
  - wrap
  - gro
  - solv
  - ions
  - top
  - data
- [X] In the data folder upload the prepared .pdb files:
  - 7Z21-WT-without-waters.pdb
  - 7Z21-RH-without-waters.pdb
  - 7Z21-RQ-without-waters.pdb
  - (7Z21-AT-without-waters.pdb for old in new force field)
- Optional: Download the **charmm36-feb2026_ljpme_cgenff-5.0.ff** force field, unpack it, add the folder to the `2026_09-Ig-fold-7Z21` master directory. See Note (1) below.
- [X] Load gromacs in the command line `module load gromacs/2025.2`


### Pre-equilibrations

- [X] 1. Convert the PDB files into GRO files: `gmx pdb2gmx -f "data/7Z21-WT-without-waters.pdb" -o "gro/R.gro" -ignh -missing`  
  - [X] Hopefully you did Note (1) above, then choose _1: From current directory: CHARMM all-atom force field_ otherwise choose the force field to your liking.
  - [X] Choose _1: TIP3P_ as water model.
  - Note: We require the flags `-ignh` and `-missing` to build the correct hydrogen topology and protonation for pH = 7 and complete side chains with missing atoms respective for the force field.
  - [X] This run generates a .gro and many .top (topology files). Make a subfolder **H**, **R**, **Q**, **7Z21_R** in the _top_ folder. Copy the topology files respectively to the mutation folder.
- [X] In total, this has to be repeated 4x times (for **H**, **R**, **Q**, **7Z21_R**).
    - `gmx pdb2gmx -f "data/7Z21-WT-without-waters.pdb" -o "gro/R.gro" -ignh -missing`
    - `gmx pdb2gmx -f "data/7Z21-RH-without-waters.pdb" -o "gro/H.gro" -ignh -missing`
    - `gmx pdb2gmx -f "data/7Z21-RQ-without-waters.pdb" -o "gro/Q.gro" -ignh -missing`
    - `gmx pdb2gmx -f "data/7Z21-AT-without-waters.pdb" -o "gro/7Z21_R.gro" -ignh -missing`
- [X] 2. 
