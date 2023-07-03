# lisp_value.cr

module Cryslisp
  abstract class LispValue
    abstract def to_s : String
  end

  class LispNil < LispValue
    def to_s : String
      "nil"
    end
  end

  class LispSymbol < LispValue
    getter name : String
  
    def initialize(@name : String)
    end

    def to_s : String
      name
    end
  end

  class LispBoolean < LispValue
    property value : Bool
  
    def initialize(value : Bool)
      @value = value
    end
  
    def to_s : String
      @value.to_s
    end
  end

  class LispNumber < LispValue
    getter value : Int32
  
    def initialize(@value : Int32)
    end
  
    def to_s : String
      value.to_s
    end
  end

  class LispString < LispValue
    getter value : String
  
    def initialize(@value : String)
    end
  
    def to_s : String
      value
    end
  end

  class LispList < LispValue
    getter elements : Array(LispValue)
  
    def initialize(@elements : Array(LispValue))
    end
  
    def to_s : String
      elements.map { |element| element.to_s }.join(" ")
    end

    def first : LispValue
      @elements.first
    end

    def length : Int32
      @elements.size
    end

    def empty? : Bool
      @elements.empty?
    end

    def rest : LispValue
      LispList.new(@elements[1..])
    end

    def map(&block : LispValue -> LispValue) : LispList
      LispList.new(@elements.map(&block))
    end
  end 
end