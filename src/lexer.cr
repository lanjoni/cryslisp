module Cryslisp
  class Lexer
    REGEX_MAP = {
      /^\(/ => :LPAREN,
      /^\)/ => :RPAREN,
      /^\d+/ => :NUMBER,
      /^"[^"]*"/ => :STRING,
      /^[^\(\)\s]+/ => :SYMBOL
    }

    def initialize(input : String)
      @input = input
      @position = 0
    end
  
    def tokenize : Array(Symbol)
      tokens = [] of Symbol
  
      position = 0

      puts @input.size

      while position < @input.size
        REGEX_MAP.each do |regex, token_type|
          if match = regex.match(@input)
            token = token_type
            #position += 1
            #break
          end
        end

        position += 1
        token = next_token
        tokens << token if token
      end

      puts "\n\ntokens: "
      pp tokens
    end

    private def next_token : Symbol?
      @input = @input.lstrip

      return nil if @input.empty?

      match = REGEX_MAP.find { |regex, _| regex.match(@input) }

      return nil unless match

      token = match[1]
      @input = @input[match.size..-1]
      @position += 1
      token
    end
  end
end
