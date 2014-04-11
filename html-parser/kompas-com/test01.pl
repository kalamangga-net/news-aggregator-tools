#!/usr/bin/perl -w
use strict; use warnings;
use HTML::TokeParser::Simple;

my $base='http://megapolitan.kompas.com';
my $url='/read/2014/04/11/1020331/Jadi.Cawapres.Ahok.Minta.Jokowi.Izin.kepada.Prabowo';
my $p = HTML::TokeParser::Simple->new(url => $base.$url);

#while (my $tag = $p->get_tag('h2')) {
#    while (my $token = $p->get_token) {
#        print $token->as_is."\n";
#        last;
#    }
#}
my $class = '';
while (my $tag = $p->get_tag('div')) {
	next if (!defined $tag->get_attr('class'));
	next if ($tag->get_attr('class') ne 'mb1');
	while (my $token = $p->get_token) {
		print $token->as_is."\n";
		last;
	}
}
