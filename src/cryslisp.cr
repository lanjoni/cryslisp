require "./lexer"
require "./parser"
require "./evaluator"
require "./lisp_value"

module Cryslisp
  def self.run
    evaluator = Evaluator.new

    loop do
      print ">> "
      input = gets
      break if input.nil?
      input = input.chomp

      #puts "input: " + input

      break if input == "exit"

      lexer = Lexer.new(input)

      #pp lexer

      tokens = lexer.tokenize.join(" ")

      #pp tokens

      parser = Parser.new(tokens)

      #puts "parser: " + parser.to_s
      
      ast = parser

      if ast.is_a?(Array)
        ast.each do |expr|
          result = evaluator.eval(expr)
          puts "=> #{result}"
        end
      else
        result = evaluator.eval(ast.parse)
        puts "=> #{result}"
      end
    end
  end
end

Cryslisp.run

