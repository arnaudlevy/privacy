require 'privacy/version'
require 'thor'

module Privacy
  class CLI < Thor
    desc "process [file]", "Make data private"
    def process(file)
      puts file
    end
  end
end
