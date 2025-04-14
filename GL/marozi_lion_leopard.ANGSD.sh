#!/bin/bash

ANGSD=~/Software/angsd/angsd
NGSADMIX=~/Software/NGSadmix/NGSadmix
bamlist=/maps/projects/seqafrica/people/pls394/marozi/cats.excldNebulosa_map2Pleo.bamlist
out=lion_leopard
chrlist=/maps/projects/seqafrica/people/pls394/marozi/site_filters/good_auto_exclRep_exclDepth.chr
site=/maps/projects/seqafrica/people/pls394/marozi/site_filters/good_auto_exclRep_exclDepth.sites

$ANGSD  -bam $bamlist -minMapQ 30 -minQ 30 -GL 2  -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -minInd 20  -minMaf 0.05 -doGlf 2  -P 5 -rf $chrlist -sites $site -out $out
