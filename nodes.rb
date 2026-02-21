require_relative "nodes/base"
Dir.glob(File.join(__dir__, "nodes", "*.rb")).each { |f| require_relative f }
