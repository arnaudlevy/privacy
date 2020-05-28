require 'privacy/version'
require 'privacy/processor'
require 'thor'

module Privacy
  class CLI < Thor
    desc "process [file]", "Make data private"
    def process(file = nil)
      if file.nil?
        Dir.glob("*.xlsx") do |file|
          Processor.new file
        end
      else
        Processor.new file
      end
    end
  end
end
