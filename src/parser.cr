require "./lisp_value"

module Cryslisp
  class Parser
    REGEX_MAP = {
      /^\(/ => :LPAREN,
      /^\)/ => :RPAREN,
      /^\d+/ => :NUMBER,
      /^"[^"]*"/ => :STRING,
      /^[^\(\)\s]+/ => :SYMBOL
    }

    @input : String

    def initialize(input : String)
      @input = input
      @position = 0
    end

    def parse
      token = next_token

      case token
      when :LPAREN
        parse_list
      when :RPAREN
        raise "Unexpected RPAREN"
      else
        parse_atom(token)
      end
    end

    private def next_token : Symbol?
      @input = @input.lstrip
    
      return nil if @input.empty?
    
      REGEX_MAP.each do |regex, token_type|
        if match = regex.match(@input)
          token = token_type
          @input = match.post_match
          return token
        end
      end
    
      raise "Invalid token: #{@input}"
    end    

    private def parse_atom(token : Symbol | Nil)
      if token.nil?
        LispNil.new
      else
        case token
        when :LPAREN
          raise "Unexpected LPAREN"
        when :RPAREN
          raise "Unexpected RPAREN"
        when :NUMBER
          LispNumber.new(token.to_s.to_i)
        when :STRING
          LispString.new(token.to_s[1..-2])
        when :SYMBOL
          LispSymbol.new(token.to_s)
        else
          raise "Invalid token: #{token.inspect}"
        end
      end
    end

    private def parse_list
      elements = [] of LispValue

      while (token = next_token)
        if token == :RPAREN
          break
        end
        element = parse
        elements << element if element.is_a?(LispValue)
      end

      if elements.empty?
        LispNil.new
      else
        LispList.new(elements)
      end
    end
  end
end
