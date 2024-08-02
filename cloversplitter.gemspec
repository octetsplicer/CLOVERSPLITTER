Gem::Specification.new do |s|
	s.name = "cloversplitter"
	s.version = "0.2.2"
	s.date = "2024-08-02"
	s.summary = "An experimental pure-Ruby implementation of Shamir's Secret Sharing (for academic/educational purposes only)."
	s.description = "A pure-Ruby experimental implementation of Shamir's Secret Sharing. WARNING: Please be aware that this gem has not undergone any form of security evaluation, and is provided for academic/educational purposes only. This gem is not recommended for usage under mission-critical circumstances and should not be relied upon to protect confidential or secret information, or any information with high availability or integrity requirements. This gem should be treated purely as a proof of concept and/or learning exercise. Users should assume that this gem is insecure and that any data it is used to split into shares may be lost."
	s.authors = ["Peter Funnell"]
	s.email = "octetsplicer@proton.me"
	s.files = ["lib/cloversplitter.rb"]
	s.homepage = "https://github.com/octetsplicer/CLOVERSPLITTER"
	s.license = "MIT"
	s.required_ruby_version = ">= 2.5.5"
end
