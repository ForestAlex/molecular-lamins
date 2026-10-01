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
  - DOWNLOAD ALL THE .GRO FILES AND CHECK IF THE CORRECT MUTATIONS IN THE CORRECT PLACES ARE THERE. 
- [X] 2. Put into box: `gmx editconf -f "gro/R.gro" -o "box/R.gro" -c -d 1.2 -bt dodecahedron`
  - [X] In total, this has to be repeated 4x times (for **H**, **R**, **Q**, **7Z21_R**). No .top files will be generated here.
  - Optional: DOWNLOAD ALL THE .GRO FILES AND CHECK.
- [X] 3. Add waters with the spc216.gro standard water model (incl. in GROMACS): `gmx solvate -cp "box/R.gro" -cs spc216.gro -o "solv/R.gro" -p "top/R/topol.top"`
  - [X] In total, this has to be repeated 4x times (for **H**, **R**, **Q**, **7Z21_R**). New .top files will be generated in the respective folders (the old ones marked with hashtags ###.)
  - Optional: DOWNLOAD ALL THE .GRO FILES AND CHECK.
- [X] 4a. Add the file  _ions.mdp_ file in the `2026_09-Ig-fold-7Z21` master directory. (See this GitHub repository for file.)
- [X] 4b. Add now small run with this unique _ions.mdp_ file: `gmx grompp -f ions.mdp -c "solv/R.gro" -p "top/R/topol.top" -o "ions/R.tpr" -maxwarn 1`
  - Docs: R (LD random seed to 927660767), Q (LD random seed to 429910271), H (LD random seed to -109202057), 7Z21_R (LD random seed to -33637261)
  - Note: The `-maxwarn 2` option verifies that the system is large, and that we will later add charges.
  - [X] In total, this has to be repeated 4x times (for **H**, **R**, **Q**, **7Z21_R**). 
- [X] 5. Add now the ions (we use potassium and chloride as these are most prevalent in the nuclear environment): `gmx genion -s "ions/R.tpr" -o "solv/ions_R.gro" -p "top/R/topol.top" -pname K -nname CL -conc 0.1 -neutral`
  - Choose _13: SOL_ to replace solvent molecules with ions (otherwise you would replace your protein atoms).
  - [X] In total, this has to be repeated 4x times (for **ions_H**, **ions_R**, **ions_Q**, **ions_7Z21_R**).
  - DOWNLOAD ALL THE IONS_X.GRO FILES AND CHECK IF THE CORRECT MUTATIONS IN THE CORRECT PLACES ARE THERE.

### Energy Minimization (EM) equilibration

- [X] Upload the _minim.mdp_ file in the `2026_09-Ig-fold-7Z21` master directory. (See this GitHub repository for file.) 

**Repeat this now 3 x WT (parallelize in different consoles)**

- [X] Go to the folder with the respective name, e.g. _R_. (We created it at the beginning, it should be empty.)
- [X] Prepare run `gmx grompp -f "../minim.mdp" -c "../solv/ions_R.gro" -p "../top/R/topol.top" -o "em_R.tpr" -maxwarn 2`
- [X] Run `mpirun gmx_mpi mdrun -s "em_R.tpr" -deffnm "em_R" -ntomp 12`
  - R (-145229826), R2 (-1318948), R3 (-137634571), Q (-1196073), Q2 (-278663313), Q3 (1470487909), H (-1714243), H2 (-1376784753), H3 (-295772933), 7Z21_R (-1411653833), 7Z21_R2 (-87425033), 7Z21_R3 (-67474433)
  - `cd 2026_09-Ig-fold-7Z21/R2` ... change to next directory and repeat independent equilibrations.
  - RENAME IF REPLICA: `gmx grompp -f "../minim.mdp" -c "../solv/ions_R.gro" -p "../top/R/topol.top" -o "em_R`**2**`.tpr" -maxwarn 2`
  - 
- [X] Make another subfolder in the e.g. _R_ and move the files there (to clean up your brain).
     
**Repeat this for 3 x Q (parallelize in different consoles)**

**Repeat this for 3 x H (parallelize in different consoles)**

**Repeat this for 3 x 7Z21_R (parallelize in different consoles)**

- [X] FOR ALL: Run `gmx energy -f em_R.edr -o "potential_em_R.xvg"` (choose _11: Potential_)
- [X] FOR ALL: Check convergence with the plotting modality (see Jupyter notebook attached). 


### NVT equilibrations (100 ps)

- [X] Upload the _nvt.mdp_ file `2026_09-Ig-fold-7Z21` master directory. (See this GitHub repository for file.) 
- [X] Prepare run for all replicas: `gmx grompp -f "../nvt.mdp" -c "em/em_R.gro" -r "em/em_R.gro" -p "../top/R/topol.top" -o "nvt_R.tpr"`
  - R (), R2 (), R3 (), Q (-1345325316), Q2 (1993538489), Q3 (-5252099), H (), H2 (), H3 (), 7Z21_R (-1146667139), 7Z21_R2 (-43160577), 7Z21_R3 (-572575041) 
- [X] Run all replicas: `mpirun gmx_mpi mdrun -s "nvt_7Z21_R.tpr" -deffnm "nvt_7Z21_R" -ntomp 12`
- Note: The process is similar to the above.
- Note: Make another subfolder _nvt_ in the e.g. _R_ and move the respective files there (to clean up your brain).

- [X] FOR ALL: Run `gmx energy -f nvt_R.edr -o "temperature_nvt_R.xvg"` (choose _Temperature_)

### NPT equilibrations (500 ps)

- [X] Upload the _npt.mdp_ file `2026_09-Ig-fold-7Z21` master directory. (See this GitHub repository for file.)
- [X] Prepare run for all replicas: `gmx grompp -f "../npt.mdp" -c "nvt/nvt_R.gro" -r "nvt/nvt_R.gro" -p "../top/9R/topol.top" -o "npt_R.tpr" `
- [X] Run all replicas: `mpirun gmx_mpi mdrun -s "npt_R.tpr" -deffnm "npt_R" -ntomp 12`
- Note: The process is similar to the above.
- Note: Make another subfolder _npt_ in the e.g. _R_ and move the respective files there (to clean up your brain).

- [X] FOR ALL: Run `gmx energy -f npt_R.edr -o "pressure_npt_R.xvg"` (choose _Pressure_)
- [X] FOR ALL: ONLY IF ENERGY, TEMPERATURE, PRESSURE STABILIZED CONTINUE WITH PRODUCTION RUNS.


## PRODUCTION RUN (1-2 µs)

- [X] Upload the _npt.mdp_ file `2026_09-Ig-fold-7Z21` master directory. (See this GitHub repository for file.)
