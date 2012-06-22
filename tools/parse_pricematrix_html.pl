#!/usr/bin/env perl

use strict;
use warnings;

use Pod::Usage;
use HTML::TreeBuilder::XPath;
use HTML::Selector::XPath 'selector_to_xpath';

my $file = $ARGV[0] or pod2usage(-1);

my $tree = HTML::TreeBuilder::XPath->new_from_file($file);

my @tr = $tree->findnodes(selector_to_xpath('table tr'));

my @header_td = $tr[0]->find_by_tag_name('td');
shift @header_td;

my (@countries, @currencies);
for my $country_and_currency (map { $_->as_trimmed_text } @header_td) {
    my ($country, $currency) = split ' - ', $country_and_currency;

    push @countries, $country;
    push @currencies, $currency;
}

print 'our %COUNTRIES = (', "\n";
my $i = 0;
for my $country (@countries) {
    print "    '$country' => @{[ $i++ ]},\n";
}
print ");\n";

print "\n";

print 'our %CURRENCIES = (', "\n";
$i = 0;
for my $currency (@currencies) {
    print "    '$currency' => @{[ $i++ ]},\n";
}
print ");\n"; 
print "\n";

splice @tr, 0, 2;               # remove header tr's

my $price_matrix   = [];
my $proceed_matrix = [];

for my $t (@tr) {
    my @td = $t->find_by_tag_name('td');
    shift @td;

    my (@prices, @proceeds);

    while (scalar @td) {
        push @prices, (shift @td)->as_trimmed_text;
        push @proceeds, (shift @td)->as_trimmed_text;
    }

    $_ =~ s/,//g for @prices, @proceeds;

    push @$price_matrix, \@prices;
    push @$proceed_matrix, \@proceeds;
}

$tree->delete;

print 'our $PRICE_MATRIX = [', "\n";
for my $row (@$price_matrix) {
    print '    [';
    print join ',', map { sprintf '%8s', $_ } @$row;
    print "],\n";
}
print "];\n";
print "\n";

print 'our $PROCEED_MATRIX = [', "\n";
for my $row (@$proceed_matrix) {
    print '    [';
    print join ',', map { sprintf '%8s', $_ } @$row;
    print "],\n";
}
print "];\n";
print "\n";

__END__

=head1 NAME

parse_pricematrix_html.pl - parse price matrix html provided by Apple

=head1 SYNOPSIS

    parse_pricematrix_html.pl pricematrix.html

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=cut
