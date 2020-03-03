use strict;
use warnings;

use WebService::SendBird;
use Getopt::Long;
use Data::Dumper;

use Digest::MD5 qw(md5_hex);

my ($app_id, $api_token);

GetOptions ("id=s" => \$app_id,
            "token=s"   => \$api_token);


die "One of the argument is missed: id, token" unless $app_id || $api_token;

my $api = WebService::SendBird->new(app_id => $app_id, api_token => $api_token);

my $uniq_postfix = md5_hex($$ .time) =~ s/\w{10}//r;

my $client = $api->create_user(
    user_id => 'client_' . $uniq_postfix,
    nickname => 'Test Client',
    profile_url => undef,
);
print "-----------------\n";
print 'Client user_id: ', $client->user_id, "\n";

my $client_token_data = $client->issue_session_token;

print 'Client session token: ', $client_token_data->{session_token}, "\n";

my $advertiser = $api->create_user(
    user_id => 'advertiser_' . $uniq_postfix,
    nickname => 'Test Advertiser',
    profile_url => undef,
);

print "-----------------\n";
print 'Advertiser user_id ', $advertiser->user_id, "\n";

my $advertiser_token_data = $advertiser->issue_session_token;

print 'Advertiser session token: ', $advertiser_token_data->{session_token}, "\n";
print "-----------------\n";


my $chat = $api->create_group_chat(
    channel_url => 'order_chat_' . $uniq_postfix,
    user_ids => [ $client->user_id, $advertiser->user_id ],
    name => 'Chat for order ' . $uniq_postfix,
);


print 'Order Chat url: ', $chat->channel_url, "\n";
print "-----------------\n";

$chat->send_admin_message(
    message => 'Order has benn created',
    mentioned_user_ids => [ $advertiser->user_id ],
);

$chat->send_admin_message(
    message => 'Order has been confirmed by ' . $advertiser->nickname,
    mentioned_user_ids => [ $client->user_id ],
);

$chat->send_admin_message(
    message => 'Order has been completed',
    mentioned_user_ids => [ $client->user_id, $advertiser->user_id ],
);

print '3 notifications were added to channel ', $chat->channel_url, "\n";
print "-----------------\n";

