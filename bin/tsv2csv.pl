#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Encode;
use Text::CSV_XS qw/csv/;

my $file = shift;
open my $fh, '<', $file
    or die $!;


my $csv = Text::CSV_XS->new({ binary => 1, auto_diag => 1 });
until (eof $fh) {
    my $line = <$fh>;
    chomp $line;

    my @row = split /\t/, $line;
    $csv->say(*STDOUT, \@row);
}
