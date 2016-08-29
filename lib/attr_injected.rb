# frozen_string_literal: true
require "attr_injected/injectable_initializer_field"

module AttrInjected
  def self.globalize!
    Object.instance_eval do
      include AttrInjected
    end
  end

  def self.included(base)
    base.extend(ClassMethods)

    ivar = "@injected"

    class << base
      def injected=(val)
        singleton_class.class_eval do
          define_method("injected") { val }
        end

        if singleton_class?
          class_eval do
            define_method("injected") do
              if instance_variable_defined?(ivar)
                instance_variable_get(ivar)
              else
                singleton_class.injected
              end
            end
          end
        end
        val
      end

      def injected
        @injected
      end
    end
  end

  module ClassMethods
    def attr_injected(field, options = {}, &block)
      self.injected ||= []
      self.injected += [InjectableInitializerField.new(field, options, block)]
    end
  end

  def apply_injected(options)
    self.class.injected.each do |field|
      self.class.class_eval do
        attr_reader :"#{field.name}"
      end if field.instance_reader?

      self.class.class_eval do
        attr_writer :"#{field.name}"
      end if field.instance_writer?

      val = options.fetch(field.name) do
        field.default.nil? ? nil : self.instance_exec(&field.default)
      end

      self.instance_variable_set(
        :"@#{field.name}",
        val
      )

      fail ArgumentError, "The argument \"#{field.name}\" is required." if field.required? && val.nil?
    end
  end
end
