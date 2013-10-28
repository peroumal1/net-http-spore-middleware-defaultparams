package Net::HTTP::Spore::Middleware::DefaultParams;

# ABSTRACT: Middleware to set default params for every request made by
# a client 

use Moose; 
use Class::MOP::Class;
use Net::HTTP::Spore::Meta::Method; 
extends 'Net::HTTP::Spore::Middleware';

has default_params => ( 
    is => 'rw', 
    isa => 'HashRef',
    required => 1
);

sub call {
    my ( $self, $req ) = @_;
    $req->env->{'spore.params'}  = [ %{ +{ @{$req->env->{'spore.params'} || []}, %{$self->default_params} } } ];
}

# remove the 'required parameters' checking, so that explicit required
# parameters are set through the middleware

Net::HTTP::Spore::Meta::Method->meta->remove_method('has_required_params');
Net::HTTP::Spore::Meta::Method->meta->add_method('has_required_params' => sub { return 0 } );

1;

