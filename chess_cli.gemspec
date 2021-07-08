# frozen_string_literal: true

require_relative "lib/chess_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "chess_cli"
  spec.version       = ChessCli::VERSION
  spec.authors       = ["Austin Schneider"]
  spec.email         = ["me@austinschneider.com"]

  spec.summary       = "Chess CLI"
  spec.homepage      = "https://github.com/austinthecoder/chess_cli"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/austinthecoder/chess_cli"
  spec.metadata["changelog_uri"] = "https://github.com/austinthecoder/chess_cli/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ivo", "~> 0.5"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
