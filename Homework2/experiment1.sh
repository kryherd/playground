#Step 1 - threshold the stats at p <.05
cd /Users/Kayleigh/Dropbox/IBRAIN/Homework2/subject_results/group.test_group/subj.sub_03/Exp1/sub_03.results
3dmerge -1zscore -1thresh 1.96 -1noneg -prefix stat.threshexp1 'stats.sub_03+tlrc[17]'
cd /Users/Kayleigh/Dropbox/IBRAIN/Homework2/subject_results/group.retest_group/subj.sub_03/Exp1/sub_03.results
3dmerge -1zscore -1thresh 1.96 -1noneg -prefix stat.threshexp1 'stats.sub_03+tlrc[17]'

#Step 2 - create mask
cd /Users/Kayleigh/Dropbox/IBRAIN/Homework2/subject_results/
3dmask_tool -input group.*/subj.sub_03/Exp1/sub_03.results/mask_group+tlrc.HEAD -frac 1.0 -prefix mask

#Step 3 - Binarize the images
cd /Users/Kayleigh/Dropbox/IBRAIN/Homework2/subject_results/
3dcalc -a group.test_group/subj.sub_03/Exp1/sub_03.results/stat.threshexp1+tlrc -prefix stat.test.binexp1 -expr 'astep(a,.1)'
3dcalc -a group.retest_group/subj.sub_03/Exp1/sub_03.results/stat.threshexp1+tlrc -prefix stat.retest.binexp1 -expr 'astep(a,.1)'

#Step 4 - calculate Dice coefficient
3ddot -mask mask+tlrc -dodice stat.test.binexp1+tlrc stat.retest.binexp1+tlrc