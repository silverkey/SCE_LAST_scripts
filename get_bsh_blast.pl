#!/usr/bin/perl
use strict;
use warnings;
use Bio::SearchIO;

my $out = 'mouse_ocne_vs_ebseq.blout';

open(BSH,">BSH.txt");
print BSH join("\t",qw(clone hit evalue coverage identity strand frame))."\n";

my $in = new Bio::SearchIO(-format => 'blast', 
                           -file => $out);

while(my $result = $in->next_result) {
  my $program = lc($result->algorithm);
  my $mine = 10;

  while(my $hit = $result->next_hit) {

    while(my $hsp = $hit->next_hsp) {

      my $strand = $hsp->strand;
      my $frame = $hsp->frame('query');
      my $identity = $hsp->percent_identity;
      my $coverage = $hsp->length('total') / $result->query_length * 100;
      my $evalue = $hsp->evalue;
      if($program eq 'blastx') {
        $coverage = $hsp->length('total') / ($result->query_length / 3) * 100;
      }
      $coverage =~ s/^(\d+)\.\d+$/$1/;
      $identity =~ s/^(\d+)\.\d+$/$1/;

      if($evalue <= $mine) {   
        my $query = strip_id($result->query_name);
        my $accession = strip_id($hit->accession);

        print BSH $query ."\t".
                  $accession ."\t".
                  $evalue ."\t".
                  $coverage ."\t".
                  $identity, "\t".
                  $strand."\t".
                  $frame."\n";

        $mine = $evalue;
      }
    }
  }
}

sub strip_id {
  my $id = shift;
  my ($acc, $version);
  if ($id =~ /(gb|emb|dbj|sp|tr|pdb|bbs|ref|lcl|tpg)\|(.*)\|(.*)/) {
    ($acc, $version) = split /\./, $2;   
  }
  elsif ($id =~ /(pir|prf|pat|gnl)\|(.*)\|(.*)/) {
    ($acc, $version) = split /\./, $3;
  }
  elsif ($id =~ /^jgi\|/) {
    my @f = split(/\|/,$id);
    $acc = $f[2];
  }
  return $acc if $acc;
  return $id;
}

