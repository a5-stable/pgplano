module Nodes
  class Base
    attr_accessor :cost_startup, :cost_total,
                  :rows, :width,
                  :actual_time_startup, :actual_time_total,
                  :actual_rows, :loops,
                  :children,
                  :table_name

    def node_type
      self.class.name.split("::").last
    end

    def to_h
      {
        node_type: node_type,
        table_name: table_name,
        cost_startup: cost_startup,
        cost_total: cost_total,
        rows: rows,
        width: width,
        actual_time_startup: actual_time_startup,
        actual_time_total: actual_time_total,
        actual_rows: actual_rows,
        loops: loops,
        children: children&.map(&:to_h) || []
      }.compact
    end
  end
end
