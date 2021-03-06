
module ActiveRecord
  class Base
    class << self
      def encrypt(attr_name)
        attr_name = attr_name.to_s
        define_method("encrypt_#{attr_name}") do
          if self.attribute_names.include?("#{attr_name}") ? eval("self.#{attr_name}_changed?") : true
            eval("self.#{attr_name} = ArEncrypt.encrypt(\"#{eval("self.#{attr_name}")}\")")
          end
          return true
        end
        define_method("#{attr_name}_match?") do |match_str|
          return eval("self.#{attr_name} == ArEncrypt.encrypt(\"#{eval("match_str")}\")")
        end
        class_eval do
          eval("def self.#{attr_name}_find(str, options = {})
          conditions_array = ['1 = 1']
          options.each_pair do |key, value|
            conditions_array << \"\#{key} = '\#{value}'\"
          end
          if conditions_array.length > 0
            conditions_str = \" and \#{conditions_array.join(' and ')}\"
          else
            conditions_str = ''
          end
          find(:first, :conditions=>[\"#{attr_name} = ? \#{conditions_str}\", ArEncrypt.encrypt(str)])
          end")
        end
        class_eval do
          eval("def self.#{attr_name}_find_all(str, options = {})
          conditions_array = []
          options.each_pair do |key, value|
            conditions_array << \"\#{key} = '\#{value}'\"
          end
          if conditions_array.length > 0
            conditions_str = \" and \#{conditions_array.join(' and ')}\"
          else
            conditions_str = ''
          end
          find(:all, :conditions=>[\"#{attr_name} = ? \#{conditions_str}\", ArEncrypt.encrypt(str)])
          end")
        end
        
        before_save "encrypt_#{attr_name}"
      end
    end
  end
end