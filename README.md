# NAME

HAL::Tiny - Hypertext Application Language Encoder

# SYNOPSIS

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

# DESCRIPTION

HAL::Tiny is ...

# LICENSE

Copyright (C) Yuuki Furuyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Yuuki Furuyama <addsict@gmail.com>
