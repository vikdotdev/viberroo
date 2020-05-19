# Viberroo
This Viber bot is a thin wrapper for Viber REST API, written in Ruby. It uses mostly the same parameters as the official API, but provides a more readable alternative to explicit http requests.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'viberroo', '~> 0.0.9'
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
During webhook setup you need to specify an URL signed by known CA. This might sound rather inconvenient, unless you use ngrok - fitting tool for such circumstance. Here's a [guide](https://developers.viber.com/blog/2017/05/24/test-your-bots-locally) on how to get started.

Rake task is good way of managing webhooks:
```bash
$ rails g task viber set_webhook remove_webhook
```
``` ruby
  # lib/tasks/viber.rake
  namespace :viber do
    task set_webhook: :environment do
      bot = Viberroo::Bot.new(token: 'YOUR_VIBER_API_TOKEN')

      params = {
        url: 'https://<your_ngrok_public_address>/viber',
        event_types: %w[conversation_started subscribed unsubscribed],
        send_name: true,
        send_photo: true
      }

      puts bot.set_webhook(params).body
    end

    task remove_webhook: :environment do
      bot = Viberroo::Bot.new(token: 'YOUR_VIBER_API_TOKEN')

      puts bot.remove_webhook(params).body
    end
  end
```
It's a good idea to hide your API token in an environment variable or something like Rails' credentials. We won't run our task just yet - during task execution API will make a request to our server to make sure it exists, and we'll need to handle that first. The `/viber` part in the `params[:url]` is pointing to the controller which we're about to create next.

### Controller
Generate a controller with something like `rails g controller viber callback` and point a route to it:
```ruby
  # config/routes.rb
  post '/viber' => 'viber#callback'
```

In our controller we'll need to initiate a `Viberroo::Response` object and pass it to new `Viberroo::Bot` instance, note that `params.permit!` is necessary to form a correct `Response` object.
```ruby
  # app/controllers/viber_controller.rb
  class ViberController < ApplicationController
    skip_before_action :verify_authenticity_token

    def callback
      @response = Viberroo::Response.init(params.permit!)
      @bot = Viberroo::Bot.new(token: 'YOUR_VIBER_API_TOKEN', response: @response)

      head :ok
    end
  end
```

At this point running `set_webhook` task should return `{ "status":0, "status_message":"ok", ... }`:
```bash
$ rake viber:set_webhook
```

From here we can fork the flow of execution based on event type as shown in `handle_event` method; when event type is 'message' - based on message text as shown in `handle_message` method. More information on callback events can be found in 'Callbacks' section in [API Documentation](https://developers.viber.com/docs/api/rest-bot-api/#callbacks)
``` ruby
  # app/controllers/viber_controller.rb
    ...
    def callback
      ...
      handle_event

      head :ok
    end

    private

    def handle_event
      case @response.event
      when 'message'
        handle_message
      when 'conversation_started'
        greet_user
      end
    end

    def handle_message
      case @response.message.text
      when '/start'
        choose_action
      when '/help'
        display_help
    end
  end
```

To respond back to the user `Viberroo::Bot` class is equipped with a method for each [message type](https://developers.viber.com/docs/api/rest-bot-api/#message-types). See method name/message type mapping in [documentation](#documentation).
``` ruby
  # app/controllers/viber_controller.rb
    ...

    def display_help
      @bot.send_message(text: 'Type /start to get started!')
    end
```

The Viber API allows sending a custom keyboard with predefined replies or actions. Such a keyboard can be attached to any message:
``` ruby
  # app/controllers/viber_controller.rb
  class ViberController < ApplicationController
    include Viberroo::Input
    ...

    def choose_action
      something = Button.reply({
        Columns: 3,
        Rows: 2,
        Text: 'Do Something',
        ActionBody: '/some_text_to_trigger_message_case'
      })

      nothing = Button.none({
        Columns: 3,
        Rows: 2,
        Text: 'Do Nothing'
      })

      answers = keyboard(Buttons: [something, nothing])
      @bot.send_message(text: 'What would you like to do?', keyboard: answers)
    end
```

Each button ActionType has a corresponding method inside `Viberroo::Input` module. `keyboard` method also comes from there. See Viber API [Button parameters](https://viber.github.io/docs/tools/keyboards/#buttons-parameters) section for parameter explanation and possibilities.

## Documentation
### Bot
`Bot` class has access to all methods that deal with requests to the Viber API. All of them send a Faraday POST request to a different _endpoint_. Some methods have _default parameters_ which can be appended or overridden by _params_. Each returns a [faraday response](https://www.rubydoc.info/gems/faraday/Faraday/Response).

#### **set\_webhook**(_params_)
_endpoint:_ /set_webhook\
_default parameters:_ none

#### **remove\_webhook**
_endpoint:_ /remove_webhook\
_default parameters:_ none

#### **send\_message**(_params_)
_endpoint:_ /remove_webhook\
_default parameters:_ `type: 'text'`

#### **send\_rich\_media**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'rich_media'`

#### **send\_location**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'location'`

#### **send\_picture**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'picture'`

#### **send\_video**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'video'`

#### **send\_file**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'file'`

#### **send\_contact**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'contact'`

#### **send\_url**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'url'`

#### **send\_sticker**(_params_)
_endpoint:_ /send_message\
_default parameters:_ `type: 'sticker'`

### Input
`Input` module methods are used as a declarative wrappers with predefined types for different UI elements.
Each has _default parameters_ which can be appended or overridden by _params_.

#### **keyboard**(_params_)
_default parameters:_ `Type: 'keyboard'`

### Input::Button
`Button` class methods can be coupled with `Input.keyboard` or used on their own. Each has _default parameters_ which can be appended or overridden by _params_.

#### **self.reply**(_params_)
_default parameters:_ `ActionType: 'reply'`

#### **self.url**(_params_)
_default parameters:_ `ActionType: 'open-url'`

#### **self.location\_picker**(_params_)
_default parameters:_ `ActionType: 'location-picker'`

#### **self.share\_phone**(_params_)
_default parameters:_ `ActionType: 'share-phone'`

#### **self.none**(_params_)
_default parameters:_ `ActionType: 'none'`

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### TODO
* Implement following Viber API features:
  * [Broadcast Message](https://developers.viber.com/docs/api/rest-bot-api/#broadcast-message)
  * [Get Account Info](https://developers.viber.com/docs/api/rest-bot-api/#get-account-info)
  * [Get User Details](https://developers.viber.com/docs/api/rest-bot-api/#get-user-details)
  * [Get Online](https://developers.viber.com/docs/api/rest-bot-api/#get-online)
* add proper API response logging
* add errors for required parameters for each request

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/vikdotdev/viberroo.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
