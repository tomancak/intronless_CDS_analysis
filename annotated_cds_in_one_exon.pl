#!/usr/bin/perl -w

use strict;

my $file = $ARGV[0];

open IN, "./".$file;

my $results;
my %mRNAs;
my $counter = 0;

$| = 1;

# pull relevant data from gff file

print "Analysing GFF file....\n";

while (<IN>) {
  my @temp = split /\t/, $_;
  my $beg = $temp[3];
  my $end = $temp[4];
  my $strand = $temp[6];
  my $desc = $temp[8];
        
# collect flybase gene id (FBgn) for each mRNA
  if ($_ =~ /\tmRNA\t/) {
	$desc =~ /.*Parent\=(FBgn\d+).*\;/;
	my $gene = $1;
	$desc =~ /ID\=(FBtr\d+).*\;/;
	my $transcript = $1;
	$mRNAs{$transcript} = $gene;
	$counter++;
  }

# collect transcript ID (FBtr), beg and end for each protein
  if ($_ =~ /\tprotein\t/) {
	  $desc =~ /.*Derives_from\=(FBtr\d+).*\;/;
  	  my $transcript = $1;
  	  next if (!$transcript);
          $results->{$transcript}->{'protein'}->{$beg."_".$end} = 1;
  }

# collect transcript ID (FBtr), beg and end for each exon
  if ($_ =~ /\texon\t/) {
	 $desc =~ /^Parent=(FBtr\d+)/;
          my $transcript = $1;
          next if (!$transcript);
          $results->{$transcript}->{'exon'}->{$beg."_".$end} = 1;
  }
  # progress bar
  if ($counter == 1000) { print "."; $counter = 0; }
}
print "\n";


close(IN);

# analyse the collected data

my $counter;
my %unique;

#header
print "number\tFBgn\tcategory\tCDS_beg\texon_beg\tCDS_end\texon_end\n";

#iterates transcripts
foreach my $transcript (keys %{$results}) {

#iterates CDS
  foreach ( keys %{$results->{$transcript}->{'protein'}} ) {
	my @cds_ends = split "_", $_;
	# iterate exons
	foreach ( keys %{$results->{$transcript}->{'exon'}} ) {
		my @exon_ends = split "_", $_;

		# select cases where exon is bigger than CDS
		if ($cds_ends[0] >= $exon_ends[0] && $cds_ends[1] <= $exon_ends[1]) {
			next if (exists $unique{$mRNAs{$transcript}});
			$counter++;
    			print $counter."\t".$mRNAs{$transcript}."\tsingle exon protein ".$cds_ends[0]." ".$exon_ends[0]." ".$cds_ends[1]." ".$exon_ends[1]."\n";
    			#print OUT $for_gff->{$_};
			$unique{$mRNAs{$transcript}} = 1;
		}
	}
  }
}

exit;
