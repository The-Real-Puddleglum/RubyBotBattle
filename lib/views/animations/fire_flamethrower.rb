require "tty-cursor"
require "pastel"

module Views
  module Animations
    class FireFlamethrower
      def initialize(model)
        @position = model.position
        @duration = 12
      end

      def render(frame, render_offset)

      end

      def complete?()
        return !@initial_frame.nil? && @current_frame - @initial_frame > @duration
      end
    end
  end
end
