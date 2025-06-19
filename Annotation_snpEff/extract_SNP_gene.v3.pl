#!/usr/bin/perl

use strict;
use warnings;


my $vcf = shift;
my $gff = shift;
my $gene_file = shift;

open my $fh, "<$gene_file" or die $!;
my @genes;
while (<$fh>) {
    chomp;
    push(@genes, $_);
}
close $fh;

@genes = &uniq(@genes);


foreach my $gene (@genes) {
    print "Process $gene\n";
    my $outfile1 = $gene . ".gft" ;
    my $outfile2 = $gene . ".tsv.temp" ;
    my $outfile3 = $gene . ".tsv";
    #cat data/GCF_018350215.1/genes.gtf  | grep -P '"AKAP11"'
    my $search = "\"" . $gene . "\";";
    print "$search\n";
    system ("cat $gff | grep —ignore-case -P '$search' > $outfile1");

    # go through each line in gff file and extract snps to a temp file
    open (my $fh1, "<$outfile1") or next;
    while (<$fh1>) {
	chomp;
	my @row = split;
	(my $chr, my $start, my $end) = @row[(0,3,4)];
	my $region = $chr . ":" . $start . "-" . $end;
	print "$gene:    $region\n";
	# bcftools query -f '%CHROM\t%POS\t%INFO[\t%GT:%DP]\n' snpeff.2.bcf.gz -r 
	system ("bcftools query -f '%CHROM\t%POS\t%INFO[\t%GT:%DP]\n' $vcf -r $region >> $outfile2") ;
    }
    close $fh1;

    open (my $fh2, "<$outfile2") or die $!;
    my @lists;
    while (<$fh2>) {
	chomp;
	my @row = split;
	my $ref_row = \@row;
	push @lists, $ref_row;
    }
    close $fh2;
    #my @uniq_lists = &uniq(@lists);
    my @uniq_lists = do {
	my %seen;
	#grep { not $seen{ $_->[ 0 ] } ++ } @lists;
	grep { not $seen{ join (".",@{$_}) } ++ } @lists;
    };
    
    open (my $fh3, ">$outfile3") or die $!;
    foreach my $list (sort { &number_strip($a->[0]) <=> &number_strip($b->[0]) or $a->[1] <=> $b->[1] } @uniq_lists) {
	print $fh3 join ("\t", @{$list}), "\n";
    }
    close $fh3;
}
    
    
sub uniq (@) {
    my %seen = ();
    grep { not $seen{$_}++ } @_;
}


sub number_strip {
    my $line = shift;
    my ($num) = $line =~ /(\d+)/;
    return $num;
}
