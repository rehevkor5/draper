module Draper
  class Security
    def initialize
      @allowed = []
      @denied = []
    end

    def denies(*methods)
      raise ArgumentError, "Specify at least one method (as a symbol) to exclude when using denies" if methods.empty?
      self.strategy = :denies
      @denied += methods
    end

    def denies_all
      self.strategy = :denies_all
    end

    def allows(*methods)
      raise ArgumentError, "Specify at least one method (as a symbol) to allow when using allows" if methods.empty?
      self.strategy = :allows
      @allowed += methods
    end

    def allow?(method)
      case strategy
      when :allows
        allowed.include?(method)
      when :denies, nil
        !denied.include?(method)
      when :denies_all
        false
      end
    end

    private

    attr_reader :allowed, :denied, :strategy

    def strategy=(strategy)
      @strategy ||= strategy
      raise ArgumentError, "Use only one of 'allows', 'denies', or 'denies_all'." unless @strategy == strategy
    end
  end
end
