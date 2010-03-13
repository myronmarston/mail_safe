module Ginger
  class Scenario < Hash
    attr_accessor :name

    def initialize(name=nil)
      @name = name
    end

    def add(gem, version)
      self[gem] = version
    end
    
    def version(gem)
      self.keys.each do |key|
        case key
        when String
          return self[key] if gem == key
        when Regexp
          return self[key] if gem =~ key
        end
      end
      
      return nil
    end
    
    def gems
      self.keys
    end
  end
end
