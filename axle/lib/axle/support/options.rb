module Axle
  module Options
    def options
      accepted_options.each_with_object({}) do |option_name, options|
        option_value         = send(option_name)
        options[option_name] = option_value unless option_value.nil?
      end
    end

    def accepted_options
      @accepted_options ||= []
    end

    def accept_options(*new_options)
      add_accepted_options(new_options)
      new_options.each { |option| define_option_method(option) }
      self
    end

  protected

    def define_option_method(option)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{option}(value = Undefined)           # def self.default(value = Undefined)
          @#{option} = nil unless defined?(@#{option})  #   @default = nil unless defined?(@default)
          return @#{option} if value.equal?(Undefined)  #   return @default if value.equal?(Undefined)
          @#{option} = value                            #   @default = value
          self                                          #   self
        end                                             # end
      RUBY
    end

    def set_options(new_options)
      new_options.each { |pair| send(*pair) }
      self
    end

    def add_accepted_options(new_options)
      accepted_options.concat(new_options)
      self
    end
  end
end