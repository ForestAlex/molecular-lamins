#!/bin/bash -l

proteins=("R" "R2" "R3" "Q" "Q2" "Q3" "H" "H2" "H3")

for protein in "${proteins[@]}"; do

    cd "${protein}"
    
    variant="${protein:0:1}"

    for structure in *.pdb; do
        #get the number of the cluster, % splits off suffix, _ splits off prefix
        number="${structure%.pdb}"
        number="${number##*_}"

        echo $structure
        echo $number
        
        #now run GROMACS
        gmx sasa -f "$structure" -s "$structure" -n "../expanded_9J8M_${variant}_DNA-protein.ndx" -o "sasa_LMNA_BAFs_${protein}-${number}.xvg" -surface 'group "BAF_LMNA_trimer"'

    done

    cd ..
    
done
