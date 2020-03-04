use strict;
use warnings;

use WebService::SendBird;
use Getopt::Long;
use Data::Dumper;

use Digest::MD5 qw(md5_hex);

my ($app_id, $api_token, $channel_url);

GetOptions ("app_id=s" => \$app_id,
            "token=s"   => \$api_token,
            "chat=s" => \$channel_url,
);


die "One of the argument is missed: app_id, token" unless $app_id || $api_token;


my $api = WebService::SendBird->new(app_id => $app_id, api_token => $api_token);

unless ($channel_url) {
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

    $channel_url = $chat->channel_url;

    print 'Order Chat url: ', $chat->channel_url, "\n";
    print "-----------------\n";

    $chat->send_admin_message(
        message => 'Order has benn created',
        mentioned_user_ids => [ $advertiser->user_id ],
    );

    $chat->send_message(
        message_type => 'MESG',
        user_id => $client->user_id,
        message => 'I sent money to you. Transaction id is #12329847234, Could you check it?',
    );

    $chat->send_message(
        message_type => 'FILE',
        user_id => $client->user_id,
        url => 'https://www.yourhappytour.com/event/golden_gate_bridge_20181210.png',
        file_name => "transaction.jpg",
        file_type => "jpg",
        custom_field => "Here is a photo of bank slip",
    );

    $chat->send_admin_message(
        message => 'Order has been confirmed by ' . $advertiser->nickname,
        mentioned_user_ids => [ $client->user_id ],
    );

    $chat->send_message(
        message_type => 'MESG',
        user_id => $advertiser->user_id,
        message => 'Got it, thx!',
    );

    $chat->send_admin_message(
        message => 'Order has been completed',
        mentioned_user_ids => [ $client->user_id, $advertiser->user_id ],
    );

    print " Chat messages were generated\n";
    print "-----------------\n\n\n\n";

}

my $chat = WebService::SendBird::GroupChat->new(channel_url => $channel_url, api_client => $api);

my @messages = @{ $chat->get_messages(message_ts => 0) };


for my $msg (@messages) {

    if ( $msg->type eq 'ADMM' ) {
        print "-----------------\n";
        print 'P2P Cashier: ' . $msg->message . "\n";
        print "-----------------\n";
        next;
    }

    if ($msg->type eq 'MESG') {
        print "-----------------\n";
        print $msg->user->nickname . ': ' .  $msg->message . "\n";
        print "-----------------\n";
        next;
    }

    if ($msg->type eq 'FILE') {
        print "-----------------\n";
        print 'User ' . $msg->user->nickname . ' sent a file ['
            . $msg->file->{name} . '](' . $msg->file->{url} . ')'
            . ' with a comment: ' . $msg->file->{data} ."\n";
        print "-----------------\n";

        next;
    }

    die 'Unknow type of message: ' . Dumper($msg);
}
