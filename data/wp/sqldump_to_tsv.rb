require "strscan"

class String
   def get_args
     scanner     = StringScanner.new(self)
     result      = scanner.eos? ? Array.new : [""]
     paren_depth = 0

     until scanner.eos?
       if scanner.scan(/[^(),]+/)
         # do nothing--we found the part of the argument we need to add
       elsif scanner.scan(/\(/)
         paren_depth += 1
       elsif scanner.scan(/\)/)
         paren_depth -= 1
       elsif scanner.scan(/,\s*/) and paren_depth.zero?
         result << ""
         next
       end

       result.last << scanner.matched
     end

     result
   end
end

require 'test/unit'

class TestArgumentParser < Test::Unit::TestCase
   def test_simple_cases
     assert_equal %w[ a b ],         'a,b'.get_args
     assert_equal %w[ a_frog b25 ],  'a_frog, b25'.get_args
   end
   def test_embedded_parens
     assert_equal %w[ a(1) b ],      'a(1), b'.get_args
     assert_equal %w[ a b(i) ],      'a, b(i)'.get_args
   end
   def test_embedded_parens_with_commas
     assert_equal %w[ a(0,j) b ],    'a(0,j),b'.get_args
     assert_equal %w[ a() b(j,k) ],  'a(),b(j,k)'.get_args
     assert_equal %w[ c(i,j,t(1)) ], 'c(i,j,t(1))'.get_args
   end
end
