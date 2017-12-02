## Homework 4 - DTI

#### Review the data

* How many shells (different nominal b values) are there? What are the shell b values?

4 -- stuff around 0, stuff around 1000, stuff around 2000, and stuff around 3000.

* How many b0 volumes are there in each DWI sequence?

There are six. In the .bvec file, they are all of the 5's. These include the following indices: `0 16 32 48 64 80`

* Are the LR/RL phase encoding labels correct?

To find this out, we took a million steps.

##### Viewing the DWI data using the HPC

You have to use the x2go client. 

1) Follow the instructions [here](https://wiki.hpc.uconn.edu/index.php/X) to use x2go on the HPC. You have to [download x2go](https://code.x2go.org/releases/binary-macosx/x2goclient/releases/4.1.1.0/) to your local computer.  

2) Once you get the new terminal (should be white) using the x2go client, navigate to the data.  
`cd /scratch/birc_ro/ibrain_dwi/100206`

3) Load afni and relevant modules.  
`module load sqlite/3.18.0`  
`module load python/2.7.6`  
`module load r/3.1.1`  
`module load afni`

4) Run AFNI  
`afni`

Look at the images and use the direction of the distortion to see which direction the phase encoding happened.

Make sure you check for severe distortion (in this dataset, around slice 30) -- with less severe distortion, the pattern can look opposite!

##### Running the container interactively

1) Start bash interactively in the HPC: `srun --pty /bin/bash`

2) Edit your [batch](./batch_dtihw_gpu.sh) and [burc wrapper](./burc_wrapper_dtihw.sh) scripts.

3) Make your burc wrapper executable.  
`chmod 755 burc_wrapper_dtihw.sh`  

4) Run the batch script.  
`sh batch_dtihw_gpu.sh`

You should now be in the container interactively.

##### Preprocessing

1) Extract the b0 volumes from each DWI sequence and combine them into a single 4D NIFTI file.

Recall from looking at the .bvals file that the indices of the b0s are `0 16 32 48 64 80`. We'll grab each one separately and then merge them for LR and for RL using the [extractb0s.sh](./extractb0s.sh) script. Make sure to chmod it:
`chmod 755 extractb0s.sh`

We set up a different [batch script](./batch_extractb0s.sh) to run this extract script.

Navigate into the `scripts` directory and run `sbatch batch_extractb0s.sh`. Hopefully it will run!!