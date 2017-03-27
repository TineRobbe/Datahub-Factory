package Datahub::Factory;

our $VERSION = '0.8';

use Datahub::Factory::Sane;

use Datahub::Factory::Env;
use Datahub::Factory::Config;
use Datahub::Factory::PipelineConfig;
use namespace::clean;
use Sub::Exporter::Util qw(curry_method);
use Sub::Exporter -setup => {
    exports => [
        log              => curry_method,
        cfg              => curry_method,
        importer         => curry_method,
        fixer            => curry_method,
        store            => curry_method,
        exporter         => curry_method,
        pipeline         => curry_method,
    ],
    collectors => {'-load' => \'_import_load', ':load' => \'_import_load'},
};

sub _import_load {
    my ($self, $value, $data) = @_;

    if (is_array_ref $value) {
      self->load(@$value);
    }
    else {
      $self->load;
    }

    1;
}

sub load {
    my $class = shift;
    my $env   = Datahub::Factory::Env->new();
    $class->_env($env);
    $class;
}

sub _env {
    my ($class, $env) = @_;
    state $loaded_env;
    $loaded_env = $env if defined $env;
    $loaded_env
        ||= Datahub::Factory::Env->new();
}

sub importer {
    my $class = shift;
    $class->_env->importer(@_);
}

sub fixer {
    my $class = shift;
    $class->_env->fixer(@_);
}

sub exporter {
    my $class = shift;
    $class->_env->exporter(@_);
}

sub log {
	$_[0]->_env->log;
}

sub cfg {
    my $cfg = Datahub::Factory::Config->new();
    return $cfg->config;
}

sub pipeline {
    my $class = shift;
    return $class->_env->pipeline(@_);
}

1;
__END__

=encoding utf-8


=head1 NAME

=for html <a href="https://travis-ci.org/thedatahub/Datahub-Factory"><img src="https://travis-ci.org/thedatahub/Datahub-Factory.svg?branch=master"></a>

Datahub::Factory - A conveyor belt which transports data from a data source to
a data sink.

=head1 SYNOPSIS

dhconveyor [ARGUMENTS] [OPTIONS]

=head1 DESCRIPTION

Datahub::Factory is a command line conveyor belt which automates three tasks:

=over

=item Data is fetched automatically from a local or remote data source.

=item Data is converted to an exchange format.

=item The output is pushed to a data sink.

=back

Datahub::Factory fetches data from several sources as specified by the
I<Importer> settings, executes a L<Fix|Catmandu::Fix> and sends it to
a data sink, set by I<Exporter>. Several importer and exporter modules
are supported.

Datahub::Factory contains Log4perl support to monitor conveyor belt operations.

Note: This toolset is not a generic tool. It has been tailored towards the
functional requirements of the Flemish Art Collection use case.

=head1 CONFIGURATION

=head2 Command line options

All commands share the following switches:

=over

=item C<--log_level>

Set the log_level. Takes a numeric parameter. Supported levels are:
1 (WARN), 2 (INFO), 3 (DEBUG). WARN (1) is the default.

=item C<--log_output>

Selects an output for the log messages. By default, it will send them to STDERR (pass C<STDERR> as parameter), but STDOUT (C<STDOUT>) and a log file (C<logs/import_-date-.log>) (C<STATISTICS>) are also supported.

=back

=head1 COMMANDS

=head2 help COMMAND

Documentation about command line options.

It is possible to provide either all importer and/or exporter options on the
command line, or to create a I<pipeline configuration file> that sets those
options.

=head2 transport [OPTIONS]

Fetch data from a local or remote source, convert it to an exchange format and
export the data.

L<Datahub::Factory::Command::transport>

=head1 AUTHORS

=over

=item Pieter De Praetere <pieter@packed.be>

=item Matthias Vandermaesen <matthias.vandermaesen@vlaamsekunstcollectie.be>

=back

=head1 COPYRIGHT

Copyright 2016 - PACKED vzw, Vlaamse Kunstcollectie vzw

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the terms of the GPLv3.

=cut
