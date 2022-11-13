# NAME

WebService::SendBird - unofficial support for the Sendbird API

# SYNOPSIS

    use WebService::SendBird;

    my $api = WebService::SendBird->new(
        api_token => 'You_Api_Token_Here',
        app_id    => 'You_App_ID_Here',
    );

    my $user = $api->create_user(
        user_id     => 'my_chat_user_1',
        nickname    => 'pumpkin',
        profile_url => undef,
    );

    my $chat = $api->create_group_chat(
        user_ids => [ $user->user_id ],
    );

# DESCRIPTION

Basic implementation for SendBird Platform API client, which helps to create users and group chats.

More information at [Platform API Documentation](https://docs.sendbird.com/platform)

# METHODS

## new

Creates an instance of API client

- `api_token` - Master or Secondary API Token.
- `app_id` - Sendbird Application ID.
- `api_url` - URL to API end point. By default it will be generated from app\_id.
- `ua` - Custom http client for API requests, should have the same interface like [Mojo::UserAgent](https://metacpan.org/pod/Mojo%3A%3AUserAgent).
- `timeout` - request timeout, default value 15 seconds

## app\_id

Returns Application ID.

## api\_token

Returns API Token

## api\_url

Returns API endpoint url

## timeout

Return http request timeout value.

## ua

Return User Agent for http request.

## http\_headers

Returns headers for API request.

## request

Sends request to Sendbird API

## create\_user

Creates a user at SendBird

- `user_id` - Unique User Identifier
- `nickname` - User nickname
- `profile_url` - user profile url. Could be `undef` or empty.

Information about extra parameters could be found at [API Documentation](https://docs.sendbird.com/platform/user#3_create_a_user)

Method returns an instance of [WebService::SendBird::User](https://metacpan.org/pod/WebService%3A%3ASendBird%3A%3AUser)

## view\_user

Gets information about a user from SendBird

- `user_id` - Unique User Identifier

Information about extra parameters could be found at [API Documentation](https://docs.sendbird.com/platform/user#3_view_a_user)

Method returns an instance of [WebService::SendBird::User](https://metacpan.org/pod/WebService%3A%3ASendBird%3A%3AUser)

## create\_group\_chat

Creates a group chat room

Information about parameters could be found at [API Documentation](https://docs.sendbird.com/platform/group_channel#3_create_a_channel)

Method returns an instance of [WebService::SendBird::GroupChat](https://metacpan.org/pod/WebService%3A%3ASendBird%3A%3AGroupChat)

## view\_group\_chat

Gets information about a group chat from SendBird

- `channel_url` - Unique Chat Identifier

Information about parameters could be found at [API Documentation](https://docs.sendbird.com/platform/group_channel#3_view_a_channel)

Method returns an instance of [WebService::SendBird::GroupChat](https://metacpan.org/pod/WebService%3A%3ASendBird%3A%3AGroupChat)
