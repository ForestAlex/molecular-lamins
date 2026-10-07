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
- [X] Run all replicas: `mpirun gmx_mpi mdrun -s "nvt_7Z21_R.tpr" -deffnm "nvt_7Z21_R" -ntomp 12`
- Note: The process is similar to the above.
- Note: Make another subfolder _nvt_ in the e.g. _R_ and move the respective files there (to clean up your brain).

- [X] FOR ALL: Run `gmx energy -f nvt_R.edr -o "temperature_nvt_R.xvg"` (choose _Temperature_)

### NPT equilibrations (500 ps)

- [X] Upload the _npt.mdp_ file `2026_09-Ig-fold-7Z21` master directory. (See this GitHub repository for file.)
- [X] Prepare run for all replicas: `gmx grompp -f "../npt.mdp" -c "nvt/nvt_R.gro" -r "nvt/nvt_R.gro" -p "../top/R/topol.top" -o "npt_R.tpr" `
- [X] Run all replicas: `mpirun gmx_mpi mdrun -s "npt_R.tpr" -deffnm "npt_R" -ntomp 12`
- Note: The process is similar to the above.
- Note: Make another subfolder _npt_ in the e.g. _R_ and move the respective files there (to clean up your brain).

- [X] FOR ALL: Run `gmx energy -f npt_R.edr -o "pressure_npt_R.xvg"` (choose _Pressure_)
- [X] FOR ALL: ONLY IF ENERGY, TEMPERATURE, PRESSURE STABILIZED CONTINUE WITH PRODUCTION RUNS.


## PRODUCTION RUN (1-2 µs)

- [X] Upload the md.mdp_ file `2026_09-Ig-fold-7Z21` master directory. (See this GitHub repository for file.)
- [X] Prepare run for all replicas: `gmx grompp -f "../md.mdp" -c "npt/npt_R.gro" -p "../top/R/topol.top" -t "npt/npt_R.cpt" -o "production_md_R.tpr"`
- [X] This is the run command you will need:  `mpirun gmx_mpi mdrun -s "production_md_R.tpr" -deffnm "production_md_R" -ntomp 12`


# ANALYZING MD: Clustering and extracting subsets (now we switch to the large 9J8M runs)

We need to extract a subset of the full trajectory for analysis, then further upon this cluster. Otherwise, the data gets expensively large quickly. First, I made index files with the respective atoms per chain in protein group for analysis (See this GitHub repository for files.)

### Subsampling and centering trajectories

- [X] Make a new _analysis_ folder in your master directory
- [X] Make subfolders per replica in this master directory
- [X] **Subsample** every 100th frame: `gmx trjconv -s raven_md_9J8M_R.tpr -f "../../9J8M_R/raven_md_9J8M_R.xtc" -skip 100 -o R_nojump-1000-frames.xtc -pbc nojump -n cluster_9J8M_H-DNA-protein.ndx`
  - [X] Note: This command samples from the run folder (_../.._) into the analysis folder. Do not copy the .xtc, you or your computer will die. 
  - [X]  Choose _Group 35: system_with_LMNA_ (to extract all, but without water and ions due to size limit)
  - Note: This command with **nojump** removes the periodic boundary conditions to place your molecule in one unit cell. But further steps are needed to make trajectories extracted analyzable.  
- [X] **Cluster:** `gmx trjconv -s raven_md_9J8M_R.tpr -f R_nojump-1000-frames.xtc -o R_clustered-1000-frames.xtc -pbc cluster -n cluster_9J8M_R-DNA-protein.ndx`
  - [X] Choose _Group 34: system_without_LMNA_ (this is like putting a frame around lamin, to not confound analysis on clustering already here)
  - [X] Choose _Group 35: system_with_LMNA_ (to output all)
  - [X] Note: Without clustering, the centering does not often succeed and you get (subsampled) trajectories that do not run as a smooth movie around the object you like. So they would be correct, but you would not be able to see the important movements, between all the rapid movements.
- [X] **Center:** `gmx trjconv -s raven_md_9J8M_R.tpr -f R_clustered-1000-frames.xtc -o R_centered-1000-frames.xtc -center -pbc mol -ur compact -n cluster_9J8M_R-DNA-protein.ndx`
  - [X] Choose _Group 34: system_without_LMNA_ (again, this helps to center on the frame and build a center stage on which your molecule can dance)
  - [X] Choose _Group 35: system_with_LMNA_ (to output all)

### Clustering

- [X] `cd 2026_03-Ig-fold-M-high-mobility/analysis/9J8M_R`
- [X] Open directory for output files: `mkdir cluster-lamin-0.2` 
- [X] Cluster the extracted 1000 frames per 3x3 replicas **at cutoff 0.2** (use the same R/H/Q index file for X,X2,X3 respectively): `gmx cluster -f R2_centered-1000-frames.xtc -s raven_md_9J8M_R2.tpr -n cluster_9J8M_R-DNA-protein.ndx -b 0 -cutoff 0.2 -method gromos -om cluster-lamin-0.2/rmsd-raw.xpm -o cluster-lamin-0.2/rmsd-clust.xpm -g cluster-lamin-0.2/cluster.log -dist cluster-lamin-0.2/rmsd-dist.xvg -conv cluster-lamin-0.2/mc-conv.xvg -sz cluster-lamin-0.2/clustsize.xvg -tr cluster-lamin-0.2/clustertrans.xpm -ntr cluster-lamin-0.2/clustertrans.xvg -clid cluster-lamin-0.2/clusterid.xvg -cl cluster-lamin-0.2/clusters.pdb -clndx cluster-lamin-0.2/clindex.ndx`
  - [X] Choose _Group 32: LMNA_ (to calculate RMSD for)
  - [X] Choose _Group 35: system_with_LMNA_ (to extract all, but without water and ions due to size limit)
  - [X] Note: These are now in _cluster-lamin_ (as these are centered/aligned on lamin).
- [X] Cluster the extracted 1000 frames per 3x3 replicas **at cutoff 0.15** (use the same R/H/Q index file for X,X2,X3 respectively): `gmx cluster -f Q3_centered-1000-frames.xtc -s raven_md_9J8M_Q3.tpr -n cluster_9J8M_Q-DNA-protein.ndx -b 0 -cutoff 0.15 -method gromos -om cluster-lamin-0.15/rmsd-raw.xpm -o cluster-lamin-0.15/rmsd-clust.xpm -g cluster-lamin-0.15/cluster.log -dist cluster-lamin-0.15/rmsd-dist.xvg -conv cluster-lamin-0.15/mc-conv.xvg -sz cluster-lamin-0.15/clustsize.xvg -tr cluster-lamin-0.15/clustertrans.xpm -ntr cluster-lamin-0.15/clustertrans.xvg -clid cluster-lamin-0.15/clusterid.xvg -cl cluster-lamin-0.15/clusters.pdb -clndx cluster-lamin-0.15/clindex.ndx`
  - [X] Choose _Group 32: LMNA_ (to calculate RMSD for)
  - [X] Choose _Group 35: system_with_LMNA_ (to extract all, but without water and ions due to size limit)
  - [X] Note: These are now in _cluster-lamin_ (as these are centered/aligned on lamin).
- [X] Optional: Cluster the extracted 1000 frames per 3x3 replicas **at cutoff 0.15 but only on C-alphas** (use the same R/H/Q index file for X,X2,X3 respectively): `gmx cluster -f R3_centered-1000-frames.xtc -s raven_md_9J8M_R3.tpr -n expanded_9J8M_R_DNA-protein.ndx -b 0 -cutoff 0.15 -method gromos -om cluster-lamin-ca-0.15/rmsd-raw.xpm -o cluster-lamin-ca-0.15/rmsd-clust.xpm -g cluster-lamin-ca-0.15/cluster.log -dist cluster-lamin-ca-0.15/rmsd-dist.xvg -conv cluster-lamin-ca-0.15/mc-conv.xvg -sz cluster-lamin-ca-0.15/clustsize.xvg -tr cluster-lamin-ca-0.15/clustertrans.xpm -ntr cluster-lamin-ca-0.15/clustertrans.xvg -clid cluster-lamin-ca-0.15/clusterid.xvg -cl cluster-lamin-ca-0.15/clusters.pdb -clndx cluster-lamin-ca-0.15/clindex.ndx`
  - [X] Choose _Group 36: LMNA & CA_ (to calculate RMSD for)
  - [X] Choose _Group 35: system_with_LMNA_ (to extract all, but without water and ions due to size limit)
  - [X] Note: These are now in _cluster-lamin_ (as these are centered/aligned on lamin).
- [X] Optional: make another directory (if renamed): `mkdir cluster`
  - [X] **Cluster at cutoff = 0.3**:  `gmx cluster -f H_centered-1000-frames.xtc -s raven_md_9J8M_H.tpr -n cluster_9J8M_H-DNA-protein.ndx -b 0 -cutoff 0.3 -method gromos -om cluster/rmsd-raw-outside.xpm -o cluster/rmsd-clust-outside.xpm -g cluster/cluster-outside.log -dist cluster/rmsd-dist-outside.xvg -conv cluster/mc-conv-outside.xvg -sz cluster/clustsize-outside.xvg -tr cluster/clustertrans-outside.xpm -ntr cluster/clustertrans-outside.xvg -clid cluster/clusterid-outside.xvg -cl cluster/clusters-outside.pdb -clndx cluster/clindex-outside.ndx`
  - [X] Use the same cluster command, but choose _Group 34: system-no-lmna_ (to cluster on the counterpart)
  - [X] Choose _Group 35: system_with_LMNA_


### Make new index files
- [X] To make an index file from the starting one **please use atoms**. Our system has many chains and residues or positions would not be unique.
- [X] Go to a _.gro_ file which holds your system. Open it in text editor. Find the atom numbers.
- [X] Run:
- [X] Type _a 1-12_ (place your respective atom numbers)
- [X] Type _name 37 MYGROUPNAME_ (replace with respective atom numbers)

### Analysis of the clusters
- [X] Download the C-$\alpha$_**0.15** clusters for all 3 x 3 replicas.
- [X] Analyze their states by hand.
- [X] Create a Markov from the .xvg.

# Analysis and comparison of the clusters with USAlign
- [X] Download the C-$\alpha$_**0.15** clusters for all 3 x 3 replicas.
- [X] Open one of the file in PyMol. All states appear. Click on _File_ $\rightarrow$ _Extract structure_ $\rightarrow$ _Molecule_
- [X] Now choose the options:
  - [X] In _Multi-File_ click the **{name}-{state}** option. (You can deselect asking for each molecule. I don't use it, and do it as bunch.)
  - [X] In _PDB Options_ choose ✅ _write segment identifier_ and ✅ _retain atom IDs_. (VERY important to stay compatible with the GROMACS _.ndx_ files.)
  - [X] In _Generic Options_ choose to **keep rank as in the original structure**. (VERY important to not resort the atoms in an otherwise PyMol order, that would target wrong atoms when using GROMACS _.ndx_ files for analysis.)
  - [X] Then _Save_, create a new folder (e.g. _H2_) and put them there.
  - NOTE: I do this analysis on my local laptop, not on the Garching cluster.

## 1. On the cluster
- [X] Upload the folder with all structures to the cluster, I name the folder in _analysis/single-clusters_.
- [X] Unzip with `unzip single-clusters.zip`.
- [X] Move into the folder. Copy the _expanded....ndx_ files here.
- [X] Open a new Jupyter notebook. Run `!module load gromacs/2025.2` in a Jupyter cell. It runs this in the command line.
- [X] In the normal command line, calculate the SASAs (see the Jupyter notebook _2_ in this Repository).
- [X] Run the command: ``
  - NOTE: We need **LMNA**, **BAFs** and **LMNA+BAFs** to calculate the buried area as difference: $\Delta = \frac{1}{2}\cdot SASA_{LMNA} + SASA_{BAFs} - SASA_{complex}$. 
- [X] For BAF-BAF dimers, adjust the index file: Run in the command line `gmx make_ndx -f "../9J8M_R/raven_md_9J8M_R.tpr" -n "expanded_9J8M_R_DNA-protein.ndx" -o "expanded_9J8M_R_DNA-protein.ndx"`
  - [X] Type `a 23960-26735`.
  - [X] Type `name 40 BAF_dimer`.
  - [X] Save with `q`.
- [X] For LMNA-BAF-BAF tetramer, adjust the index file (similar to above).
  - [X] For **R** (WT) type `a 23960-28578`, then `name LMNA+BAFs`.
  - [X] For **Q/H** (mut.) type `a 23960-28571`, then `name LMNA+BAFs`. (Or `name BAF_LMNA_trimer`. See: The mutant amino acids have less atoms in total.)
- [X] Plot the surface area over the trajectories.

## 2. On single files
Now we want to get the values per uploaded cluster. We write a .sh script.
- [X] Include an iterative loop that creates from this simple command (see that we use 2x _.pdb_ files and no _.xtc_ file) `gmx sasa -f "R/R-ca-0.15-clusters_1.pdb" -s "R/R-ca-0.15-clusters_1.pdb" -n "expanded_9J8M_R_DNA-protein.ndx" -o "R/sasa_lamin_R-1.xvg" -surface 'group "LMNA+BAFs"'` a loop that runs for all folders in the command line.
- [X] Run `sh sasa.sh` in a directory which holds subfolders with all the clusters to analyze in once. NOTE: Generates _.xvg_ files.
- [X] Run a Juypter notebook that makes the analysis plots from the _.xvg_ files.


## Analyzing histones
- [X] We need to add **E63**, **S112** and the tail **LPK** to the index files.
- [X] We need to add the whole histone H4 + H3 as one cluster (tetramer).
- [X] We need to add the histones H2A + H2B as one cluster (2 x dimer).

