#!/usr/bin/perl
use strict;
use Data::Dumper;

=item
a1 a2 a3 
b1 b2 b3
c1 c2 c3
=cut

my $connected_to = {
	a1 => ['a2','b1','b2'],
	a2 => ['a1','a3', 'b1','b2','b3'],
	a3 => ['a2','b2','b3'],
	b1 => ['a1','a2','b2','c1','c2'],
	b2 => ['a1','a2','a3','b1','b3','c1','c2','c3'],
	b3 => ['a2','a3','b2','c2','c3'],
	c1 => ['b1','b2','c2'],
	c2 => ['b1','b2','b3','c1','c3'],
	c3 => ['b2','b3','c2']
};

my $boggle = {
	a1 => 'a',
	a2 => 'e',
	a3 => 'i',
	b1 => 'c',
	b2 => 't',
	b3 => 's',
	c1 => 'g',
	c2 => 'o',
	c3 => 't'
};

my $MIN_WORD_LEN = 4;
my $MAX_WORD_LEN = 8;

print <<EOD;
$boggle->{"a1"} $boggle->{"a2"} $boggle->{"a3"}
$boggle->{"b1"} $boggle->{"b2"} $boggle->{"b3"}
$boggle->{"c1"} $boggle->{"c2"} $boggle->{"c3"}
EOD

my $words;
open(F, "<words.txt");
while (my $word = (<F>)) {
	chop $word;
	$words->{$word} = 1;
};

my $max_word_len=3;

my @boggle_squares = qw(a1 a2 a3 b1 b2 b3 c1 c2 c3);
my @boggle_squares = qw(a1 a2 a3);
foreach my $square (@boggle_squares) {
	my @contains = ($square);

	my $word;

	#RECURSE($square, @contains) while $len < $max_word_len;
	my %v; #visited
	my $chain = $boggle->{square};
	travel($square, $chain, %v);
	

};

sub travel {
	my ($square, $chain, %v) = @_;
	$v{$square}++;
print "chain: [$chain]\n" if length($chain) >= $MIN_WORD_LEN && exists $words->{$chain};
#print Dumper \%v;
	foreach my $c ( @{ $connected_to->{$square}  }) {
		#print "   connection $c\n";
		if ($v{$c}) {
			#print "Visited $c, skipping ($chain) \n";
			next;
		};
		my $subchain = "${chain}$boggle->{$c}";
		if (length($subchain) >= $MAX_WORD_LEN) {
			#print "   length of chain [$subchain] too long, next\n";
			last;
		};
#getc;
		travel($c,$subchain,%v);
	};
};
