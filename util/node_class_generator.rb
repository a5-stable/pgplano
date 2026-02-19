# ruby node_class_generator.rb
require_relative "../scanner_line"
require_relative "node_master"

NODE_MASTER.keys.each do |node_type|
  class_name = node_type.gsub(' ', '')
  file_name = node_type.downcase.gsub(' ', '_')
  full_path = "nodes/#{file_name}.rb"

  content = <<~RUBY
    module Nodes
      class #{class_name} < Base
      end
    end
  RUBY

  unless File.exist?(full_path)
    File.write(full_path, content) 
    puts "Created #{full_path}"
  end
end
