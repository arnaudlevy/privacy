require_relative 'lib/privacy/version'

Gem::Specification.new do |s|
  s.name          = "privacy"
  s.version       = Privacy::VERSION
  s.authors       = ["Arnaud Levy"]
  s.email         = ["contact@arnaudlevy.com"]

  s.summary       = "Privacy removes personal data from a xls file"
  s.description   = "Remove first name and last name from xls files, replace them with an anonymous placeholder"
  s.homepage      = "https://github.com/arnaudlevy/privacy"
  s.license       = "MIT"
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # s.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/arnaudlevy/privacy"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|s|features)/}) }
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "thor"
  s.add_dependency "creek"
  s.add_dependency "write_xlsx"
end
