
require 'money'
require 'date'
require 'time'
require "rails"

#require_relative "csv_converter" # only does Int,String - nothing special

#TestValues = %w{12012 1233.22 12:21:22 10/10/2009 Test 0CHF True false 1000CHF 25.25USD 10EUR CIAOEUR ciao 13 13.14 2020-05-13 }
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN
Money.locale_backend = :i18n

def dup_hash(ary)
    ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { 
      |_k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
end
def max_count(arr)
    arr.uniq.map { |n| arr.count(n) }.max
end

class TypeDetector
  @@default_arr_limit = 9
  @@verbose = false

=begin
  https://api.rubyonrails.org/classes/ActiveRecord/Type.html

  transform String -> string
=end

  def self.ruby_class_to_rails_class(cls)
    mega_map = {
        TrueClass => :Boolean,
        FalseClass => :Boolean,
        Integer => :Integer,
        Float => :Float,
        Date => :Date,
        Time => :Time,
        DateTime => :DateTime,
        Money => :Decimal,
        String => :Text,
    }
    p "ERR Unknown Type: #{cls}\n" unless cls.in?(mega_map.keys)
    return mega_map[cls] || "Dunno#{cls}".parameterize.underscore.to_sym()
  end

  def self.verbose_print(arr)
    arr.each do |str|
        something = TypeDetector.autocast(str)
        p ["-", str, something, something.class]
    end
  end

  def self.autocast(str)
    str = str.to_s()
    return nil if str == "nil"
    return true if str.in?(%w( TRUE True true ))
    return false if str.in?(%w( FALSE False false ))
    duck = (Integer(str) rescue Float(str) rescue Date.parse(str) rescue Time.parse(str) rescue nil)
    if str =~ /(.*)[CHF|USD|EUR|GBP]/
        value = Float(str[0..str.length-4]) rescue nil
        currency = str[str.length-3..str.length]
        #print "DEB Habemus currency! #{value} // #{currency}\n"
        if duck = Money.new(Float(value), currency) rescue nil
            return duck
        end
        #print "Pensavo fosse Money invece era un Carlesse...\n"
    end
    duck.nil? ? str : duck
end

=begin
  returns a responses and notes    
=end
    def self.autocast_array(arr, opts={})
        arr_limit = opts[:limit] || @@default_arr_limit 
        arr = arr.first(arr_limit) # .map{|x| x.to_s}
        self.verbose_print(arr) if @@verbose
        arr_classes = arr.map{|x| ruby_class_to_rails_class(self.autocast(x).class)}
        h = dup_hash(arr_classes)
        most_occurrent_class = h.key(max_count(arr_classes))
        ret = most_occurrent_class
        accuracy =  max_count(arr_classes)*100.0 / arr_classes.count
        notes = "Majority computed with: #{h}. Accuracy: #{accuracy}"
        return {
            class: ret,
            notes: notes,
            accuracy: accuracy, # percent
            confident: accuracy > 79,
            arr: arr,
        }
    end

end


=begin
  expects String in input
  in output, supports:
        String - of course
        Nil, Boolean
        Integer, Float
        Money
        

=end
# https://stackoverflow.com/questions/1415819/find-type-of-the-content-number-date-time-string-etc-inside-a-string


#exit(42)