# intronless_CDS_analysis
This repository contains perl script and GFF files used to identify gene in the Drosophila genome that do not contain introns in their protein coding sequence

Pre-requisites:
You need bare bones Perl. All the script does is simple text parsing, no fancy modules are needed.
An up-to-date .gff file containing genome annotations respecting established GFF conventions

Usage:
On the command line type:

> ./annotated_cds_in_one_exon.pl dmel-all-no-analysis-r6.07.gff

press enter.

Output:
While procesing the file the script will print:

> ./annotated_cds_in_one_exon.pl dmel-all-no-analysis-r6.07.gff

Analysing GFF file....

..............................

and then the list of genes that DO NOT have an intron in the exon that contains a CDS, or in other words the entire CDS is in one exon

number	FBgn	category	CDS_beg	exon_beg	CDS_end	exon_end

1	FBgn0038839	single exon protein 20896453 20895745 20897136 20897320

2	FBgn0034899	single exon protein 23747599 23747560 23748141 23748218

.

.

.

3016	FBgn0034307	single exon protein 18158296 18158257 18160167 18160310

3017	FBgn0032533	single exon protein 13812728 13812700 13813234 13813256

i.e. the result for Drosophila is 3017 genes cannot be tagged by inserting a GFP exon cassette into their CDS. 

