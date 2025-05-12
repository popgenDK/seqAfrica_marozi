#!/bin/bash

ANGSD=~/Software/angsd/angsd
bamlist=/maps/projects/seqafrica/people/pls394/marozi/cats_map2Pleo.bamlist
chrlist=/maps/projects/seqafrica/people/pls394/marozi/site_filters/good_auto_exclRep_exclDepth.chr
sites=/maps/projects/seqafrica/people/pls394/marozi/site_filters/good_auto_exclRep_exclDepth.sites

## generate IBS matrix
$ANGSD  -bam $bamlist -minMapQ 30 -minQ 30 -GL 2  -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -doIBS 1 -doCounts 1 -doCov 1 -makeMatrix 1 -minMaf 0.05 -P 5 -rf $chrlist -sites $sites 

## get the only transversion
zcat angsdput.ibs.gz | awk -F '\t' '!( ($3 == "A" && $4 == "G") || ($3 == "G" && $4 == "A") || ($3 == "C" && $4 == "T") || ($3 == "T" && $4 == "C") )'  >  angsdput.transversion.ibs
