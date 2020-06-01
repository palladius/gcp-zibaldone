
require 'money'
require 'date'
require 'time'

TestValues = %w{12012 1233.22 12:21:22 10/10/2009 Test True false 100CHF 2.25USD 1EUR CIAOEUR ciao 13 13.14 2020-05-13 }
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN
Money.locale_backend = :i18n

class TypeDetector

  end

=begin
    Supports:
        String
        Nil
        Boolean
=end
# https://stackoverflow.com/questions/1415819/find-type-of-the-content-number-date-time-string-etc-inside-a-string
def autocast(str)
#     if (num = Integer(str) rescue Float(str) rescue Time.parse(str) rescue nil) 
#         # integer or float - WOW
#         num
# #    elsif (tm = ) == Time.now
# #        # Time.parse does not raise an error for invalid input
# #        str
# #    else 
#         tm
#     end
    return nil if str == "nil"
    return true if str.in?(%w( TRUE True true ))
    return false if str.in?(%w( FALSE False false ))
    duck = (Integer(str) rescue Float(str) rescue Date.parse(str) rescue Time.parse(str) rescue nil)
    if str =~ /(.*)[CHF|USD|EUR]/
        value = Float(str[0..str.length-4])
        currency = str[str.length-3..str.length]
        #print "DEB Habemus currency! #{value} // #{currency}\n"
        if duck = Money.new(Float(value), currency) rescue nil
            return duck
        end
        print "Pensavo fosse Money invece era un Carlesse...\n"
    end
    duck.nil? ? str : duck
end

def test_some_values()
    TestValues.each do |str|
    something = autocast(str)
    p [str, something, something.class]
    if  something.class == Money
        p "100x my value ' #{something}' (want to check fractional): '#{something*100}''"
    end
    end
end

test_some_values()

exit(42)