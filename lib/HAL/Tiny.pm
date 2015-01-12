package HAL::Tiny;
use 5.008001;
use strict;
use warnings;

use JSON qw/encode_json/;

our $VERSION = "0.01";

sub new {
    my ($class, %args) = @_;

    my ($state, $links, $embedded)
        = @args{qw/state links embedded/};

    return bless +{
        state    => $state,
        links    => $links,
        embedded => $embedded,
    }, $class;
}

sub as_hash {
    my ($self) = @_;

    my %hash;

    if (my $state = $self->{state}) {
        %hash = %{ $self->{state} };
    }

    if (my $links = $self->{links}) {
        my $v = +{};
        for my $rel (keys %$links) {
            $v->{$rel} = +{
                href => $links->{$rel},
            }
        }
        $hash{_links} = $v;
    }

    if (my $embedded = $self->{embedded}) {
        my $v = +{};
        for my $rel (keys %$embedded) {
            if (ref $embedded->{$rel} eq 'ARRAY') {
                my @hashed = map { $_->as_hash } @{$embedded->{$rel}};
                $v->{$rel} = \@hashed;
            } else {
                $v->{$rel} = $embedded->{$rel}->as_hash;
            }
        }
        $hash{_embedded} = $v;
    }

    return \%hash;
}

sub as_json {
    my ($self) = @_;
    my $hash = $self->as_hash;
    return encode_json($hash);
}


1;
__END__

=encoding utf-8

=head1 NAME

HAL::Tiny - Hypertext Application Language Encoder

=head1 SYNOPSIS

    use HAL::Tiny;

    my $resource = HAL::Tiny->new(
        state => +{
            currentlyProcessing => 14,
            shippedToday => 20,
        },
        links => +{
            self => '/orders',
            next => '/orders?page=2',
        },
        embedded => +{
            order => [
                HAL::Tiny->new(
                    state => +{ id => 10 },
                    links => +{ self => '/orders/10' },
                ),
                HAL::Tiny->new(
                    state => +{ id => 11 },
                    links => +{ self => '/orders/11' },
                )
            ],
        },
    );

    $resource->as_json;

=head1 DESCRIPTION

HAL::Tiny is a minimum implementation of Hypertext Application Language(HAL).

=head1 LICENSE

Copyright (C) Yuuki Furuyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yuuki Furuyama E<lt>addsict@gmail.comE<gt>

=cut

