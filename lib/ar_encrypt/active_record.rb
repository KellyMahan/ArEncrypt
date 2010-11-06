
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
        
        before_save "encrypt_#{attr_name}"
      end
    end
  end
end