require_relative "plan"
require_relative "nodes"

class Parser
  def initialize(lines)
    @lines = lines
    @current_line_index = 0
  end

  def parse
    plan = Plan.new
    plan.root = parse_node(0)
    plan
  end

  private

  def parse_node(current_depth)
    children = []
    node_type = current_line.tokens[0][1]
    klass = Object.const_get("Nodes::#{node_type}")
    node = klass.new
    apply_node_attributes(node, current_line.tokens)

    while !end_of_lines? && next_line.depth > current_depth
      @current_line_index += 1
      if is_current_line_node?
        children << parse_node(current_line.depth)
      end
    end

    node.children = children
    node
  end

  def apply_node_attributes(node, tokens)
    tokens.each do |type, value|
      case type
      when :COST
        node.cost_startup, node.cost_total = value
      when :ROWS
        node.rows = value
      when :WIDTH
        node.width = value
      when :ACTUAL_TIME
        node.actual_time_startup, node.actual_time_total = value
      when :ACTUAL_ROWS
        node.actual_rows = value
      when :LOOPS
        node.loops = value
      end
    end
  end

  def current_line
    @lines[@current_line_index]
  end

  def next_line
    @lines[@current_line_index + 1]
  end

  def end_of_lines?
    @current_line_index >= @lines.size - 1
  end

  def is_current_line_node?
    current_line.tokens.dig(0, 0) == :NODE_TYPE
  end
end
