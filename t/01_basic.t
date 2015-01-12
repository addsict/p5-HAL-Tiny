use strict;
use warnings;
use Test::More;

use HAL::Tiny;
use JSON qw/decode_json/;

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

note explain $resource->as_json;
is_deeply(decode_json($resource->as_json), decode_json(q!
{
    "currentlyProcessing": 14,
    "shippedToday": 20,
    "_links": {
        "self": { "href": "/orders" },
        "next": { "href": "/orders?page=2" }
    },
    "_embedded": {
        "order": [{
            "id": 10,
            "_links": {
                "self": { "href": "/orders/10" }
            }
        }, {
            "id": 11,
            "_links": {
                "self": { "href": "/orders/11" }
            }
        }]
    }
}
!));

done_testing;
