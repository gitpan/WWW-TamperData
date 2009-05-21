package WWW::TamperData;

use warnings;
use strict;
use Carp;
use XML::Simple;
use LWP::UserAgent;

=head1 NAME

WWW::TamperData - Replay tamper data xml files!

=head1 VERSION

Version 0.01_1

=cut

# Globals
our $VERSION = '0.01';
our $AUTHOR = 'Eldar Marcussen - http://www.justanotherhacker.com';
our $_tamperagent;
our $_tamperxml;

=head1 SYNOPSIS

Tamperdata is a firefox extension that lets you intercept or inspect browser requests and the server responses. WWW::TamperData can replay
requests exported to an xml file from tamperdata.

Replaying a file can be as simple as:

    use WWW::TamperData;

    my $foo = WWW::TamperData->new(transcript => "myfile.xml");
    my %data = $foo->replay();

=head1 FUNCTIONS

=head2 new

Initializes the new object, it takes some arguments

=cut

sub new {
    my ($class, %options) = @_;
    my $self = {};

    $self->{'transcript'} = $options{'transcript'} ? $options{'transcript'} : "tamperdata.xml";
    $self->{'timeout'}    = $options{'timeout'} ? $options{'timeout'} : 10;

    $_tamperxml = XMLin($self->{'transcript'});
    $_tamperagent = LWP::UserAgent->new;
    $_tamperagent->timeout($self->{'timeout'});
    return bless $self, $class;
}

=head2 replay

This function will replay all the requests provided in the xml file in sequential order.

=cut

sub replay {
    my $self = shift;
    if (ref($_tamperxml->{tdRequest}) eq 'ARRAY') {
        for my $x (0..scalar($_tamperxml->{tdRequest})) {
            $_tamperxml->{tdRequest}->[$x]->{uri} =~ s/%([0-9A-F][0-9A-F])/pack("c",hex($1))/gei;
            my $response = $_tamperagent->get($_tamperxml->{tdRequest}->[$x]->{uri});
            if (!$response->is_success) {
                croak $response->status_line;
            }
        }
    }
}

=head1 AUTHOR

Eldar Marcussen, C<< <japh at justanotherhacker.com> >>

=head1 BUGS
The module is currently in its infancy please be aware teh it currently only supports get requests and does not transmit headers

Please report any bugs or feature requests to C<bug-www-tamperdata at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-TamperData>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::TamperData


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-TamperData>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-TamperData>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-TamperData>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-TamperData>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Eldar Marcussen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of WWW::TamperData
