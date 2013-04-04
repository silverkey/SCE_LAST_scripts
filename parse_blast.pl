#!/usr/bin/perl
use strict;
use warnings;

use Bio::SearchIO;
use Bio::AlignIO;

my $length_cutoff = 30;
my $percent_cutoff = 60;
my $coverage_cutoff = 85;

my $file = $ARGV[0];

open(OUT,">SUMMARY.txt");
print OUT "query\thit\thstart\thend\tlength\tidentity\tcoverage\n";

my $output = Bio::SearchIO->new(-file => $file,
                                -format => 'blast');

while(my $result = $output->next_result) {

  print "\n\nGot a RESULT for query: ".$result->query_name.
        " of length ".$result->query_length.
        " against the database: ".$result->database_name.
        "\n\n\n";

  while(my $hit = $result->next_hit) {

    print "\tHIT: ".$hit->accession.
          "\tnumber of hsps: ".$hit->num_hsps.
          "\n";

    while(my $hsp = $hit->next_hsp) {

      print "\t\tHSP identity: ".$hsp->percent_identity.
            " over a length of ".$hsp->length.
            " bases \n";

      my $coverage = $hsp->length('total') / $result->query_length * 100;

      if($hsp->length >= $length_cutoff) {

        if($hsp->percent_identity >= $percent_cutoff) {

          if($coverage >= $coverage_cutoff) {

            my $aln = $hsp->get_aln;
 
            my $hit_accession = $hit->accession;

            my $alnio = Bio::AlignIO->new(-file => ">$hit_accession",
                                          -format => 'clustalw');
          
            $alnio->write_aln($aln);
          
            print OUT join("\t",$result->query_name,$hit->accession,$hsp->hstart,$hsp->hend,$hsp->length,$hsp->percent_identity,$coverage)."\n";
          }
        }
      }
    }
    print "\n";
  }
}

print "\n\n";

