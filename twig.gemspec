Gem::Specification.new do |s|
  s.name = 'twig'
  s.version = '0.0.1'
  s.authors = ['Matthijs van der Vleuten']
  s.email = ['zr40.nl@gmail.com']
  s.homepage = 'http://github.com/zr40/twig'
  s.summary = 'Branching code coverage for Rubinius'
  s.description = 'Twig is a branching code coverage tool for Rubinius.'
  s.platform = Gem::Platform::new ['universal', 'rubinius']

  s.files = %w( README.markdown CHANGELOG.markdown LICENSE )
  s.executables = ['twig']
  s.files += Dir['lib/**/*.rb'] + ['bin/twig']
end
