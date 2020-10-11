# frozen_string_literal: true

# Brainfuck Language Specifications https://en.wikipedia.org/wiki/Brainfuck
# >: p_increment prt++;
# <: p_decrement prt-;
# +: increment   (*ptr)++;
# -: decrement   (*ptr)--;
# .: put         putchar(*ptr);
# ,: get         *ptr=getchar();
# [: open        while(*ptr)
# ]: close       }

module BfRuby
  class Translator
    MEM_SIZE = 1024

    class << self
      def translate(f_ing_src)
        new(f_ing_src).translate
      end
    end

    def initialize(f_ing_src)
      @operation = f_ing_src
    end

    def translate
      mem = Array.new(MEM_SIZE, 0)
      ptr = 0
      cur = 0
      output = []
      until @operation[cur].nil?
        case @operation[cur]
        when '>'
          ptr += 1
        when '<'
          ptr -= 1
        when '+'
          mem[ptr] += 1
        when '-'
          mem[ptr] -= 1
        when '.'
          output << mem[ptr].chr
        when ','
          raise NotImplementedError
        when '['
          cur = jump_next_brace(cur) if mem[ptr].zero?
        when ']'
          cur = jump_before_brace(cur) unless mem[ptr].zero?
        end
        cur += 1
      end

      output.join
    end

    private

    def jump_before_brace(cur, brace_stack = [])
      loop do
        case @operation[cur]
        when ']'
          brace_stack.push(1) # スタックにpushしていき、スタックが0になる=対応するカッコに到達したらloopから抜ける
        when '['
          brace_stack.pop
        end
        break if brace_stack.empty?

        cur -= 1
      end
      cur
    end

    def jump_next_brace(cur, brace_stack = [])
      loop do
        case @operation[cur]
        when '['
          brace_stack.push(1)
        when ']'
          brace_stack.pop
        end
        break if brace_stack.empty?

        cur += 1
      end
      cur
    end
  end
end
