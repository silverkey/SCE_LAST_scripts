#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use lib "$ENV{'HOME'}/src/mce-0.1";
use lib "$ENV{'HOME'}/src/bioperl-live";
use lib "$ENV{'HOME'}/src/bioperl-run/lib";


use Bio::MCE::conf::Conf_49_out qw(%CONF);

use lib $CONF{'ENSEMBL'};

use DBI;
use Bio::Range;
use Bio::SeqFeature::Generic;
use Bio::EnsEMBL::Registry;
use Bio::MCE::Utils;
use Bio::MCE::Ensembl::Utils;

my $usage = "\n\tperl $0 [db] [usr] [pwd] [host] [organism 1] [organism 2]\n\n";
die $usage if scalar(@ARGV) != 6;

my $DBH = DBI->connect("dbi:mysql:$ARGV[0]\:$ARGV[3]",$ARGV[1],$ARGV[2],{PrintError => 1, RaiseError => 1});

Bio::EnsEMBL::Registry->load_all($CONF{'REGISTRY_CORE'});

my $ORGANISM1 = $ARGV[4];
my $ORGANISM2 = $ARGV[5];

my $m_slice_adaptor = Bio::EnsEMBL::Registry->get_adaptor($ORGANISM1,"core","slice");
my $f_slice_adaptor = Bio::EnsEMBL::Registry->get_adaptor($ORGANISM2,"core","slice");

# select all tmp_selected
my $selected = get_all_selected();

#my @WINDOW = (1000000,2000000);
my @WINDOW = (2000000);

# foreach tmp_selected
foreach my $row(@$selected) {

  my $fpid = $row->{'feature_pair_id'};
	print $fpid."\n";

	my($m_csn,$m_srn,$m_pre_start,$m_pre_end) = get_genomic_sce($fpid,$ORGANISM1);
	my($f_csn,$f_srn,$f_pre_start,$f_pre_end) = get_genomic_sce($fpid,$ORGANISM2);

  my $m_chr_slice = Bio::MCE::Utils->get_chr($m_srn,$ORGANISM1);
  my $f_chr_slice = Bio::MCE::Utils->get_chr($f_srn,$ORGANISM2);

  foreach my $window_length(@WINDOW) {

		# take a window around the hit in muose
	  my($m_start,$m_end) = get_window($m_pre_start,$m_pre_end,$m_chr_slice->length,$window_length);
		# fetch all genes
		# make the mouse_genes_hash
		my $m_hash = get_hash($m_csn,$m_srn,$m_start,$m_end,$m_slice_adaptor,$m_pre_start,$m_pre_end);

		# take a window around the hit in zebrafish
	  my($f_start,$f_end) = get_window($f_pre_start,$f_pre_end,$f_chr_slice->length,$window_length);
		# fetch all genes
		# make the zebrafish_genes_hash
		my $f_hash = get_hash($f_csn,$f_srn,$f_start,$f_end,$f_slice_adaptor,$f_pre_start,$f_pre_end);

		# foreach mouse gene
		foreach my $mgid(keys %$m_hash) {

			# foreach zebrafish related gene
			foreach my $fgid(@{$m_hash->{$mgid}->{'related'}}) {

				# if exists in the zebrafish_genes_hash
				if(exists $f_hash->{$fgid}) {
					populate_sinteny_window($fpid,$window_length,$mgid,$fgid,$m_hash->{$mgid},$f_hash->{$fgid});
				}
			}
		}
	}
}

sub populate_sinteny_window {

	my $fpid = shift;
	my $wl = shift;
	my $id1 = shift;
	my $id2 = shift;
	my $m = shift;
	my $f = shift;

my $m_bystander = '0';
my $m_n_bystander = '0';
my $f_bystander = '0';
my $f_n_bystander = '0';

if($m->{'nby'}) {
  $m_bystander = join(',',@{$m->{'bystander'}});
  $m_n_bystander = scalar(@{$m->{'bystander'}});
}
if($f->{'nby'}) {
  $f_bystander = join(',',@{$f->{'bystander'}});
  $f_n_bystander = scalar(@{$f->{'bystander'}});
}

my $relation = get_relation($id1,$id2);
my $cozone = get_cozone($m->{'location'},$f->{'location'});

	my $sth = $DBH->prepare('INSERT INTO sinteny_window SET '.
													'feature_pair_id = '.$fpid.
													',window = '.$wl.
													',m_ref_id = '.$DBH->quote($id1).
													',f_ref_id = '.$DBH->quote($id2).
													',m_distance = '.$m->{'distance'}.
													',f_distance = '.$f->{'distance'}.
													',m_location = '.$DBH->quote($m->{'location'}).
													',f_location = '.$DBH->quote($f->{'location'}).
                          ',m_n_bystander = '.$m_n_bystander.
                          ',f_n_bystander = '.$f_n_bystander.
													',m_intronic = '.$DBH->quote($m->{'intronic'}).
													',f_intronic = '.$DBH->quote($f->{'intronic'}).
													',cozone = '.$DBH->quote($cozone).
													',relation = '.$DBH->quote($relation).
													',organism1 = '.$DBH->quote($ORGANISM1).
													',organism2 = '.$DBH->quote($ORGANISM2));
	$sth->execute;
}

sub get_hash {
	my $csn = shift;
	my $srn = shift;
	my $start = shift;
	my $end = shift;
	my $slice_adaptor = shift;
	my $pre_start = shift;
	my $pre_end = shift;
	my $res;
	my $slice = $slice_adaptor->fetch_by_region($csn,$srn,$start,$end);
	#my $slice_genes = $slice->get_all_Genes_by_type('protein_coding','ensembl');
	my $slice_genes = $slice->get_all_Genes_by_type('protein_coding');
	foreach my $gene(@$slice_genes) {
    $gene = $gene->transform($csn);
		$res->{$gene->stable_id}->{'related'} = get_all_f_hom($gene);
		$res->{$gene->stable_id}->{'distance'} = Bio::MCE::Ensembl::Utils->get_smaller_distance($pre_start,$pre_end,$gene->start,$gene->end);
		$res->{$gene->stable_id}->{'location'} = Bio::MCE::Utils->relate_feature_to_gene($csn,$srn,$pre_start,$pre_end,$gene->stable_id);
		($res->{$gene->stable_id}->{'intronic'},$res->{$gene->stable_id}->{'bystander'},$res->{$gene->stable_id}->{'nby'}) = get_bystander($slice_adaptor,$csn,$srn,$pre_start,$pre_end,$gene->start,$gene->end);
	}	
	return $res;
}

sub get_all_f_hom {
	my $gene = shift;
	my @orto;
	my $sth = $DBH->prepare('SELECT * FROM relation WHERE ref_id = '.$DBH->quote($gene->stable_id));
	$sth->execute;
	while(my $row = $sth->fetchrow_hashref) {
		push(@orto,$row->{'orto_ref_id'});
	}
	return(\@orto);
}

sub get_all_selected {
  my @res;
  my $sth = $DBH->prepare('SELECT DISTINCT feature_pair_id FROM genomic_sce');
  $sth->execute;  
  while(my $row = $sth->fetchrow_hashref) {
    push(@res,$row);
  }
  return(\@res);
}

sub get_window {
  my $pre_start = shift;
  my $pre_end = shift;
  my $chr_length = shift;
  my $window_length = shift;
  my $sce_length = $pre_end-$pre_start+1;
  my $flanking = int(($window_length - $sce_length) / 2);
  $flanking = 1 if $flanking < 1;
  my $start = $pre_start-$flanking;
  $start = 1 if $start < 1;
  my $end = $pre_end+$flanking;
  $end = $chr_length if $end > $chr_length;
  return($start,$end);
}

sub get_bystander {
	my $slice_adaptor = shift;
	my $csn = shift;
	my $srn = shift;
	my $start_1 = shift;
	my $end_1 = shift;
	my $start_2 = shift;
	my $end_2 = shift;

	my $overlap = '0';
	my $sr_start;
	my $sr_end;
	my @res;

	if($start_1 <= $start_2) {
		if($end_1 > $start_2) {
			$overlap = 1;
			return($overlap,@res);
		}
		$sr_start = $end_1 + 1;
		$sr_end = $start_2 - 1;
	}
	elsif($start_1 > $start_2) {
		if($end_2 > $start_1) {
	    $overlap = 1;
			return($overlap,@res);
	  }
		$sr_start = $end_2 + 1;
		$sr_end = $start_1 - 1;
	}
	else {
		print "\nERRORRRRRRRRRRRRR\n";
	}

  my $slice = $slice_adaptor->fetch_by_region($csn,$srn,$sr_start,$sr_end);
  my $genes = $slice->get_all_Genes_by_type('protein_coding','ensembl');

	my $r1 = Bio::Range->new(-start => $sr_start, -end => $sr_end);

	foreach my $gene(@$genes) {
    $gene = $gene->transform($csn);
		my $r2 = Bio::Range->new(-start => $gene->start, -end => $gene->end);
		if($r1->contains($r2)) {
			push(@res,$gene->stable_id);
		}
	}
	return($overlap,\@res,scalar(@res));
}

sub get_relation {
	my $id1 = shift;
	my $id2 = shift;
	my $sth = $DBH->prepare('SELECT relation FROM relation WHERE '.
													'ref_id = '.$DBH->quote($id1).
													' AND orto_ref_id = '.$DBH->quote($id2));
	$sth->execute;
	my $row = $sth->fetchrow_hashref;
	return $row->{'relation'};
}

sub get_cozone {
	my $z1 = shift;
	my $z2 = shift;
	my $cozone;
	if($z1 =~ /int/ and $z2 =~ /int/) {
		$cozone = 'int';
	}
	elsif($z1 =~ /pre/ and $z2 =~ /pre/) {
		$cozone = 'pre';
	}
	elsif($z1 =~ /post/ and $z2 =~ /post/) {
		$cozone = 'post';
	}
	return $cozone;
}

sub get_genomic_sce {
	my $id = shift;
	my $organism = shift;
	my $sth = $DBH->prepare('SELECT * FROM genomic_sce WHERE '.
													'feature_pair_id = '.$id.
													' AND organism = '.$DBH->quote($organism));
	$sth->execute;
	my $row = $sth->fetchrow_hashref;
	return($row->{'csn'},$row->{'srn'},$row->{'start'},$row->{'end'});
}


