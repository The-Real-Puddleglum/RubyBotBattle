require_relative "../exceptions/invalid_condition"

module Models
  class BotState
    attr_accessor :bot, :available_energy, :health, :facing, :position, :conditions

    def initialize(bot, available_energy, health, facing, position)
      @bot = bot
      @available_energy = available_energy
      @health = health
      @facing = facing
      @position = position
      @conditions = []
    end

    def alive?()
      return @health > 0
    end

    def set_condition(condition)
      validate_condition(condition)
      @conditions |= condition
    end

    def unset_condition(condition)
      @conditions.delete(condition)
    end

    private

    def validate_condition(condition)
      raise Exceptions::InvalidconditionError.new(condition) unless [:burning].include?(condition)
    end
  end
end
