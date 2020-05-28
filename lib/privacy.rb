require 'privacy/version'
require 'privacy/processor'
require 'thor'

module Privacy
  class CLI < Thor
    desc "process [file]", "Make data private"
    def process(file = nil)
      file.nil? ? Dir.glob("*.xlsx") { |file| Processor.new(file) }
                : Processor.new(file)
    end
  end
end
