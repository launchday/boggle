#!/usr/bin/perl
use strict;

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

my $max_word_len=3;

my @boggle_squares = qw(a1 a2 a3 b1 b2 b3 c1 c2 c3);
foreach my $square (@boggle_squares) {
	my @contains = ($square);

	my $word;

	RECURSE($square, @contains) while $len < $max_word_len;

};
