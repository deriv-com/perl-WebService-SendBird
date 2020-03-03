use strict;
use warnings;

use WebService::SendBird;
use Getopt::Long;
use Data::Dumper;

use Digest::MD5 qw(md5_hex);

my ($app_id, $api_token, $action);

GetOptions ("id=s" => \$app_id,
            "token=s"   => \$api_token,
            "action=s"  => \$action);

$action //= 'create';

die "One of the argument is missed: id, token, action" unless $app_id || $api_token || $action;

my $api = WebService::SendBird->new(app_id => $app_id, api_token => $api_token);

my $uniq_postfix = md5_hex($$ .time) =~ s/\w{10}//r;

if ($action eq 'create') {
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


    my $group_chat = $api->create_group_chat(
        channel_url => 'order_chat_' . $uniq_postfix,
        user_ids => [ $client->user_id, $advertiser->user_id ],
        name => 'Chat for order ' . $uniq_postfix,
    );


    print 'Order Chat url: ', $group_chat->channel_url, "\n";
    print "-----------------\n";
}
