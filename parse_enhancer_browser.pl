#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
use Bio::Seq;

my $infa = 'enhancer_browser_14_11_2012.fa';
my $outfa = 'ebseq.fa';
my $table = 'ebtab.xls';

my $in = Bio::SeqIO->new(-file => $infa,
                         -format => 'fasta');

my $out = Bio::SeqIO->new(-file => ">$outfa",
                          -format => 'fasta');

open(OUT,">ebtab.xls");

while(my $seq = $in->next_seq) {
  my $string = $seq->id.$seq->desc;
  $string =~ s/ //g;
  my @field = split(/\|/,$string);
  my $org = shift(@field);
  my $loc = shift(@field);
  my $id = shift(@field);
  while(my $res = shift(@field)) {
    $res =~ s/\[.+\]//g;
    print OUT join("\t",$id,$res)."\n";
  }
  $seq->id($id);
  $seq->desc(0);
  $out->write_seq($seq);
}
