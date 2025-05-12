#!/bin/bash

ANGSD=~/Software/angsd/angsd
NGSADMIX=~/Software/NGSadmix/NGSadmix

## generate GL
bamlist=/maps/projects/seqafrica/people/pls394/marozi/cats.excldNebulosa_map2Pleo.bamlist
out=lion_leopard
chrlist=/maps/projects/seqafrica/people/pls394/marozi/site_filters/good_auto_exclRep_exclDepth.chr
site=/maps/projects/seqafrica/people/pls394/marozi/site_filters/good_auto_exclRep_exclDepth.sites
$ANGSD  -bam $bamlist -minMapQ 30 -minQ 30 -GL 2  -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -minInd 20  -minMaf 0.05 -doGlf 2  -P 5 -rf $chrlist -sites $site -out $out

## get only transversion
zcat lion_leopard.beagle.gz | awk -F '\t' '!( ($2 == "0" && $3 == "2") || ($2 == "2" && $3 == "0") || ($2 == "1" && $3 == "3") || ($2 == "3" && $3 == "1") )'    > lion_leopard.transversion.beagle
gzip lion_leopard.transversion.beagle

## run ngsadmix
K=2
for i in {1..20}
do
    echo $i >> ${K}.log
    $NGSADMIX -likes lion_leopard.transversion.beagle.gz  -K ${K} -P 20 -maxiter 5000 -minMaf 0.05  -o K${K}.round.$i &>> ${K}.log
    echo >> ${K}.log
done
