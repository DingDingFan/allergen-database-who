#!/usr/bin/perl 
use strict;
use FindBin qw($Bin);
my $tag;
for(my $i=988;$i<=10000;$i++){
#for(my $i=1;$i<=987;$i++){
	my $net=`curl http://www.allergen.org/viewallergen.php?aid=$i 2>/dev/null `;
	open O ,">out/$i.html";
	print O "$net";
	close O;
	my $name='';
	my $bioname='';
	my $SDS='';
	my $provider='';
	my $date='';
	my $genebank='';
	my $unipro='';
	my @infor=split /\n/,$net;
	my $n=scalar @infor;
	my ($N,$P,$unipro,$pdb)='';
	my ($order,$sp)='';
	for(my $i=0; $i <$n;$i++){	
		if ($infor[$i]=~ /Allergen\s+name/){
			#print "$infor[$i]\n$infor[$i+1]\n$infor[$i+2]\n";
			 $name=$1 if $infor[$i+2]=~ /\>+([^\<]+)\</;
	#		print "$name\n";
		}
		if($infor[$i]=~ /Biochemical name/){
			$bioname=$1 if $infor[$i]=~ /Biochemical name.*?=.*?\>([^\<]+)\</;
	#		print "$bioname\n";
		}
		if($infor[$i]=~ /MW\(SDS\-PAGE\)/){
			$SDS=$1	if $infor[$i]=~ /MW\(SDS\-PAGE\).*?class=.*?\>([^\<]+)\</;
		}
		if($infor[$i]=~ />Name:</){
			$provider=$1 if$infor[$i]=~ />Name:<.*?td>([^<]+)<\/td>/;
		}
		if($infor[$i]=~ />Date Created:</){
			$date=$1 if $infor[$i]=~ />Date Created:<.*?td>\'([^<]+)<\/td>/;
		}
		if($infor[$i]=~ /GenBank Nucleotide/){
			my @ids=split /<td>/,$infor[$i+9];
			$N=$1 if $ids[1]=~ />([^<]+)</;
			$P=$1 if $ids[2]=~ />([^<]+)</;
			$unipro=$1 if $ids[3]=~ />([^<]+)</;
			$pdb=$1 if $ids[4]=~ />([^<]+)</;
		}
		if($infor[$i]=~ />Lineage:</){
			$order= $1 if $infor[$i+2]=~/TaxOrder=([^\']+)\'/;
			$sp = $1 if $infor[$i+2]=~/Species=([^\']+)\'/;
		}
	}
	print "$i\t$order\t$sp\t$name\t$bioname\t$SDS\t$provider\t$date\t$N\t$P\t$unipro\t$pdb\n";
	$tag++ unless $sp;
	last if $tag>300;
}
##############################################################################
