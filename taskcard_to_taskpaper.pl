#!/usr/bin/perl -w 
#######################################################################################
#
# Program: taskcard_to_taskpaper.pl
#
# By: Kenny Drobnack
#
# Description: Convert a sheet from TaskCard (which is really just an XML .plist file) to a TaskPaper file
# 	(which is just a plain text file with some special formatting rules)
#
# History: 
# 	2010/06/01 - Kenny Drobnack (KWD) - created program
#
#######################################################################################
use strict;
use XML::DOM;
use Mac::Tie::PList;
use Data::Dumper;


my $taskcard_file = shift @ARGV;
unless ($taskcard_file) {
	die "Usage: taskcard_to_taskpaper.pl TaskCardFile\n";
}

my $plist = Mac::Tie::PList->new_from_file("$taskcard_file");
my ($key, $val);
while (($key,$val) = each %{$plist}) {
	if ($key eq 'image') { next; } 
	foreach my $val1 (@{$val}) { 
		print "$val1->{title}:\n";
		nested_items(1, $val1->{'browser'}->{'system.objects'});
	}
}


sub nested_items {
	my ($levels_deep, $items) = @_;
	my $tabs = '';
	foreach (my $level = 0; $level < $levels_deep; $level++) {
		$tabs = $tabs . "\t";
	}
	foreach my $i (@{$items}) {
		my $completed = $i->{completed} ? ' @done' : '';
		print $tabs . "- $i->{'text'}$completed\n";
		if ($i->{'system.objects'}) {
			nested_items(($levels_deep + 1), $i->{'system.objects'});
		}
	}
}




