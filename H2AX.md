# Create index files

- Per each folder create a new index file: `gmx make_ndx -f em/em_Q.tpr -o H2AX_Q.ndx` (use `-n H2AX_Q.ndx` if an index file already exists)
  - Add _protein or DNA set_: Type `1 | 12` then `q` and enter to save as _Group 20_

- Use the file to group: `echo 20 | gmx trjconv -s em/em_Q.tpr -f npt_Q.trr -o npt_Q-whole.trr -pbc whole -n H2AX_Q.ndx`
- Use the file to cluster: `echo 20 20 | gmx trjconv -s em/em_Q.tpr -f npt_Q-whole.trr -o npt_Q-cluster.trr -pbc cluster -n H2AX_Q.ndx`
- Use first frame as reference: `echo 20 | gmx trjconv -s em/em_Q.tpr -f npt_Q-cluster.trr -o H2AX_Q_frame0.pdb -dump 0 -n H2AX_Q.ndx`
- Use last frame for plotting: `echo 20 | gmx trjconv -s em/em_Q.tpr -f npt_Q-cluster.trr -o H2AX_Q_last-frame.pdb -dump 500 -n H2AX_Q.ndx`
