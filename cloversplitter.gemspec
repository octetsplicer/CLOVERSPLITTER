Gem::Specification.new do |s|
	s.name = "cloversplitter"
	s.version = "0.2.1"
	s.date = "2020-06-09"
	s.summary = "Shamir's Secret Sharing in Ruby"
	s.description = "A pure-Ruby implementation of Shamir's Secret Sharing. WARNING: Please be aware that this gem has not undergone any form of security evaluation. This gem is not recommended for usage under mission-critical circumstances and should not be relied upon to protect confidential or secret information. Users should assume that this gem is insecure until they can independently confirm otherwise."
	s.authors = ["Peter Funnell"]
	s.email = "hello@octetsplicer.com"
	s.files = ["lib/cloversplitter.rb"]
	s.homepage = "https://github.com/octetsplicer/CLOVERSPLITTER"
	s.license = "MIT"
	s.required_ruby_version = ">= 2.5.5"
end
