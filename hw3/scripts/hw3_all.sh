#!/bin/bash 
##### PART ONE
cd ~/playground/hw3/
# Create group mask

3dmask_tool \
-input export/masks/full_mask.sub-??+tlrc.HEAD \
-frac 1.0 \
-prefix GroupMask

cp GroupMask+tlrc* ./export/masks/
rm GroupMask+tlrc*

# Conduct 1-sample t-test: Words > Fixation is greater than zero

mkdir ./export/group_results

3dttest++ -mask ./export/masks/GroupMask+tlrc \
-prefix words \
-setA ./export/betas/stats.sub-??_REML+tlrc.HEAD'[Words#0_Coef]'

cp words+tlrc* ./export/group_results/
rm words+tlrc*

##### PART TWO 

parentdir=~/playground/hw3/export
cd ${parentdir}/blurs/
# Estimate smoothness
#extract the relevant row
for f in blur*.1D
	do
	1d_tool.py -infile $f -select_rows 5 -write ->> blurs.acf.1D
done

#average the estimates
blurs=`1dsum -mean blurs.acf.1D`

# create variables for the blur so we can use them in 3dClustSim
blur1=`echo $blurs | awk '{print $1}'`
blur2=`echo $blurs | awk '{print $2}'`
blur3=`echo $blurs | awk '{print $3}'`

# Apply cluster correction
cd ${parentdir}/group_results/

# figure out cluster size
3dClustSim \
-mask ${parentdir}/masks/GroupMask+tlrc \
-acf $blur1 $blur2 $blur3 \
-both \
-pthr .001 \
-athr .05 \
-iter 2000 \
-prefix clust_words \
-cmd refit.cmd

# make a copy of the dataset so I can view it in AFNI
3dcopy words+tlrc words_forafni+tlrc
# add the cluster simulations to the header file
`cat refit.cmd` words+tlrc

cd ${parentdir}/group_results/

# mask & z-score
3dcalc -a words+tlrc \
-b ${parentdir}/masks/GroupMask+tlrc \
-expr 'a*b' \
-prefix words_masked

3dmerge -1zscore -prefix words_z words_masked+tlrc'[1]'

# apply cluster size, save sig. clusters to a table
3dclust -1Dformat -nosum \
-prefix words_z_clust \
-savemask cluster_mask \
-inmask \
-1noneg \
-1clip 3 \
-dxyz=1 \
1.74 21 \
words_z+tlrc >> ClustTable.1D

#make new empty file
touch ClustTableResults.1D

#create header
echo "Volume Max_Int(Z) X(MNI) Y(MNI) Z(MNI)" >> ClustTableResults.1D

# from the original table, take relevant columns and append them to the ClustTableResults document
while read line; do 
	clust=`echo "$line" | awk '{print $1 " " $13 " " $14 " " $15 " " $16}'`
	echo $clust >> ClustTableResults.1D
done << IN
`cat ClustTable.1D | tail -n +13`
IN

cd ${parentdir}/group_results/
sed 's/[:blank:]+/,/g' ${parentdir}/group_results/ClustTableResults.1D > ${parentdir}/group_results/ClustTableResults.tsv

##### PART THREE
parentdir=~/playground/hw3/export
cd ${parentdir}/group_results/

3dFDR -input words_masked+tlrc'[1]' -mask ${parentdir}/masks/GroupMask+tlrc -prefix words_FDR
3dclust -1Dformat -nosum -prefix words_FDR_clust -savemask cluster_maskFDR -inmask -1noneg -1clip 3 -dxyz=1 1.74 1 words_FDR+tlrc > FDRTable.1D

#make new empty file
touch FDRTableResults.1D

#create header
echo "Volume Max_Int(Z) X(MNI) Y(MNI) Z(MNI)" >> FDRTableResults.1D

# from the original table, take relevant columns and append them to the ClustTableResults document
while read line; do 
	clust=`echo "$line" | awk '{print $1 " " $13 " " $14 " " $15 " " $16}'`
	echo $clust >> FDRTableResults.1D
done << IN
`cat FDRTable.1D | tail -n +13`
IN

cd ${parentdir}/group_results/
sed 's/[:blank:]+/,/g' ${parentdir}/group_results/FDRTableResults.1D > ${parentdir}/group_results/FDRTableResults.tsv

##### PART FOUR

parentdir=~/playground/hw3
cd $parentdir
mkdir outputs

cp ${parentdir}/export/group_results/ClustTableResults.tsv ${parentdir}/outputs
cp ${parentdir}/export/group_results/FDRTableResults.tsv ${parentdir}/outputs

cd ${parentdir}/export/group_results/
3dAttribute -all words+tlrc > 3dAttributeResults.txt
cp ${parentdir}/export/group_results/3dAttributeResults.txt ${parentdir}/outputs



