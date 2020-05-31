require_relative 'lib/viberroo/version'

Gem::Specification.new do |s|
  s.name = 'viberroo'
  s.homepage = 'https://github.com/vikdotdev/viberroo'
  s.version = Viberroo::VERSION
  s.date = '2020-03-19'
  s.summary = 'Viber bot for Ruby.'
  s.authors = ['Viktor Habchak']
  s.email = 'vikdotdev@gmail.com'
  s.license = 'MIT'
  s.files = %w[
    lib/viberroo.rb
    lib/viberroo/version.rb
    lib/viberroo/message.rb
    lib/viberroo/input.rb
    lib/viberroo/callback.rb
    lib/viberroo/bot.rb
  ]
  s.require_paths = ['lib']
  s.add_dependency 'faraday', '~> 1.0.0'
  s.add_dependency 'recursive-open-struct', '~> 1.1.1'
end
