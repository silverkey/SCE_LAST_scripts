#!/usr/bin/perl
use strict;
use warnings;
use Parallel::ForkManager;

my $CUTOFF = 15;
my $GENOME = 'OIKO';
my $GENOME_FASTA = '/media/LOCAL_DATA_2/ANALYSIS/oCNEs/Z800_BLASTN/oiko/Odioica_reference_v3.0.fa';
my $OUTPUT = 'oCNEs_HMMER_OIKO';

my $pm = new Parallel::ForkManager(20);
$pm->run_on_finish(
  sub {
    my($pid,$exit_code) = @_;
    print "** Just got out of the pool ".
          "with PID $pid and exit code: $exit_code\n";
  }
);

my @models = glob('*.hmm');

foreach my $model(@models) {
  # Forks and returns the pid for the child:
  my $pid = $pm->start and next;

  # Here is the parallelized block
  # -----------
  scan_genome($model);
  # -----------

  # Terminates the child process
  $pm->finish;
}

open(OUT,">$OUTPUT");
print OUT "hmm_id\thmm_start\thmm_end\thit_id\thit_start\thit_end\tscore\tHMMconsensus\tmatchline\thit\torganism\n";

foreach my $model(@models) {
  $model =~ /^(.+)\.hmm$/;
  my $id = $1;
  my $hmmer_out = "$id\_hmmer\_$GENOME\.scan";
  parse_scan($id,$hmmer_out);
}

sub scan_genome {
  my $model = shift;
  $model =~ /^(.+)\.hmm$/;
  my $id = $1;
  my $hmmer_out = "$id\_hmmer\_$GENOME\.scan";
  my $command = "hmmfs -c -F $model $GENOME_FASTA > $hmmer_out";
  system($command) unless -e $hmmer_out;
}

sub parse_scan {
  my $id = shift;
  my $file = shift;
  open(IN,$file);
  my $start_point = 0;
  while(my $row = <IN>) {
    chomp($row);
    $start_point = 1 if $row =~ /^Score/;
    next unless $start_point;
    next unless $row =~ /^\d+/;
    my @field = split(/\s+/,$row);
    my @last = split(/\s+/,$field[5]);
    my $next1 = <IN>;
    my $HMMconsensus = <IN>;
    chomp($HMMconsensus);
    $HMMconsensus =~ s/^ +//g;
    $HMMconsensus =~ s/ +$//g;
    my $matchline = <IN>;
    chomp($matchline);
    $matchline =~ s/^ +//g;
    $matchline =~ s/ +$//g;
    my $hit = <IN>;
    chomp($hit);
    $hit =~ s/ +(.+) +(.+) +([ATCGN\-]+) +(.+)/$3/;
    $hit =~ s/^ +//g;
    $hit =~ s/ +$//g;
    my $empty = <IN>;
    if($field[0] >= $CUTOFF) {
      print OUT "$id\t$field[3]\t$field[4]\t$last[0]\t$field[1]\t$field[2]\t$field[0]\t$HMMconsensus\t$matchline\t$hit\t$GENOME\n"; # FILTRO SULLO SCORE
    }
  }
}
