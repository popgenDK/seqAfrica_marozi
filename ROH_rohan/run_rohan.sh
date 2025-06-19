# Generating deamination profile on five different levels of -minq and 6 different levels of -length

parallel -j 12 --joblog bam2prof_4q_3length.log --tmpdir . "~/bin/rohan/bam2prof/bam2prof -minq {1} -length {2} -5p Marozi_5p_q{1}l{2}.txt -3p Marozi_3p_q{1}l{2}.txt Marozi.Pleo.bam" ::: $(seq 0 10 40) ::: $(seq 5 2 15) &

# Plotting bam2prof results to see where the deamination rate levels off across the length (see read_bam2prof_for_difftest.R)

# Using the deamination profile at -minq 20 -length 20 for Marozi
~/bin/rohan/bin/rohan --rohmu 2e-5 --map all_keep.rmRep.bed --size 2000000 --auto GCF_018350215.1_P.leo_Ple1_pat1.1_autosome.txt --deam5p bam2prof_results/Marozi_5p_q20l15.txt --deam3p bam2prof_results/Marozi_3p_q20l15.txt -t 18 -o Marozi_2e-5_2Mwin_autosome_q20l15 GCF_018350215.1_P.leo_Ple1_pat1.1_genomic.fna Marozi.Pleo.bam 2> Marozi2_2e-5_q20l15_2Mwin_rohan.log &
# excluding transitions
~/bin/rohan/bin/rohan --rohmu 2e-5 —-tvonly --map all_keep.rmRep.bed --size 2000000 --auto GCF_018350215.1_P.leo_Ple1_pat1.1_autosome.txt --deam5p bam2prof_results/Marozi_5p_q20l15.txt --deam3p bam2prof_results/Marozi_3p_q20l15.txt -t 18 -o Marozi_2e-5_2Mwin_autosome_q20l15_tvOnly GCF_018350215.1_P.leo_Ple1_pat1.1_genomic.fna Marozi.Pleo.bam 2> Marozi2_2e-5_q20l15_2Mwin_rohan.log &

# The modern genomes of Felidae
parallel --joblog cats_rohan_2Mbp.log -j 8 "~/bin/rohan/bin/rohan --rohmu 2e-5 --map all_keep.rmRep.bed --size 2000000 --auto GCF_018350215.1_P.leo_Ple1_pat1.1_autosome.txt -t 8 -o {.}_2e-5_2Mwin_autosome GCF_018350215.1_P.leo_Ple1_pat1.1_genomic.fna {} 2> {.}_2e-5_2Mwin_rohan.log &" ::: $(ls ?_*.bam)
# excluding transitions for proper comparison
parallel --joblog cats_rohan_2Mbp.log -j 8 "~/bin/rohan/bin/rohan --rohmu 2e-5 --map all_keep.rmRep.bed --size 2000000 --auto GCF_018350215.1_P.leo_Ple1_pat1.1_autosome.txt -t 8 -o {.}_2e-5_2Mwin_autosome GCF_018350215.1_P.leo_Ple1_pat1.1_genomic.fna {} 2> {.}_2e-5_2Mwin_rohan.log &" ::: $(ls ?_*.bam)
