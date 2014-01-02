package Mojolicious::Command::nopaste::Service;
use Mojo::Base 'Mojolicious::Command';

use Mojo::UserAgent;
use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev no_ignore_case);

has files => sub { [] };
has 'language';
has private => 0;
has ua      => sub { Mojo::UserAgent->new->max_redirects(10) };

sub run {
  my ($self, @args) = @_;
  GetOptionsFromArray( \@args,
    'language|l=s' => sub { $self->language($_[1]) },
    'private|P'    => sub { $self->private($_[1])  },
  );
  $self->files(\@args);
  my $url = $self->paste or return;
  say $url;
}

sub paste { die 'Not implemented' }

sub slurp { 
  my ($self, @files) = @_;
  @files = @{ $self->files } unless @files;
  local $/; local @ARGV = @files; 
  <>; 
}

1;
