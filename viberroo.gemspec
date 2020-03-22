Gem::Specification.new do |s|
  s.name = 'viberroo'
  s.homepage = 'https://github.com/vikdotdev/viberroo'
  s.version = '0.0.1'
  s.date = '2020-03-19'
  s.summary = 'Thin Viber REST API wrapper for ruby.'
  s.authors = ['Viktor Habchak']
  s.email = 'vikdotdev@gmail.com'
  s.files = %w[
    lib/viberroo.rb
    lib/message.rb
    lib/input.rb
    lib/user.rb
    lib/bot.rb
  ]
  s.license = 'MIT'

  s.add_dependency 'faraday', '~> 1.0.0'
end
