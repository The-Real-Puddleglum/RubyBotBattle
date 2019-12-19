require_relative "../constants"
require_relative "validators/energy"
require_relative "animations/destroy_bot"
require_relative "animations/fire_flamethrower"
require_relative "result"

module Actions
  class FireFlamethrower
    def self.execute(game_state, bot_state)
      Validators::Energy.validate(Constants::FLAMETHROWER_COST, bot_state)

      bot_state.available_energy -= Constants::FLAMETHROWER_COST
      
      # Flamethrower pattern:
      #
      # *****
      #  ***
      #   *
      #   @

      burning_locations = affected_points(bot_state)

      burning_locations.each do |point|
        next if !game_state.in_bounds?(point)
        
        game_state.set_tile_condition(point, :burning)
        victim = game_state.bot_at(point)

        if !victim.nil?
          victim.set_condition(:burning)
          victim.health -= 1
        end        
      end

      return Result.new(true, burning_locations.map{|loc| Animations::FireFlamethrower.new(loc)})
    end

    private

    def affected_points(bot_state)
      points = []
      transforms = {
        north: ->(pt, i) { pt.translate(0, -i) },
        east: ->(pt, i) { pt.translate(i, 0) },
        south: ->(pt, i) { pt.translate(0, i) },
        west: ->(pt, i) { pt.translate(-i, 0) }
      }

      (0..2).each do |i|
        center_point = transforms[bot_state.facing].(bot_state.position, i)

        points << center_point

        next unless i > 0

        spread_directions = [:north, :south].include?(bot_state.facing) ? [:east, :south] : [:north, :south]
        spread_directions.each do {|direction| points << transforms[direction].(center_point, i)}
      end
    end
  end
end
