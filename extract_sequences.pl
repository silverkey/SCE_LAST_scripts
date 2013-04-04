#!/usr/bin/perl;
use strict;
use warnings;
use Data::Dumper;
use Bio::SeqIO;
use Bio::Seq;

my $genome = '/Users/remo/GENOMES/Takifugu_rubripes.FUGU4.49.dna_rm.toplevel.fa';
my $table = 'fugu_negrcne.txt';
my $outname = 'fugu_negrcne.fa';

my $seqio = Bio::SeqIO->new(-file => $genome,
                            -format => 'fasta');

my $out = Bio::SeqIO->new(-file => ">$outname",
                          -format => 'fasta');

open(IN,$table);
my $href = {};

while(my $row = <IN>) {
  chomp($row);
  my($id,$chr,$start,$end) = split(/\t/,$row);
  push(@{$href->{$chr}},$row);
}

while(my $seq = $seqio->next_seq) {
  my $chr = $seq->id;
  next unless exists $href->{$chr};
  foreach my $row(@{$href->{$chr}}) {
    my($id,$chr,$start,$end) = split(/\t/,$row);
    my $string = $seq->subseq($start,$end);
    my $new = Bio::Seq->new(-id => $id,
                             -seq => $string);
    $out->write_seq($new);
  }
}
