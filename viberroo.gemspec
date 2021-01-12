require_relative 'lib/viberroo/version'

Gem::Specification.new do |s|
  s.name = 'viberroo'
  s.homepage = 'https://github.com/vikdotdev/viberroo'
  s.version = Viberroo::VERSION
  s.date = '2020-03-19'
  s.summary = 'Viber bot for Ruby / Rails.'
  s.authors = ['Viktor Habchak']
  s.email = 'vikdotdev@gmail.com'
  s.license = 'MIT'
  s.files = %w[
    lib/viberroo.rb
    lib/viberroo/version.rb
    lib/viberroo/configuration.rb
    lib/viberroo/message.rb
    lib/viberroo/input.rb
    lib/viberroo/response.rb
    lib/viberroo/bot.rb
  ]
  s.required_ruby_version = '>= 2.3'
  s.require_paths = ['lib']
  s.add_dependency 'recursive-open-struct', '~> 1.1.1'
end
