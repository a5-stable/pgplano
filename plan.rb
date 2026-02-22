require "json"

class Plan
  attr_accessor :root, :planning_time, :execution_time

  def initialize
  end

  def to_h
    {
      root: root&.to_h,
      planning_time: planning_time,
      execution_time: execution_time
    }
  end

  def to_json
    to_h.to_json
  end
end
