require "strscan"
require_relative "scanner_line"

class Scanner
  attr_reader :input, :tokens, :scanner

  def initialize(input)
    @input = input
    @lines = []
  end

  def scan
    @input.each_line.filter_map do |line|
      next if line.strip.empty?
      @lines << ScannerLine.new(line.rstrip)
    end

    @lines
  end
end
