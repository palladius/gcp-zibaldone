require_relative "type_detector" # only does Int,String - nothing special

TestValues = %w{12012 1233.22 12:21:22 10/10/2009 Test 0CHF True false 1000CHF 25.25USD 10EUR CIAOEUR ciao 13 13.14 2020-05-13 }
TestTwo =  ["TRUE", "FALSE", "FALSE", false, "", "v", "4", "4", "1"]
TestNonString =  [true, 1,2,3, 4.0, "False"]

def test_some_values(test_values)
    puts "\n1a. Magic mini-lib from SO and elaborated by Ricc with currencies"
    test_values.each do |str|
        something = TypeDetector.autocast(str)
        p [str, something, something.class]
        if  something.class == Money
            p "100x my value ' #{something}' (want to check fractional): '#{something*100}''"
        end
    end
    puts "\n1b. Magic autocast array: #{test_values}"
    x = TypeDetector.autocast_array(test_values)
    p "A1.  TypeDetector.autocast_array(test_values) Resp: #{x}"
    y = TypeDetector.autocast_array(test_values.map{|x|TypeDetector.autocast(x)})
    p "B1. TypeDetector.autocast_array(test_values.map{|x|TypeDetector.autocast(x)} Resp: #{y}"
end

test_some_values(TestNonString)
test_some_values(TestTwo)
test_some_values(TestValues)
