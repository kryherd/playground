#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=kayleigh.ryherd@uconn.edu	# Your email address
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --ntasks=1					# Run a single serial task
#SBATCH -e error_%A_%a.log                      # Standard error
#SBATCH -o output_%A_%a.log                     # Standard output

export OMP_NUM_THREADS=8			#<= cpus-per-task
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8	#<= cpus-per-task
##### END OF JOB DEFINITION  #####

#Define user paths
NETID=$USER
PROJECT=dwi_hw

export DIR_BASE=/scratch/${NETID}/${PROJECT}
export DIR_RESOURCES=${DIR_BASE}/resources 	#ro
export DIR_DATA=${DIR_BASE}/data 				#rw data
export DIR_DATAIN=/scratch/birc_ro/ibrain_dwi/100206/			#ro data
export DIR_DATAOUT=${DIR_BASE}/data_out		#rw data
export SUBJECTS_DIR=${DIR_BASE}/freesurfer		#rw for Freesurfer
export DIR_WORK=/work							#rw /work on HPC is 40Gb local storage
export DIR_SCRATCH=${DIR_BASE}/scratch 		#rw shared storage
export DIR_SCRIPTS=${DIR_BASE}/scripts 		#ro, prepended to PATH


# Load modules
module load cuda/8.0.61 					#for GPU/CUDA
module load matlab/2017a				#matlab binaries are bound
module load singularity/2.3.1-gcc		#required to run the container

#set the matlab license path to the path inside the container
export LM_LICENSE_FILE=/bind/matlablicense/uits.lic

#finally call the container with any arguments for the job
#wrapper will bind the appropriate paths
#environment variables are passed to the container

# /bind/ path helps you use the script within the container
./burc_wrapper_dtihw.sh /bind/scripts/extractb0s.sh