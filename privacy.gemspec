require_relative 'lib/privacy/version'

Gem::Specification.new do |spec|
  spec.name          = "privacy"
  spec.version       = Privacy::VERSION
  spec.authors       = ["Arnaud Levy"]
  spec.email         = ["contact@arnaudlevy.com"]

  spec.summary       = "Privacy removes personal data from a xls file"
  spec.description   = "Remove first name and last name from xls files, replace them with an anonymous placeholder"
  spec.homepage      = "https://github.com/arnaudlevy/privacy"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/arnaudlevy/privacy"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "thor", "~> 0.20"
end