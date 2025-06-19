export R_LIBS=/home/pls394/Software/R/library
module load gcc/11.2.0
module load R/4.2.2
module load R-packages
module load python/3.9.9
module load python-packages

mapDamage -i /maps/projects/seqafrica/scratch/mapping/cats/batch_1.mapping/Marozi.Pleo.bam  -r /maps/projects/seqafrica/data/Marozi_data_2024/Reference/lion/GCF_018350215.1/GCF_018350215.1_P.leo_Ple1_pat1.1_genomic.fna
