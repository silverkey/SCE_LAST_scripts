#!/usr/bin/perl
use strict;
use warnings;
use lib "$ENV{HOME}/src/bioperl-live";
use lib "$ENV{HOME}/src/bioperl-run/lib";
use Bio::Tools::Run::StandAloneBlastPlus;
use Data::Dumper;

$ENV{BLASTPLUSDIR} = "/Users/remo/src/ncbi-blast-2.2.25+/bin";

my $file1 = 'Ciona_intestinalis.JGI2.49.pep.all.fa';
my $file2 = 'Oikopleura_peptide_v1.0.fa';
my $folder = 'BRH_cio_oiko';

chdir($folder);
my $out1 = 'blast1';
my $out2 = 'blast2';
my $href1 = parse_blast_results($out1);
my $href2 = parse_blast_results($out2);

open(BRH,">BRH.txt") or die "\nERROR opening BRH file: $!\n\n";

foreach my $id1 (keys %$href1) {
  my $id2 = $href1->{$id1};
  next unless exists $href2->{$id2};
  print BRH "$id1\t$id2\n" if $href2->{$id2} eq $id1;
}

sub parse_blast_results {
  my $out = shift;
  my $out_table = "$out\.table";
  my $href = {};
  open(OUT,">$out_table") or die "\nERROR opening $out_table file: $!\n\n";
  print OUT join("\t",qw(clone hit description evalue coverage identity strand frame))."\n";

  my $in = new Bio::SearchIO(-format => 'blast', 
                             -file => $out);

  while(my $result = $in->next_result) {
    my $program = lc($result->algorithm);
    my $candidate = {};
    while(my $hit = $result->next_hit) {
      while(my $hsp = $hit->next_hsp) {
        my $strand = $hsp->strand;
        my $frame = $hsp->frame('query');
        my $identity = $hsp->percent_identity;
        my $coverage = $hsp->length('total') / $result->query_length * 100;
        if($program eq 'blastx') {
          $coverage = $hsp->length('total') / ($result->query_length / 3) * 100;
        }
        $coverage =~ s/^(\d+)\.\d+$/$1/;
        $identity =~ s/^(\d+)\.\d+$/$1/;

        # HARD CODED CUTOFFS!!!
        next unless ($coverage >= 25);

        if((! exists $candidate->{hsp}) || ($hsp->evalue < $candidate->{hsp}->evalue)) {
          $candidate = candidate_this($hit,$hsp,$coverage,$identity,$strand,$frame);
        }
      }
    }

    if(exists $candidate->{hsp}) {
    my $query = strip_id($result->query_name);
    my $accession = strip_id($candidate->{hit}->accession);
    $href->{$query} = $accession;
    print OUT $query ."\t".
              $accession ."\t".
              $candidate->{hit}->description ."\t".
              $candidate->{hsp}->evalue ."\t".
              $candidate->{coverage} ."\t".
              $candidate->{identity}, "\t".
              $candidate->{strand}."\t".
              $candidate->{frame}."\n";
    }
  }
  close(OUT);
  return $href;
}

sub candidate_this {
  my $candidate = {};
  $candidate->{hit} = shift;
  $candidate->{hsp} = shift;
  $candidate->{coverage} = shift;
  $candidate->{identity} = shift;
  $candidate->{strand} = shift;
  $candidate->{frame} = shift;
  return $candidate;
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
