Gem::Specification.new do |s|
	s.name        = 'event_timer'
	s.version     = '1.0.0'
	s.date        = '2015-05-01'
	s.summary     = "EventTimer"
	s.description = "An event timer for Ruby"
	s.authors     = ["Greg Martin"]
	s.email       = 'greg@softsprocket.com'
	s.files       = ["lib/event_timer.rb"]
	s.homepage    = 'http://rubygems.org/gems/event_timer.rb'
	s.license     = 'MIT'
	s.add_runtime_dependency "async_emitter", '~> 1.1', '>= 1.1.1'
	s.add_runtime_dependency "ready_pool", '~> 1.1', '>= 1.1.0'
end

