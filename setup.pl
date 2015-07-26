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

our $TEMP = '.home';
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

    mkdir $TEMP;
    return bless +{
        bin_dir          => catfile($cwd, 'bin'),
        zshrc_src        => catfile($cwd, 'zsh',      'rc.sh'),
        gitconfig_src    => catfile($cwd, 'git',      'config'),
        git_template_dir => catfile($cwd, 'git',      'template'),
        proverc_src      => catfile($cwd, 'prove',    'rc'),
        perltidyrc_src   => catfile($cwd, 'perltidy', 'rc'),
        tmuxconf_src     => catfile($cwd, 'tmux',     'conf'),
        screenrc_src     => catfile($cwd, 'screen',   'rc'),
        vimrc_src        => catfile($cwd, 'vim',      'rc'),
        emacsd_src       => catfile($cwd, 'emacs'),
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
    my @dependency = qw/bin zsh git prove perltidy screenrc tmuxconf vimrc emacs/;
    $self->$_ for @dependency;
}

sub install {
    my $self = shift;

    # dependency
    my @dependency = qw/bin zsh git prove perltidy screenrc tmuxconf vimrc emacs/;
    $self->$_ for @dependency;

    my $_install = sub {
        my ($self, $name) = @_;

        # hooks
        if ($name eq '.vimrc') {
            mkpath(catfile($HOME, '.vim', 'bundle'))        unless -d catfile($HOME, '.vim', 'bundle');
            mkpath(catfile($HOME, '.vim', 'tmp', 'swap'))   unless -d catfile($HOME, '.vim', 'tmp', 'swap');
            mkpath(catfile($HOME, '.vim', 'tmp', 'backup')) unless -d catfile($HOME, '.vim', 'tmp', 'backup');
            mkpath(catfile($HOME, '.vim', 'tmp', 'undo'))   unless -d catfile($HOME, '.vim', 'tmp', 'undo');
        }

        move(catfile($HOME, $name), catfile($HOME, "${name}.bak")) if -e catfile($HOME, $name);
        move(catfile($TEMP, $name), catfile($HOME, $name));
    };

    # zshrc
    $self->$_install('.zshrc');

    # git
    $self->$_install('.gitconfig');
    $self->$_install('.git.template');

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

    # bin
    $self->$_install('bin');
}

sub zsh {
    my $self = shift;

    return if -f catfile($TEMP, '.zshrc');
    open my $fh, '>', catfile($TEMP, '.zshrc') or die $!;
    print $fh "source $self->{zshrc_src}";
    close $fh;
}

sub git {
    my $self = shift;

    symlink $self->{gitconfig_src},    catfile($TEMP, '.gitconfig')    unless -f catfile($TEMP, '.gitconfig');
    symlink $self->{git_template_dir}, catfile($TEMP, '.git.template') unless -f catfile($TEMP, '.git.template');
}

sub perl {
    my $self = shift;

    # dependency
    my @dependency = qw/prove perltidy/;
    $self->$_ for @dependency;
}

sub prove {
    my $self = shift;

    symlink $self->{proverc_src}, catfile($TEMP, '.proverc') unless -f catfile($TEMP, '.proverc');
}

sub perltidy {
    my $self = shift;

    symlink $self->{perltidyrc_src}, catfile($TEMP, '.perltidyrc') unless -f catfile($TEMP, '.perltidyrc');
}

sub tmuxconf {
    my $self = shift;

    symlink $self->{tmuxconf_src}, catfile($TEMP, '.tmux.conf') unless -f catfile($TEMP, '.tmux.conf');
}

sub screenrc {
    my $self = shift;

    symlink $self->{screenrc_src}, catfile($TEMP, '.screenrc') unless -f catfile($TEMP, '.screenrc');
}

sub vimrc {
    my $self = shift;

    symlink $self->{vimrc_src}, catfile($TEMP, '.vimrc') unless -f catfile($TEMP, '.vimrc');
    system 'git', 'clone', 'git://github.com/Shougo/neobundle.vim', catfile($HOME, '.vim', 'bundle', 'neobundle.vim');
}

sub emacs {
    my $self = shift;

    return if -f catfile($TEMP, '.emacs.d');
    system 'git', 'submodule', 'init';
    system 'git', 'submodule', 'update';
    symlink $self->{emacsd_src}, catfile($TEMP, '.emacs.d');
}

sub bin {
    my $self = shift;

    symlink $self->{bin_dir}, catfile($TEMP, 'bin') unless -f catfile($TEMP, 'bin');
}

sub clean {
    my $self = shift;
    system 'rm', '-rf', $TEMP;
}

package main;
use strict;
use warnings;
use utf8;

die "Usage $0 build install clean" unless @ARGV;

my $builder = MyDotfiles::Builder->new;
$builder->$_ for grep { $builder->can($_) } @ARGV;
