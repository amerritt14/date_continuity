Gem::Specification.new do |s|
  s.name        = "date_continuity"
  s.version     = "0.1.1"
  s.summary     = "A gem to handle calculating start/end dates based on a duration and frequency"
  s.description = "Calculate fields based on a minimum set of information."
  s.authors     = ["Andrew Merritt"]
  s.email       = "andrew.w.merritt@gmail.com"
  s.files       = ["lib/date_continuity.rb"]
  s.homepage    = "https://rubygems.org/gems/date_continuity"
  s.license     = "MIT"
  s.add_dependency 'activesupport', '> 5.0.0'
end
