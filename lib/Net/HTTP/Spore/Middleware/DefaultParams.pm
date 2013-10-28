package Net::HTTP::Spore::Middleware::DefaultParams;

# ABSTRACT: Middleware to set default params for every request made by a spore client
use Moose;
extends 'Net::HTTP::Spore::Middleware';


# remove the 'required parameters' checking, so that explicit required
# parameters are set through the middleware
# added also a 'SPORE_META' env variable, so that if you have a custom
# spore namespace, this is still applicable
BEGIN {
    my $meta = "Net::HTTP::Spore::Meta::Method";
    if ( defined( $ENV{SPORE_META} ) ) {
        $meta = $ENV{SPORE_META};
    }
    $meta->meta->remove_method('has_required_params');
    $meta->meta->add_method( 'has_required_params' => sub { return 0 } );
}


has default_params => (
    is       => 'rw',
    isa      => 'HashRef',
    required => 1
);

# when receiving the client, remove 'has_required_params' on it

sub call {
    my ( $self, $req ) = @_;
    $req->env->{'spore.params'} = [
        %{  +{  %{ $self->default_params },
                @{ $req->env->{'spore.params'} || [] }
            }
        }
    ];
}
1;

=pod 

=head1 NAME 

    Net::HTTP::Spore::Middleware::DefaultParams -  Middleware to set default parameters 
    for every request made by a spore client

=head1 SYNOPSIS
    my $client = Net::HTTP::Spore->new_from_spec('api.json'); 
    # foo=bar and blah=baz will be passed on each request. 
    $client->enable('DefaultParams', default_params => { foo => 'bar', blah => 'baz' }); 

=head1 WARNINGS 
    This middleware disables the checking of required parameters, so be sure of what you are doing !

=cut


