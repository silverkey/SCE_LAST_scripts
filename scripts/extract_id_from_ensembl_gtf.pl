#!/usr/bin/perl
use strict;
use warnings;

my $file = "$ARGV[0]";
die "\n\tUSAGE: perl $0 [file.gtf]\n\n" unless -e $file;

open(IN,$file);
my $href = {};
print "tid\tgid\tpid\t\n";

while(my $row  = <IN>) {
  chomp($row);
  my @f = split(/\t/,$row);
  next unless $f[2] eq 'CDS';

  $f[8] =~ /gene_id \"(\S+)\"\;/;
  my $gene_id = $1;

  $f[8] =~ /transcript_id \"(\S+)\"\;/;
  my $transcript_id = $1;

  $f[8] =~ /protein_id \"(\S+)\"\;/;
  my $protein_id = $1;

  $href->{$transcript_id}->{gene} = $gene_id;
  $href->{$transcript_id}->{protein} = $protein_id;
}

foreach my $tid (keys %$href) {
  print join("\t",$tid,$href->{$tid}->{gene},$href->{$tid}->{protein});
  print "\n";
}
