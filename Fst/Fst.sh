
## calculate 2d-SFS
snakemake -s saf.snakemake --cores 80
snakemake -s 2dSFS.snakemake --cores 80

## calculate Fst based on 2d-SFS
cd /projects/seqafrica/people/pls394/marozi/SFS/results/2dsfs
for i in *.txt;
do
    pair=${i%.txt}; python3 ~/Software/asfsp/asfsp.py --input $i  --dim 2,2 --calc fst | tail -n1 | cut -d":" -f2 > ${pair}.fst;
done
