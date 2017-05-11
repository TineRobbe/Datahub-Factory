package Datahub::Factory::Fixer::Condition;

use strict;
use warnings;

use Datahub::Factory;

use Moo;
use Catmandu;
use Catmandu::Util qw(data_at);
use namespace::clean;

##
# Loads the correct fixer based on a condition.

has options         => (is => 'ro', required => 1);
has item            => (is => 'ro', required => 1);


has condition  => (is => 'lazy');
has fix_module => (is => 'lazy');

sub _build_fix_module {
    my $self = shift;
    ##
    # We can have two options: either we have a condition
    # option _and_ a list of potential fixers in the plugin_fixer_Fix
    # block; or we haven't.
    #
    # In the first case, we need to load the correct file name of
    # the fix file from the config block for one of the potential
    # fixers. We select the fix based on a condition.
    #
    # In the second case, get the filename from the plugin_fixer_Fix
    # block.
    #
    # We return the Datahub::Factory->fixer with the correct filename already
    # loaded.
    ##
    if (!defined($self->condition)) {
        return Datahub::Factory->fixer($self->options->{'fixer'})->new(
            'file_name' => $self->options->{sprintf('fixer_%s', $self->options->{'fixer'})}->{'file_name'}
        );
    }
    # Loop over all possible fixers
    my $fix_file_name;
    foreach my $fixer (@{$self->options->{sprintf('fixer_%s', $self->options->{'fixer'})}->{'fixers'}}) {
        if ($self->options->{sprintf('fixer_%s', $fixer)}->{'condition'} eq $self->condition) {
            $fix_file_name = $self->options->{sprintf('fixer_%s', $fixer)}->{'file_name'};
            last;
        }
    }
    return Datahub::Factory->fixer($self->options->{'fixer'})->new(
        'file_name' => $fix_file_name
    );
}

sub _build_condition {
    my $self = shift;
    # Check if there is a condition
    if (!defined($self->options->{sprintf('fixer_%s', $self->options->{'fixer'})}->{'condition'})) {
                return undef;
            }
    return data_at($self->options->{sprintf('fixer_%s', $self->options->{'fixer'})}->{'condition'}, $self->item);
}

1;
