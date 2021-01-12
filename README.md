# Viberroo
This Viber bot is a thin wrapper for Viber REST API, written in Ruby. It uses mostly the same parameters as the official API, and provides a more readable alternative to explicit http requests.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'viberroo', '~> 0.3.3'
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
```ruby
  # lib/tasks/viber.rake
  namespace :viber do
    task set_webhook: :environment do
      Viberroo::Bot.new.set_webhook(
        url: 'https://<your_ngrok_public_address>/viber',
        event_types: %w[conversation_started subscribed unsubscribed],
        send_name: true,
        send_photo: true
      )
    end

    task remove_webhook: :environment do
      Viberroo::Bot.new.remove_webhook
    end
  end
```
We won't run our task just yet - during task execution API will make a callback request to our server to make sure it exists, and we'll need to handle that first. Also you'll need to provide your Viber API token:
```ruby
# config/initializers/viberroo.rb

Viberroo.configure do |config|
  config.auth_token = '<your_viber_bot_api_token>'
end
```

### Controller
Generate a controller with `rails g controller viber callback` and point a route to it:
```ruby
# config/routes.rb

post '/viber' => 'viber#callback'
```

```ruby
# app/controllers/viber_controller.rb

class ViberController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    @response = Viberroo::Response.new(params.permit!)
    @bot = Viberroo::Bot.new(response: @response)

    head :ok
  end
end
```
Note that `params.permit!` is necessary to form a correct `Response` object.

At this point running `set_webhook` task should return `{ "status":0, "status_message":"ok", ... }`:
```bash
$ rake viber:set_webhook
```

From here we can fork the flow of execution based on event type as shown in `handle_event` method. For example when event type is 'message', we can fork the flow based on message text as shown in `handle_message` method. More information on callback events can be found in 'Callbacks' section in [API Documentation](https://developers.viber.com/docs/api/rest-bot-api/#callbacks)
```ruby
  # app/controllers/viber_controller.rb
  # ...

  def callback
    # ...
    handle_event

    head :ok
  end

  private

  def handle_event
    case @response.params.event
    when 'message'
      handle_message
    when 'conversation_started'
      greet_user
    end
  end

  def handle_message
    case @response.params.message.text
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
```ruby
  # app/controllers/viber_controller.rb

  # ...

  def display_help
    message = Viberroo::Message.plain(text: 'Type /start to get started!')
    @bot.send(message: message)
  end
```

The Viber API allows sending a custom keyboard with predefined replies or actions. Such a keyboard can be attached to any message:
```ruby
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
  end
```

Each buttons' `ActionType` has a corresponding method inside `Viberroo::Input` module. `keyboard` method also comes from there. See Viber API [Button parameters](https://viber.github.io/docs/tools/keyboards/#buttons-parameters) section for parameter explanation and possibilities.

## Documentation
Documentation can be found on [rubygems](https://www.rubydoc.info/gems/viberroo/0.3.2/Viberroo), or generated locally by cloning the repository and running `yard` in the root of the project.

## Development
After checking out the repository, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, create a tag
for a new version, and then merge to master, GitHub actions will take care of running specs and pushing to [rubygems.org](https://rubygems.org).


## TODO
* change method signatures:
  * set_webhook -> make false as default value for send_name and send_photo
  * send -> keyboard to nil
  * remove safe navigation to extend ruby version compatibility
  * location_button -> change to simple lon:, lat: params
  * picture_message -> change to url:, text: nil, thumbnail: nil
  * video_message -> change to url:, size:, duration: nil, thumbnail: nil
  * file_message -> change url:, size:, name:
  * contact message -> change name:, phone:
  * url_message -> change to single unnamed parameter
  * sticker_message -> change to id:
  * rich_media_message -> change to columns:, rows:, buttons:, alt: nil
  * rename config to configuration


## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/vikdotdev/viberroo.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
