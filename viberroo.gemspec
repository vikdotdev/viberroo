require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name = 'viberroo'
  s.homepage = 'https://github.com/vikdotdev/viberroo'
  s.version = Viberroo::VERSION
  s.date = '2020-03-19'
  s.summary = 'Thin Viber REST API wrapper for Ruby.'
  s.authors = ['Viktor Habchak']
  s.email = 'vikdotdev@gmail.com'
  s.license = 'MIT'
  s.files = %w[
    lib/version.rb
    lib/viberroo.rb
    lib/message.rb
    lib/input.rb
    lib/response.rb
    lib/bot.rb
  ]
  s.require_paths = ['lib']
  s.add_dependency 'faraday', '~> 1.0.0'
  s.add_dependency 'recursive-open-struct', '~> 1.1.1'
end
