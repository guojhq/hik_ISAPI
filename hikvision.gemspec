require_relative 'lib/hikvision/version'

Gem::Specification.new do |s|
  s.name = 'hikvision'
  s.bindir = 'exe'
  s.executables << 'hikvision'
  s.version = Hikvision::VERSION
  s.summary = 'Ruby Hikvision ISAPI Interface'
  s.authors = ['guopipi']
  s.files = Dir['{exe,lib}/**/*.rb']
  s.homepage = 'https://github.com/guojhq/hik_ISAPI.git'
  s.license = 'MIT'

  s.add_dependency 'gli', '~> 2.21'
  s.add_dependency 'httparty', '~> 0.21'
  s.add_dependency 'nokogiri', '~> 1.14'
end
