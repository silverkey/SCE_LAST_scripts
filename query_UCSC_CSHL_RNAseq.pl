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
open(TAB,">UCSC_tables_counts");

my $dbh = DBI->connect("DBI:mysql:database=$db;host=$host",
                       $user,$password, {RaiseError => 1});

my $short = get_tables_like('wgEncodeCshlShort%Contigs');
my $long = get_tables_like('wgEncodeCshlLong%Contigs');
my $coord = get_coord_from_bed($bed);
my $tag;

my $short_ref = count_rows_in_tables($short);
my $long_ref = count_rows_in_tables($long);
close(TAB);

foreach my $id(keys %$coord){
  my $chr = $coord->{$id}->{chr};
  my $start = $coord->{$id}->{start};
  my $end = $coord->{$id}->{end};

  $tag = 'short';
  foreach my $row(@$short) {
    foreach my $tab(@$row) {
      print "Analyzing $id in table $tab\n";
      my $ov = get_overlapping($id,$chr,$start,$end,$tab,$tag,$short_ref);
    }
  }

  $tag = 'long';
  foreach my $row(@$long) {
    foreach my $tab(@$row) {
      print "Analyzing $id in table $tab\n";
      my $ov = get_overlapping($id,$chr,$start,$end,$tab,$tag,$long_ref);
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
      $sname =~ s/wgEncodeCshlLongRnaSeq//;
      $sname =~ s/wgEncodeCshlShortRnaSeq//;
      $sname =~ s/Contigs//;
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
    print OUT join("\t",$tag,$id,$chr,$start,$end,$tabref->{$tab},$res->{chrom},$res->{chromStart},$res->{chromEnd},
                        $res->{strand},$res->{name},$res->{score},$res->{level},$res->{signif},$res->{score2});
    print OUT "\n";
  }
}
