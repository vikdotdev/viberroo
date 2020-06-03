# Viberroo
This Viber bot is a thin wrapper for Viber REST API, written in Ruby. It uses mostly the same parameters as the official API, but provides a more readable alternative to explicit http requests.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'viberroo', '~> 0.2.1'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install viberroo
```

## Usage
First of all get acquainted with 'Getting Started' section on [Viber REST API page](https://developers.viber.com/docs/api/rest-bot-api/#get-started). There you'll find a link to create a bot. Read about webhooks in the relevant section and come back here to setup one for yourself.

### Webhooks
During webhook setup you need to specify an URL signed by known CA. NGrok is _the_ tool to help in such predicament - here's a [guide](https://developers.viber.com/blog/2017/05/24/test-your-bots-locally) on how to get started.

Rake task is good way of managing webhooks:
```bash
$ rails g task viber set_webhook remove_webhook
```
``` ruby
  # lib/tasks/viber.rake
  namespace :viber do
    task set_webhook: :environment do
      Viberroo::Bot.new.set_webhook!(
        url: 'https://<your_ngrok_public_address>/viber',
        event_types: %w[conversation_started subscribed unsubscribed],
        send_name: true,
        send_photo: true
      )
    end

    task remove_webhook: :environment do
      Viberroo::Bot.new.remove_webhook!
    end
  end
```
We won't run our task just yet - during task execution API will make a callback request to our server to make sure it exists, and we'll need to handle that first. Also you'll need to provide your Viber API token:
``` ruby
# config/initializers/viberroo.rb

Viberroo.configure do |config|
  config.auth_token = '<your_viber_bot_api_token>'
end
```

### Controller
Generate a controller with something like `rails g controller viber callback` and point a route to it:
```ruby
# config/routes.rb

post '/viber' => 'viber#callback'
```

```ruby
# app/controllers/viber_controller.rb

class ViberController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    @callback = Viberroo::Callback.new(params.permit!)
    @bot = Viberroo::Bot.new(token: 'YOUR_VIBER_API_TOKEN', callback: @callback)

    head :ok
  end
end
```
Note that `params.permit!` is necessary to form a correct `Callback` object.

At this point running `set_webhook` task should return `{ "status":0, "status_message":"ok", ... }`:
```bash
$ rake viber:set_webhook
```

From here we can fork the flow of execution based on event type as shown in `handle_event` method. For example when event type is 'message', we can fork the flow based on message text as shown in `handle_message` method. More information on callback events can be found in 'Callbacks' section in [API Documentation](https://developers.viber.com/docs/api/rest-bot-api/#callbacks)
``` ruby
  # app/controllers/viber_controller.rb
  ...
  def callback
    # ...
    handle_event

    head :ok
  end

  private

  def handle_event
    case @callback.params.event
    when 'message'
      handle_message
    when 'conversation_started'
      greet_user
    end
  end

  def handle_message
    case @callback.params.message.text
    when '/start'
      choose_action
    when '/help'
      display_help
    end
  end

  def greet_user
    message = Viberroo::Message.plain(text: 'Hello there! Type /start to get started.')
    @bot.send(message: message)
  end
```

To respond back to the user `Viberroo::Bot` class is equipped with `send` method which accepts various [message types](https://developers.viber.com/docs/api/rest-bot-api/#message-types). See _method name/message type_ mapping in [documentation](#documentation).
``` ruby
  # app/controllers/viber_controller.rb

  # ...

  def display_help
    message = Viberroo::Message.plain(text: 'Type /start to get started!')
    @bot.send(message: message)
  end
```

The Viber API allows sending a custom keyboard with predefined replies or actions. Such a keyboard can be attached to any message:
``` ruby
  # app/controllers/viber_controller.rb
  class ViberController < ApplicationController
    include Viberroo

    # ...

    def choose_action
      something = Input.reply_button({
        Columns: 3,
        Rows: 2,
        Text: 'Do Something',
        ActionBody: '/some_text_to_trigger_message_case'
      })

      google = Input.url_button({
        Columns: 3,
        Rows: 2,
        Text: 'Go to google',
        ActionBody: 'google.com'
      })

      message = Message.plain(text: 'What would you like to do?')
      keyboard = Input.keyboard(Buttons: [something, google])
      @bot.send(message: message, keyboard: keyboard)
    end
```

Each buttons' `'ActionType'` has a corresponding method inside `Viberroo::Input` module. `keyboard` method also comes from there. See Viber API [Button parameters](https://viber.github.io/docs/tools/keyboards/#buttons-parameters) section for parameter explanation and possibilities.

## Documentation
### Bot
Is responsible for sending requests to Viber API. Each request sends a Faraday POST request to a particular endpoint. There are a _bang_ variant for each method. Each regular method returns a [faraday response](https://www.rubydoc.info/gems/faraday/Faraday/Response). Each _bang_ method returns parsed response body.

#### `initialize(token: nil, callback: {})`
* Parameters
  * `token` `<String>` optional. Normally should be provided by `Viberroo.configure.auth_token` but is available here as a shortcut when predefined configuration is undesirable. Takes precedence over `Viberroo.configure.auth_token`.
  * `callback` `<Hash>` optional.

#### `set_webhook(url:, event_types: nil, send_name: nil, send_photo: nil)`
* Parameters
  * `url` `<String>` Account webhook URL to receive callbacks.
  * `event_types` `<Array>` Indicates the types of events that the bot would receive from API. **API Default**: `%w[delivered seen failed subscribed unsubscribed conversation_started]`.
  * `send_name` `<TrueClass> | <FalseClass>` Indicates whether or not the bot should receive the user name. **API Default** `false`.
  * `send_photo` `<TrueClass> | <FalseClass>` Indicates whether or not the bot should receive the user photo. **API Default**: `false`.
* Returns: `<Faraday::Response>`
* Endpoint: `/set_webhook`

#### `set_webhook!(url:, event_types: nil, send_name: nil, send_photo: nil)`
Same as `set_webhook` except returns parsed response body of type `<Hash>`.

#### `remove_webhook`
* Returns: `<Faraday::Response>`
* Endpoint: `/set_webhook`

#### `remove_webhook!`
Same as `remove_webhook` except returns parsed response body of type `<Hash>`.

#### `send(message:, keyboard: {})`
* Parameters
  * `message` `<Hash>` A message to send.
    * `sender` `<Hash>`
      * `name` `<String>` required. The sender’s name to display, max 28 characters.
  * `keyboard` `<Hash>` Optional keyboard.
* Returns: `<Faraday::Response>`
* Endpoint: `/send_message`

#### `send!(message:, keyboard: {})`
Same as `send` except returns parsed response body of type `<Hash>`.

#### `broadcast_message(message:, to:)`
Maximum total JSON size of the request is 30kb. The maximum list length is 300 receivers. The Broadcast API is used to send messages to multiple recipients with a rate limit of 500 requests in a 10 seconds window.
* Parameters
  * `message` `<Hash>` A message to broadcast.
  * `to` `<String[]>` List of user ids to broadcast to. Specified users need to be subscribed.
* Returns: `<Faraday::Response>`
* Endpoint: `/broadcast_message`

#### `broadcast_message!(message:, to:)`
Same as `broadcast_message` except returns parsed response body of type `<Hash>`.

#### `get_account_info`
* Returns: `<Faraday::Response>`
* Endpoint: `/get_account_info`

#### `get_account_info!`
Same as `get_account_info` except returns parsed response body of type `<Hash>`.

#### `get_user_details(id:)`
* Parameters
  * `id` `<String>` Subscribed user id.
* Returns: `<Faraday::Response>`
* Endpoint: `/get_user_details`

#### `get_user_details!(id:)`
Same as `get_user_details` except returns parsed response body of type `<Hash>`.

#### `get_online(ids:)`
* Parameters
  * `ids` `<String[]>` Subscribed user ids, maximum of 100 of them per request.
* Returns: `<Faraday::Response>`
* Endpoint: `/get_user_details`

#### `get_online(ids:)`
Same as `get_online` except returns parsed response body of type `<Hash>`.

### Message
`Message` module methods are used as a declarative wrappers with predefined types for each message type Viber API offers.

#### `plain(params)`
* Parameters
  * `params` `<Hash>`
    * `type` `<String>` required. **Default**: `'text'`.
    * `text` `<String>` required.
* Returns: `<Hash>`

#### `rich(params)`
The Rich Media message type allows sending messages with pre-defined layout, including height (rows number), width (columns number), text, images and buttons. Consult [official documentation](https://developers.viber.com/docs/api/rest-bot-api/#rich-media-message--carousel-content-message) for more details.
* Parameters
  * `params` `<Hash>`
    * `type` `<String>` required. **Default**: `'rich_media'`
    * `rich_media` `<Hash>`
      * `ButtonsGroupColumns` `<Hash>` Number of columns per carousel content block. Possible values 1 - 6. **API Default**: 6.
      * `ButtonsGroupRows` `<Hash>` Number of rows per carousel content block. Possible values 1 - 7. **API Default**: 7.
      * `Buttons` `<Hash>` Array of buttons. Max of 6 * `ButtonsGroupColumns` * `ButtonsGroupRows`.
    * `alt_text` `<String>` Backward compatibility text, limited to 7000 characters.
* Returns: `<Hash>`

#### `location(params)`
* Parameters
  * `params` `<Hash>`
    * `type` `<String>` required. **Default**: `'location'`.
    * `location` `<Hash>` required.
      * `lat` `<String>` required. Latitude.
      * `lon` `<String>` required. Longitude.
* Returns: `<Hash>`

#### `picture(params)`
* Parameters
  * `params` `<Hash>`
    * `type` `<String>` required. **Default**: `'picture'`.
    * `media` `<String>` required. Allowed extensions: .jpeg, .png .gif. Animated GIFs can be sent as URL messages or file messages.
    * `text` `<String>` optional. Max 120 characters.
    * `thumbnail` `<String>` optional. URL of a reduced size image. Recomended 400x400.
* Returns: `<Hash>`

#### `video(params)`
* Parameters
  * `type` `<String>` required. **Default**: `'video'`.
  * `media` `<String>` required. URL of the video (MP4, H264). Max size is 26MB. Only MP4 and H264 are supported.
  * `size` `<Integer>` required. Size of the video in bytes.
  * `duration` `<Integer>` Video duration in seconds; will be displayed to the receiver. Max 180 seconds.
  * `thumbnail` `<String>` URL of a reduced size image. Max size 100 kb. Recommended: 400x400. Only JPEG format is supported.
* Returns: `<Hash>`

#### `file(params)`
* Parameters
  * `type` `<String>` required. **Default**: `'file'`.
  * `media` `<String>` required. URL of the file. Max size is 50MB. See [forbidden file](https://developers.viber.com/docs/api/rest-bot-api/#forbiddenFileFormats) formats for unsupported file types.
  * `size` `<Integer>` required. Size of the video in bytes.
  * `file_name` `<String>` required. File name should include extension. Max 256 characters (including file extension).
* Returns: `<Hash>`

#### `contact(params)`
* Parameters
  * `type` `<String>` required. **Default**: `'contact'`.
  * `contact` `<Hash>` required.
    * `name` `<String>` required. Name of the contact. Max 28 characters.
    * `phone_number` `<String>` required. Phone number of the contact. Max 18 characters.
* Returns: `<Hash>`

#### `url(params)`
* Parameters
  * `type` `<String>` required. **Default**: `'url'`.
  * `media` `<String>` required. Max 2000 characters.
* Returns: `<Hash>`

#### `sticker(params)`
* Parameters
  * `type` `<String>` required. **Default**: `'sticker'`.
  * `sticker_id` `<Integer>` required. [Reference](https://viber.github.io/docs/tools/sticker-ids/).
* Returns: `<Hash>`

### Input
`Input` module methods are used as a declarative wrappers with predefined types for UI elements such as buttons and keyboards. Buttons can be combined with a keyboard or used in rich messages. Only basic parameters are specified in this documentation, to see all possibilities please consult official Viber API documentation for [keyboard](https://viber.github.io/docs/tools/keyboards/#general-keyboard-parameters), and for [buttons](https://viber.github.io/docs/tools/keyboards/#buttons-parameters).

#### `keyboard(params)`
Only `'reply'` and `'open-url'` button types are available in keyboard.
* Parameters
  * `keyboard` `<Hash>`
    * `Type` `<String>` required. **Default**: `'keyboard'`.
    * `Buttons` `<Hash>` required. Array containing all keyboard buttons by order.
* Returns: `<Hash>`

#### `reply_button(params)`
* Parameters
  * `ActionType` `<String>` **Default**: `'reply'`.
  * `Text` `<String>` Button text.
  * `Columns` `<Integer>` Button width in columns. Possible values 1-6. **API Default**: 6.
  * `Rows` `<Integer>` Button width in rows. Possible values 1-2. **API Default**: 1.
* Returns: `<Hash>`

All the other buttons have the exactly the same signature except of `ActionType` parameter.

#### `url_button(params)`
* `ActionType` `<String>` **Default**: `'open-url'`.

#### `location_picker_button(params)`
* `ActionType` `<String>` **Default**: `'location-picker'`.

#### `share_phone_button(params)`
* `ActionType` `<String>` **Default**: `'share-phone'`.

#### `none_button(params = {})`
* `ActionType` `<String>` **Default**: `'none'`.

### Callback
Wraps callback response and provides helper methods for easier parameter access.

#### `initialize(params)`
* Parameters
  * `params` `<Hash>` parameters from API callback.

#### `params`
* Returns `<RecursiveOpenStruct>` callback parameters.

#### `user_id`
 Location of user id in response object depends on callback event type. This method puts it in one place, independent of callback event type. Original user id params remain available in `params`.
* Returns `<String>` user id.

## Development
After checking out the repository, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, create a tag
for a new version, and then merge to master, GitHub actions will take care of running specs and pushing to [rubygems.org](https://rubygems.org).

### TODO
* make dependencies optional

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/vikdotdev/viberroo.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
