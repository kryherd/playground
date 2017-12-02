for dir in LR RL
do
	fslroi /bind/data_in/100206_3T_DWI_dir95_${dir}.nii.gz /bind/data_out/100206_3T_DWI_dir95_${dir}_cut.nii.gz 0 -1 0 -1 0 110 0 -1
	for index in 0 16 32 48 64 80
	do
		# make sure you have the /bind/ path so that you can get at the data when you're in the container.
		fslroi /bind/data_out/100206_3T_DWI_dir95_${dir}_cut.nii.gz /bind/data_out/b0_${dir}_${index}.nii.gz ${index} 1
	done
	fslmerge -t /bind/data_out/b0_${dir}_all /bind/data_out/b0_${dir}_*.nii.gz
done
fslmerge -t /bind/data_out/b0_all /bind/data_out/b0_*_all.nii.gz