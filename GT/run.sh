module load snakemake/7.18.1
module load gcc/11.2.0
module load R/4.2.2
module load R-packages
module load /projects/scarball/apps/Modules/modulefiles/bcftools/1.16

#syntax of output should be  results_dir/dir/vcf/{Ref}_{ingroup}_variable_sites..

snakemake results/giraffe/vcf/RothschildsGiraffe_GCam_variable_sites_nomultiallelics_noindels.bcf.gz --configfile ./configs/giraffe.yaml  -j 140

snakemake results/giraffe/vcf/RothschildsGiraffe_GCam_variable_sites_nomultiallelics_noindels_10dp_2het.bcf.gz --configfile ./configs/giraffe.yaml  -j 10

snakemake results/giraffe/vcf/RothschildsGiraffe_GCam_variable_sites_mergeOJoh_nomultiallelics_noindels_10dp_2het.bcf.gz --configfile ./configs/giraffe.yaml  -j 100

snakemake results/Bigcat/vcf/Pleo_Bigcat_variable_sites_nomultiallelics_noindels_6dp_2het.bcf.gz --configfile ./configs/bigcats.yaml -j 100
