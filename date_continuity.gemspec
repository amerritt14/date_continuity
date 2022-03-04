Gem::Specification.new do |s|
  s.name        = "date_continuity"
  s.version     = "0.3.0"
  s.summary     = "A gem to handle calculating start/end dates based on a duration and frequency"
  s.description = "Calculate fields based on a minimum set of information."
  s.authors     = ["Andrew Merritt"]
  s.email       = "andrew.w.merritt@gmail.com"
  s.files       = ["lib/date_continuity.rb", "lib/date_continuity/configuration.rb", "lib/date_continuity/model.rb", "lib/date_continuity/errors.rb", "lib/date_continuity/occurrences.rb", "lib/date_continuity/time_between.rb"]
  s.homepage    = "https://github.com/amerritt14/date_continuity"
  s.license     = "MIT"
  s.add_dependency 'activesupport', '> 3'
end
