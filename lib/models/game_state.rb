require_relative "../util/direction"
require_relative "../exceptions/invalid_condition"

module Models
  class GameState
    attr_accessor :arena_size, :bot_states, :turn

    def initialize(turn, arena_size, bot_states)
      @turn = turn
      @arena_size = arena_size
      @bot_states = bot_states
      @location_conditions = {}
    end

    def bot_at(point)
      return bot_states.find { |state| state.position == point }
    end

    def first_occupied(from_point, in_direction)
      offset = Util::Direction.create_offset(in_direction, 1)
      pt = from_point.clone.translate!(offset.x, offset.y)

      while !occupied?(pt) && in_bounds?(pt)
        pt.translate!(offset.x, offset.y)
      end

      return pt
    end

    def occupied?(point)
      return bot_states.any? { |state| state.position == point }
    end

    def in_bounds?(point)
      return point.x >= 0 &&
        point.y >= 0 &&
        point.x < arena_size.width &&
        point.y < arena_size.height
    end

    def set_tile_condition(location, condition)
      validate_condition(condition)
      @location_conditions[location_condition_key(location)] = @location_conditions.fetch(location_condition_key(location), []).append(condition).uniq
    end

    def unset_tile_condition(location, condition)
      validate_condition(condition)
      @location_conditions[location_condition_key(location)] = @location_conditions.fetch(location_condition_key(location), []).delete(condition)
    end

    private

    def location_condition_key(point)
      return "#{point.x}:#{point.y}"
    end

    def validate_condition(condition)
      raise Exceptions::InvalidconditionException.new(condition) unless [:burning].contains(condition)
    end
  end
end
