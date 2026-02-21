module Nodes
  class Base
    attr_accessor :cost_startup, :cost_total,
                  :rows, :width,
                  :actual_time_startup, :actual_time_total,
                  :actual_rows, :loops,
                  :children
  end
end
