package WebService::SendBird::Message;

use strict;
use warnings;

use Carp;
use JSON::PP;

=head1 NAME

WebService::SendBird::Message - Base class for SendBird Message

=head1 SYNOPSIS

 use WebService::SendBird::User;

 my $user = WebService::SendBird::User->new(
     api_client => $api,
     user_id    => 'my_chat_user_1',
 );

 $user->update(nickname => 'cucumber');

 my $token_data = $user->issue_session_token;

=head1 DESCRIPTION

Class for SendBird User. Information about structure could be found at L<API Documentation|https://docs.sendbird.com/platform/user>

=cut

use constant REQUIRED_FIELDS => qw(
    api_client
    type
);

use constant OPTIONAL_FIELDS => qw(
    custom_type
    data
    send_push
    mention_type
    mentioned_user_ids
    is_silent
    sorted_metaarray
    created_at
    dedup_id
    user_id
    message
    send_push
    mark_as_read
    file
    url
    file_name
    file_size
    file_type
    thumbnails
    require_auth
);

{
    no strict 'refs';
    for my $field (REQUIRED_FIELDS, OPTIONAL_FIELDS) {
        *{ __PACKAGE__ . '::' . $field } = sub { shift->{$field} };
    }
}

=head2 new

Creates an instance of SendBird User

=over 4

=item * C<api_client> - SendBird API client L<WebService::SendBird>.

=item * C<user_id> - Unique User Identifier

=back

=cut

sub new {
    my ($cls, %params) = @_;

    my $self = +{};
    $self->{$_} = delete $params{$_} or Carp::croak "$_ is missed" for (REQUIRED_FIELDS);

    $self->{$_} = delete $params{$_} for (OPTIONAL_FIELDS);

    return bless $self, $cls;
}

=head2 Getters

=over 4

=item * C<api_client>

=item * C<user_id>

=item * C<phone_number>

=item * C<has_ever_logged_in>

=item * C<session_tokens>

=item * C<access_token>

=item * C<discovery_keys>

=item * C<is_online>

=item * C<last_seen_at>

=item * C<nickname>

=item * C<profile_url>

=item * C<metadata>

=back

=cut

1;
