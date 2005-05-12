package Posy::Plugin::LocalDepth;
use strict;

=head1 NAME

Posy::Plugin::LocalDepth - Posy plugin to filter by local depth.

=head1 VERSION

This describes version B<0.42> of Posy::Plugin::LocalDepth.

=cut

our $VERSION = '0.42';

=head1 SYNOPSIS

    @plugins = qw(Posy::Core
	...
	Posy::Plugin::LocalDepth));
    @actions = qw(header
	    ...
	    select_entries
	    filter_by_date
	    filter_by_localdepth
	    ...
	);

=head1 DESCRIPTION

This plugin restricts entries to those within the $localdepth config setting --
the "depth" of the entry is compared to the "depth" of the current category and
if the difference is more than "localdepth minus 1" then that entry is not
included in the list.

That is, with a localdepth of 1, then only entries with the same depth as
the current category are included.

If localdepth is zero, then all entries are included.

One needs to add the 'filter_by_localdepth' action to the actions list.

=head2 Configuration

This expects configuration settings in the $self->{config} hash,
which, in the default Posy setup, can be defined in the main "config"
file in the data directory.

=over

=item B<localdepth>

The "local" depth to check.  If zero, then no localdepth checking is done.

=back

=cut

=head1 OBJECT METHODS

Documentation for developers and those wishing to write plugins.

=head2 init

Do some initialization; make sure that default config values are set.

=cut
sub init {
    my $self = shift;
    $self->SUPER::init();

    # set defaults
    $self->{config}->{localdepth} = 0
	if (!defined $self->{config}->{localdepth});
} # init

=head1 Flow Action Methods

Methods implementing actions.

=head2 filter_by_localdepth

$self->filter_by_localdepth($flow_state);

Select entries by looking at the local-depth information
in $self->{path}.
Assumes that $flow_state->{entries} has already been
populated; updates it.

=cut
sub filter_by_localdepth {
    my $self = shift;
    my $flow_state = shift;

    if ($self->{config}->{localdepth} > 0)
    {
	my @entries = ();
	foreach my $key (@{$flow_state->{entries}})
	{
	    my $localdepth = ($self->{categories}->{
		$self->{files}->{$key}->{cat_id}}->{depth}
		    - $self->{path}->{depth});
	    if ($localdepth
		< $self->{config}->{localdepth})
	    {
		push @entries, $key;
	    }
	}
	@{$flow_state->{entries}} = @entries;
    }
} # filter_by_localdepth

=head1 INSTALLATION

Installation needs will vary depending on the particular setup a person
has.

=head2 Administrator, Automatic

If you are the administrator of the system, then the dead simple method of
installing the modules is to use the CPAN or CPANPLUS system.

    cpanp -i Posy::Plugin::LocalDepth

This will install this plugin in the usual places where modules get
installed when one is using CPAN(PLUS).

=head2 Administrator, By Hand

If you are the administrator of the system, but don't wish to use the
CPAN(PLUS) method, then this is for you.  Take the *.tar.gz file
and untar it in a suitable directory.

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

Or, if you're on a platform (like DOS or Windows) that doesn't like the
"./" notation, you can do this:

   perl Build.PL
   perl Build
   perl Build test
   perl Build install

=head2 User With Shell Access

If you are a user on a system, and don't have root/administrator access,
you need to install Posy somewhere other than the default place (since you
don't have access to it).  However, if you have shell access to the system,
then you can install it in your home directory.

Say your home directory is "/home/fred", and you want to install the
modules into a subdirectory called "perl".

Download the *.tar.gz file and untar it in a suitable directory.

    perl Build.PL --install_base /home/fred/perl
    ./Build
    ./Build test
    ./Build install

This will install the files underneath /home/fred/perl.

You will then need to make sure that you alter the PERL5LIB variable to
find the modules, and the PATH variable to find the scripts (posy_one,
posy_static).

Therefore you will need to change:
your path, to include /home/fred/perl/script (where the script will be)

	PATH=/home/fred/perl/script:${PATH}

the PERL5LIB variable to add /home/fred/perl/lib

	PERL5LIB=/home/fred/perl/lib:${PERL5LIB}


=head1 REQUIRES

    Posy
    Posy::Core

    Test::More

=head1 SEE ALSO

perl(1).
Posy

=head1 BUGS

Please report any bugs or feature requests to the author.

=head1 AUTHOR

    Kathryn Andersen (RUBYKAT)
    perlkat AT katspace dot com
    http://www.katspace.com

=head1 COPYRIGHT AND LICENCE

Copyright (c) 2005 by Kathryn Andersen

Inspired by the zlocaldepth blosxom plugin by Fletcher T. Penney.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Posy::Plugin::LocalDepth
__END__
