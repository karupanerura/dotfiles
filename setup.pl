#!/usr/bin/env perl
package MyDotfiles::Builder;
use strict;
use warnings;
use utf8;

BEGIN {## hack for echo
    use File::Spec;

    *CORE::GLOBAL::system = sub {
        print(join(' ', @_), "\n");
        CORE::system(@_);
    };
    *CORE::GLOBAL::symlink = sub ($$) {## no critic
        my($src, $dest) = @_;
        $src  = File::Spec->rel2abs($src);
        $dest = File::Spec->rel2abs($dest);

        print( join(' ', 'ln', '-s', $src, $dest), "\n" );
        CORE::symlink $src, $dest;
    };

    {
        no warnings 'redefine';
        require File::Path;
        *File::Path::mkpath = do {
            use warnings 'redefine';
            my $super = \&File::Path::mkpath;
            sub {
                print(join(' ', 'mkdir', '-p', @_), "\n");
                $super->(@_);
            };
        };
    }

    {
        no warnings 'redefine';
        require File::Copy;
        *File::Copy::move = do {
            use warnings 'redefine';
            my $super = \&File::Copy::move;
            sub {
                print(join(' ', 'mv', @_), "\n");
                $super->(@_);
            };
        };
    }
}

use Carp qw/croak/;
use Cwd qw/chdir/;
use File::Basename qw/dirname/;
use File::Spec::Functions qw/rel2abs catfile/;

our $HOME;
if (do { local $@; eval { require File::HomeDir; 1 } }) {
    $HOME = File::HomeDir->my_home;
}
elsif ($ENV{HOME}) {
    $HOME = $ENV{HOME};
}
else {
    die "File::HomeDir required.";
}

sub new {
    my $class = shift;

    my $cwd = rel2abs(dirname(__FILE__));
    chdir($cwd);

    return bless +{
        zshrc_src      => catfile($cwd, 'zsh',      'rc.sh'),
        gitconfig_src  => catfile($cwd, 'git',      'config'),
        proverc_src    => catfile($cwd, 'prove',    'rc'),
        perltidyrc_src => catfile($cwd, 'perltidy', 'rc'),
        tmuxconf_src   => catfile($cwd, 'tmux',     'conf'),
        screenrc_src   => catfile($cwd, 'screen',   'rc'),
        vimrc_src      => catfile($cwd, 'vim',      'rc'),
        emacsd_src     => catfile($cwd, 'emacs'),
    } => $class;
}

sub can {
    my $invocant = shift;
    MyDotfiles::Builder::Command->can(@_)
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my($method) = $AUTOLOAD =~ /::([^:]+)$/;

    if (my $code = $self->can($method)) {
        $self->$code(@_);
    }
    else {
        my $pkg = ref($self) || $self;
        croak qq{Can't locate object method "${method}" via package "MyDotfiles::Builder::Command"};
    }
}

sub DESTROY {}

package MyDotfiles::Builder::Command;
use strict;
use warnings;
use utf8;

use File::Spec::Functions qw/catfile/;
use File::Path qw/mkpath/;
use File::Copy qw/move/;

sub build {
    my $self = shift;

    # dependency
    my @dependency = qw/zsh git prove perltidy screenrc tmuxconf vimrc emacs/;
    $self->$_ for @dependency;
}

sub install {
    my $self = shift;

    # dependency
    my @dependency = qw/zsh git prove perltidy screenrc tmuxconf vimrc emacs/;
    $self->$_ for @dependency;

    my $_install = sub {
        my($self, $name) = @_;

        # hooks
        if ($name eq '.vimrc') {
            mkpath(catfile($HOME, '.vim', 'tmp', 'swap'))   unless -d catfile($HOME, '.vim', 'tmp', 'swap');
            mkpath(catfile($HOME, '.vim', 'tmp', 'backup')) unless -d catfile($HOME, '.vim', 'tmp', 'backup');
            mkpath(catfile($HOME, '.vim', 'tmp', 'undo'))   unless -d catfile($HOME, '.vim', 'tmp', 'undo');
        }

        move(catfile($HOME, $name), catfile($HOME, "${name}.bak")) if -e catfile($HOME, $name);
        move($name, catfile($HOME, $name));
    };

    # zshrc
    $self->$_install('.zshrc');

    # git
    $self->$_install('.gitconfig');

    # proverc
    $self->$_install('.proverc');

    # perltidy
    $self->$_install('.perltidyrc');

    # tmuxconf
    $self->$_install('.tmux.conf');

    # screenrc
    $self->$_install('.screenrc');

    # vimrc
    $self->$_install('.vimrc');

    # emacs
    $self->$_install('.emacs.d');
}

sub zsh {
    my $self = shift;

    return if -f '.zshrc';
    open my $fh, '>', '.zshrc' or die $!;
    print $fh "source $self->{zshrc_src}";
    close $fh;
}

sub git {
    my $self = shift;

    return if -s '.gitconfig';
    symlink $self->{gitconfig_src}, '.gitconfig';
}

sub perl {
    my $self = shift;

    # dependency
    my @dependency = qw/prove perltidy/;
    $self->$_ for @dependency;
}

sub prove {
    my $self = shift;

    return if -s '.proverc';
    symlink $self->{proverc_src}, '.proverc';
}

sub perltidy {
    my $self = shift;

    return if -s '.perltidyrc';
    symlink $self->{perltidyrc_src}, '.perltidyrc';
}

sub tmuxconf {
    my $self = shift;

    return if -s '.tmux.conf';
    symlink $self->{tmuxconf_src}, '.tmux.conf';
}

sub screenrc {
    my $self = shift;

    return if -s '.screenrc';
    symlink $self->{screenrc_src}, '.screenrc';
}

sub vimrc {
    my $self = shift;

    return if -s '.vimrc';
    symlink $self->{vimrc_src}, '.vimrc';
}

sub emacs {
    my $self = shift;

    return if -s '.emacs.d';
    system('git', 'submodule', 'init');
    system('git', 'submodule', 'update');
    symlink $self->{emacsd_src}, '.emacs.d';
}

sub clean {
    my $self = shift;
    system('rm', '-rf', qw/.zshrc .gitconfig .proverc .perltidyrc .screenrc .tmux.conf .vimrc .emacs.d/);
}

package main;
use strict;
use warnings;
use utf8;

die "Usage $0 build install clean" unless @ARGV;

my $builder = MyDotfiles::Builder->new;
$builder->$_ for grep { $builder->can($_) } @ARGV;
