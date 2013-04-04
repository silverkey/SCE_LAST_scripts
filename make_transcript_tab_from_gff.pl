#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

die "\nperl $0 [gff2 file]\n\n" unless scalar(@ARGV) == 1;
die "\nperl $0 [gff2 file]\n\n" unless -e $ARGV[0];
die "\nInput file must have the .gff extension!\n\n" unless $ARGV[0] =~ /\.gff$/;

my $file = $ARGV[0];
my $out = "$file";
$out =~ s/\.gff$/\.tab/;

open(IN,$file);
open(OUT,">$out");

my $tr = {};
my $seen = {};
my $previous = 'NA';

while(my $row = <IN>) {
  chomp($row);
  my @field = split(/\t/,$row);
  next unless $field[2] eq 'exon';
  my $tid = get_tid($field[8]);
  if($previous ne $tid) {
    if(exists $seen->{$tid}) {
      print "Problems: $tid seen multiple times\n";
    }
    $seen->{$tid} ++;
    $previous = $tid;
  }
  push(@{$tr->{$tid}->{coord}},$field[3]);
  push(@{$tr->{$tid}->{coord}},$field[4]);
  $tr->{$tid}->{chr} = $field[0];
  $tr->{$tid}->{str} = $field[6];
}

foreach my $tid(keys %$tr) {
  my @coord = @{$tr->{$tid}->{coord}};
  my @sorted = sort {$a <=> $b} @coord;
  $tr->{$tid}->{min} = $sorted[0];
  $tr->{$tid}->{max} = $sorted[$#sorted];
}

foreach my $tid(keys %$tr) {
  print OUT join("\t",$tid,$tr->{$tid}->{chr},$tr->{$tid}->{min},$tr->{$tid}->{max},$tr->{$tid}->{str})."\n";
}

sub get_tid {
  my $col = shift;
  my $tid = 'NA';
  if($col =~ /transcriptId (\d+)\;?$/) {
    $tid = $1;
  }
  return $tid;
}
