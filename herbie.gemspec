Gem::Specification.new do |spec|
  spec.name        = 'herbie'
  spec.version     = '0.1.2'
  spec.date        = '2011-10-10'
  spec.summary     = "herbie"
  spec.description = "Lovable HTML view helpers for use with ERB."
  spec.authors     = ["Ben Darlow"]
  spec.email       = 'ben@kapowaz.net'
  spec.files       = Dir["lib/**/*"]
  spec.test_files  = Dir["spec/*"]
  spec.homepage    = 'http://github.com/kapowaz/herbie'
  spec.required_ruby_version = '>= 1.9.2'
  spec.add_development_dependency 'rspec', ['~> 2.6']
  spec.add_development_dependency 'colored'
end