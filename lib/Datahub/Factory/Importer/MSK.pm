package Datahub::Factory::Importer::MSK;

use strict;
use warnings;

use Moo;
use Catmandu;

use Datahub::Factory;

use Datahub::Factory::Importer::Adlib;
use Datahub::Factory::Importer::PIDS;

with 'Datahub::Factory::Importer';

has file_name => (is => 'ro', required => 1);
has data_path => (is => 'ro', default => sub { return 'recordList.record.*'; });

has adlib    => (is => 'lazy');
has pids     => (is => 'lazy');

sub _build_importer {
    my $self = shift;
    my $importer = $self->adlib->importer;
    $self->prepare();
    return $importer;
}

sub _build_adlib {
    my $self = shift;
    my $adlib = Datahub::Factory::Importer::Adlib->new(
        file_name => $self->file_name,
        data_path => $self->data_path
    );
    return $adlib;
}

sub _build_pids {
    my $self = shift;
    return Datahub::Factory::Importer::PIDS->new(
        username => Datahub::Factory::cfg->param('module_PIDS.username'),
        api_key  => Datahub::Factory::cfg->param('module_PIDS.api_key')
    );
}

sub prepare {
    my $self = shift;
    $self->logger->info('Creating "pids" temporary table.');
    $self->__pids();
    $self->logger->info('Creating "creators" temporary table.');
    $self->__creators();
    $self->logger->info('Creating "aat" temporary table.');
    $self->__aat();
}

sub __pids {
    my $self = shift;
    $self->pids->temporary_table($self->pids->get_object('PIDS_MSK_UTF8.csv'));
}

sub __creators {
    my $self = shift;
    $self->pids->temporary_table($self->pids->get_object('CREATORS_MSK_UTF8.csv'));
}

sub __aat {
    my $self = shift;
    $self->pids->temporary_table($self->pids->get_object('AAT_UTF8.csv'), 'record - object_name');
}

1;
__END__

=encoding utf-8

=head1 NAME

Datahub::Factory::Importer::MSK - Import data from L<Adlib|http://www.adlibsoft.nl/> data dumps as used by the L<MSK|http://mskgent.be/nl>

=head1 SYNOPSIS

    use Datahub::Factory::Importer::MSK;
    use Data::Dumper qw(Dumper);

    my $msk = Datahub::Factory::Importer::MSK->new(
        file_name => '/tmp/msk.xml',
        data_path => 'recordList.record.*'
    );

    $msk->importer->each(sub {
        my $item = shift;
        print Dumper($item);
    });

=head1 DESCRIPTION

Datahub::Factory::Importer::MSK uses L<Catmandu|http://librecat.org/Catmandu/> to fetch a list of records
from an AdlibXML data dump generated by the L<MSK|http://mskgent.be/nl>. It returns an L<Importer|Catmandu::Importer>.

=head1 PARAMETERS

=over

=item C<file_name>

Location of the Adlib XML data dump. It expects AdlibXML.

=item C<data_path>

Optional parameter that indicates where the records are in the XML tree. It uses L<Catmandu::Fix|https://github.com/LibreCat/Catmandu/wiki/Fixes-Cheat-Sheet> syntax.
By default, records are in the C<recordList.record.*> path.

=back

=head1 ATTRIBUTES

=over

=item C<importer>

A L<Importer|Catmandu::Importer> that can be used in your script.

=back

=head1 AUTHOR

Pieter De Praetere E<lt>pieter at packed.be E<gt>

=head1 COPYRIGHT

Copyright 2017- PACKED vzw
=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Datahub::Factory>
L<Datahub::Factory::Adlib>
L<Catmandu>

=cut