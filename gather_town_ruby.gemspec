Gem::Specification.new do |s|
  s.name                  = 'gather_town_ruby'
  s.version               = '0.0.1.pre'
  s.summary               = "A Ruby library for interfacing with Gather Town via their API."
  s.description           = "Gives you an easy way to read and write to maps and spaces within Gather Town."
  s.authors               = ["Greg Matthew Crossley"]
  s.email                 = 'greg@neomindlabs.com'
  s.files                 = ["lib/gather_town_ruby.rb"]
  s.license               = 'MIT'
  s.required_ruby_version = '>= 2.7.0'
  s.add_dependency          'httparty', '~> 0.17'
end