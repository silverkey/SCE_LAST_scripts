#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use Bio::AlignIO;

my $usage = "\n\tperl $0 [db] [usr] [pwd] [host]\n\n";
die $usage if scalar(@ARGV) != 4;

my $DBH = DBI->connect("dbi:mysql:$ARGV[0]:$ARGV[3]",$ARGV[1],$ARGV[2],{PrintError => 1, RaiseError => 1});

my $sth = $DBH->prepare('SELECT * FROM sce_aln');

$sth->execute;

while(my $row = $sth->fetchrow_hashref) {
  my $ID = $row->{'feature_pair_id'};
	my $filename = "$ID\.msf";
  my $aln_string = $row->{'aln'};
  open(MEMORY,'<', \$aln_string);
  my $fh = Bio::AlignIO->new(-format => 'clustalw',
                             -fh => \*MEMORY);
  my $aln = $fh->next_aln;
	my $outIO = Bio::AlignIO->new(-file => ">$filename",
																-format => 'msf');
	$outIO->write_aln($aln);
	close(MEMORY);
	$outIO->close;

  system("hmmb -d $ID\.hmm $filename");
}
