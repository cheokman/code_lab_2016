module ERM
  module TypeLookup
    TYPE_FORMAT = /\A[A-Z]\w*\z/.freeze

    def self.extended(model)
      model.instance_variable_set('@type_lookup_cache', {})
    end

    def determine_type(class_or_name)
      @type_lookup_cache[class_or_name] ||= determine_type_and_cache(class_or_name)
    end

    def primitive
      raise NotImplementedError, "#{self}.primitive must be implemented"
    end
    private


    def determine_type_and_cache(class_or_name)
      case class_or_name
      when singleton_class
        determine_type_from_descendant(class_or_name)
      when Class
        determine_type_from_primitive(class_or_name)
      else
        determine_type_from_string(class_or_name.to_s)
      end
    end

    def determine_type_from_descendant(descendant)
      descendant if descendant < self
    end

    def determine_type_from_primitive(primitive)
      type = nil
      descendants.select(&:primitive).reverse_each do |descendant|
        descendant_primitive = descendant.primitive
        next unless primitive <= descendant_primitive
        type = descendant if type.nil? or type.primitive > descendant_primitive
      end
      type
    end

    def determine_type_from_string(string)
      if string =~ TYPE_FORMAT and const_defined?(string, *EXTRA_CONST_ARGS)
        const_get(string, *EXTRA_CONST_ARGS)
      end
    end
  end
end