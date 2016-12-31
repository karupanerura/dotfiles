#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use FindBin;
use File::Spec::Functions qw/catfile/;

open my $fh, '<', catfile($FindBin::Bin, 'rc.sh')
    or die $!;

my @files;
until (eof $fh) {
    chomp(my $line = <$fh>);
    if ($line =~ /^source/) {
        my ($file) = $line =~ m!src/([^.]+\.sh)$!;
        push @files => $file;
    }
}

close $fh;

for my $file (@files) {
    my $path = catfile($FindBin::Bin, src => $file);

    # header
    print '#' x 64, $/;
    print "# $file", $/;
    print '#' x 64, $/;
    print $/;

    # body
    open my $fh, '<', $path or die $!;
    until (eof $fh) {
        my $line = <$fh>;
        print $line;
    }

    # sep
    my $is_last = $files[-1] eq $file;
    print $/ unless $is_last;
}
