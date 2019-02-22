#!/usr/bin/perl
use strict;
use Data::Dumper;

=item
a1 a2 a3 a4 a5
b1 b2 b3 b4 b5
c1 c2 c3 c4 c5
d1 d2 d3 d4 d5
e1 e2 e3 e4 e5
=cut

my $connected_to = {
	a1 => [qw(a2 b1 b2)],
	a2 => ['a1','a3', 'b1','b2','b3'],
	a3 => [qw(a2 a4 b2 b3 b4)],
	a4 => [qw(a3 a5 b3 b4 b5)],
	a5 => [qw(a4 b4 b5)],
	b1 => ['a1','a2','b2','c1','c2'],
	b2 => ['a1','a2','a3','b1','b3','c1','c2','c3'],
	b3 => [qw(a2 a3 a4 b2 b4 c2 c3 c4)],
	b4 => [qw(a3 a4 a5 b3 b5 c3 c4 c5)],
	b5 => [qw(a4 a5 b4 c4 c5)],
	c1 => [qw(b1 b2 c2 d1 d2)],
	c2 => [qw(b1 b2 b3 c1 c3 d1 d2 d3)],
	c3 => [qw(b2 b3 b4 c2 c4 d2 d3 d4)],
	c4 => [qw(b3 b4 b5 c3 c5 d3 d4 d5)],
	c5 => [qw(b4 b5 c4 d4 d5)],
	d1 => [qw(c1 c2 d2 e1 e2)],
	d2 => [qw(c1 c2 c3 d1 d3 e1 e2 e3)],
	d3 => [qw(c2 c3 c4 d2 d4 e2 e3 e4)],
	d4 => [qw(c3 c4 c5 d3 d5 e3 e4 e5)],
	d5 => [qw(c4 c5 d4 e4 e5)],
	e1 => [qw(d1 d2 e2)],
	e2 => [qw(d1 d2 d3 e1 e3)],
	e3 => [qw(d2 d3 d4 e2 e4)],
	e4 => [qw(d3 d4 d5 e3 e5)],
	e5 => [qw(d4 d5 e4)],
};

my $boggle = {
	a1 => 'e',
	a2 => 'h',
	a3 => 'i',
	a4 => 'r',
	a5 => 'm',
	b1 => 'd',
	b2 => 'n',
	b3 => 'l',
	b4 => 'm',
	b5 => 'u',
	c1 => 'f',
	c2 => 'e',
	c3 => 'r',
	c4 => 's',
	c5 => 'r',
	d1 => 'e',
	d2 => 'p',
	d3 => 'z',
	d4 => 'o',
	d5 => 'n',
	e1 => 'l',
	e2 => 'a',
	e3 => 'r',
	e4 => 'e',
	e5 => 'f',
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
my $FOUND;
my @boggle_squares = qw(a1 a2 a3 b1 b2 b3 c1 c2 c3);
my @boggle_squares = qw(a1 a2 a3 a4 a5 b1 b2 b3 b4 b5 c1 c2 c3 c4 c5 d1 d2 d3 d4 d5 e1 e2 e3 e4 e5);
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
	print "chain: [$chain]\n" if length($chain) >= $MIN_WORD_LEN && exists $words->{$chain} && ! exists $FOUND->{$chain};
	$FOUND->{$chain}++;
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
