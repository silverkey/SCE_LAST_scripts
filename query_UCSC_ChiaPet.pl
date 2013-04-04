#!/usr/bin/perl;
use strict;
use warnings;
use DBI;
use Data::Dumper;

my $db = 'hg19';
my $host = 'genome-mysql.cse.ucsc.edu';
my $user = 'genome';
my $password = '';

my $bed = 'oCNEs_hg19.txt';
open(OUT,">$bed\_ucsc_overlap");
print OUT "type\tid\tchr\tstart\tend\tsample\toverlap\tintra\tchr1\tstart1\tend1\tchr2\tstart2\tend2\n";
open(TAB,">UCSC_tables_counts");

my $dbh = DBI->connect("DBI:mysql:database=$db;host=$host",
                       $user,$password, {RaiseError => 1});

my $data = get_tables_like('%ChiaPet%InteractionsRep%');
my $coord = get_coord_from_bed($bed);
my $tag;

my $data_ref = count_rows_in_tables($data);
close(TAB);

foreach my $id(keys %$coord){
  my $chr = $coord->{$id}->{chr};
  my $start = $coord->{$id}->{start};
  my $end = $coord->{$id}->{end};

  $tag = 'chiapet';
  foreach my $row(@$data) {
    foreach my $tab(@$row) {
      print "Analyzing $id in table $tab\n";
      my $ov = get_overlapping($id,$chr,$start,$end,$tab,$tag,$data_ref);
    }
  }
}

close(OUT);

sub count_rows_in_tables {
  my $tabs = shift;
  my $href = {};
  foreach my $row(@$tabs) {
    foreach my $tab(@$row) {
      my $sth = $dbh->prepare("SELECT COUNT(*) nrow FROM $tab");
      $sth->execute;
      my $res = $sth->fetchrow_hashref;
      my $nrow = $res->{nrow};
      my $sname = "$tab";
      $sname =~ s/wgEncodeGisChiaPet//;
      $sname =~ s/InteractionsRep\d+//;
      print TAB join("\t",$sname,$nrow,$tab);
      print TAB "\n";
      $href->{$tab} = $sname;
    }
  }
  return $href;
}

sub get_tables_like {
  my $like = shift;
  my $tab = $dbh->selectall_arrayref("SHOW TABLES LIKE \'$like\'");
  return $tab;
}

sub get_coord_from_bed {
  my $bed = shift;
  open(IN,$bed);
  my $href = {};
  while(my $row = <IN>) {
    chomp($row);
    my($chr,$start,$end,$id) = split(/\t/,$row);
    $href->{$id}->{chr} = $chr;
    $href->{$id}->{start} = $start;
    $href->{$id}->{end} = $end;
  }
  return $href;
}

sub get_overlapping {
  my $id = shift;
  my $chr = shift;
  my $start = shift;
  my $end = shift;
  my $tab = shift;
  my $tag = shift;
  my $tabref = shift;

  my $sth = $dbh->prepare("SELECT * FROM $tab WHERE ".
                          "chrom = \'$chr\' AND ".
                          "chromStart <= $end AND ".
                          "chromEnd >= $start");
  $sth->execute;

  while(my $res = $sth->fetchrow_hashref) {
    print OUT join("\t",$tag,$id,$chr,$start,$end,$tabref->{$tab});
    print OUT "\t";
    analyze_chiapet($chr,$start,$end,$res);
    print OUT "\n";
  }
}

sub analyze_chiapet {
  my $chr = shift;
  my $start = shift;
  my $end = shift;
  my $res = shift;
  my $name = $res->{name};
  my $check = 'F';
  my $intra = 'F';
  # chr15:57668365..57669086-chr15:74345790..74346310,2
  my($chr1,$start1,$end1,$chr2,$start2,$end2);
  if($name =~ /^(chr.+)\:(\d+)\.\.(\d+)\-(chr.+)\:(\d+)\.\.(\d+)\,(\d+)$/) {
    $chr1 = $1;
    $start1 = $2;
    $end1 = $3;
    $chr2 = $4;
    $start2 = $5;
    $end2 = $6;
  }
  else {
    print "ERROR in analyzing $chr\:$start\-$end\n";
  }
  $check = 'T' if (($chr eq $chr1) && ($start <= $end1) && ($end >= $start1));
  $check = 'T' if (($chr eq $chr2) && ($start <= $end2) && ($end >= $start2));
  $intra = 'T' if ($chr1 eq $chr2);
  print OUT join("\t",$check,$intra,$chr1,$start1,$end1,$chr2,$start2,$end2);
}

