package Datahub::Factory::Exporter::YAML;

use strict;
use warnings;

use Moo;
use Catmandu;

with 'Datahub::Factory::Exporter';

sub _build_out {
    my $self = shift;
    my $exporter = Catmandu->exporter('YAML');
    return $exporter;
}

1;