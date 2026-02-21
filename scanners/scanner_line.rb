require_relative "../util/node_master"

class ScannerLine
  NODE_TYPES = NODE_MASTER.keys.freeze
  NODE_PATTERN = /\A(#{NODE_TYPES.map { Regexp.escape(_1) }.join('|')})/

  attr_reader :depth, :tokens

  def initialize(line)
    @row = line
    @depth = calculate_depth(line)
    @tokens = tokenize(line)
  end

  private

  def calculate_depth(line)
    match = line.match(/\A(\s*)(->\s*)?/)
    spaces = match[1].length
    has_arrow = !match[2].nil?
    has_arrow ? (spaces / 2) + 1 : spaces / 2
  end

  def tokenize(content)
    tokens = []
    content = content.sub(/\A\s*(->\s*)?/, '')
    scanner = StringScanner.new(content)

    if node?
      tokenize_node(scanner, tokens)
    else
    end

    tokens
  end

  private

  def node?
    @depth == 0 || @row.match?(/\A\s*->/)
  end

  def tokenize_node(scanner, tokens)
    while !scanner.eos?
      next if scanner.scan(/[ \t()]+/)

      if scanner.scan(NODE_PATTERN)
        tokens << [:NODE_TYPE, scanner[1].gsub(/\s+/, '')]
      elsif scanner.scan(/on\s+(\w+)/)
        tokens << [:ON, scanner[1]]
      elsif scanner.scan(/using\s+(\w+)/)
        tokens << [:USING, scanner[1]]
      elsif scanner.scan(/cost=([\d.]+)\.\.([\d.]+)/)
        tokens << [:COST, [scanner[1].to_f, scanner[2].to_f]]
      elsif scanner.scan(/rows=(\d+)/)
        tokens << [:ROWS, scanner[1].to_i]
      elsif scanner.scan(/width=(\d+)/)
        tokens << [:WIDTH, scanner[1].to_i]
      elsif scanner.scan(/actual time=([\d.]+)\.\.([\d.]+)/)
        tokens << [:ACTUAL_TIME, [scanner[1].to_f, scanner[2].to_f]]
      elsif scanner.scan(/loops=(\d+)/)
        tokens << [:LOOPS, scanner[1].to_i]
      else
        scanner.getch
      end
    end
  end
end
