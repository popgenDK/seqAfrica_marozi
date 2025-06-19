#!/bin/bash


### use 2021 genoe
# it is very important to use rna.fa as cds.fa
# because it requries transcript.id
# see https://github.com/pcingola/SnpEff/issues/417

## Step1: build dataset
DBNAME=GCF_018350215.1
java -Xmx40g -jar snpEff.jar build  -gtf22 -v $DBNAME

bcftools view /maps/projects/seqafrica/people/pls394/marozi/GT_GCF_018350215/results/Bigcat/vcf/Pleo_Bigcat_variable_sites_nomultiallelics_noindels.bcf.gz > Pleo_Bigcat_variable_sites_nomultiallelics_noindels.vcf

## Step2: annotate
java -Xmx40g -jar snpEff.jar ann  -v $DBNAME  Pleo_Bigcat_variable_sites_nomultiallelics_noindels.vcf > Pleo_Bigcat_variable_sites_nomultiallelics_noindels.ann.vcf
bcftools view -Ob -o Pleo_Bigcat_variable_sites_nomultiallelics_noindels.ann.bcf.gz Pleo_Bigcat_variable_sites_nomultiallelics_noindels.ann.vcf

## Step3: extract relevant genes
perl extract_SNP_gene.v3.pl ../Pleo_Bigcat_variable_sites_nomultiallelics_noindels.ann.bcf.gz  ../data/GCF_018350215.1/genes.gtf extra.gene.list
