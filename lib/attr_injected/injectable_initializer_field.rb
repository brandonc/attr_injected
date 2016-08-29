# frozen_string_literal: true
module AttrInjected
  class InjectableInitializerField
    attr_reader :name
    attr_reader :required
    attr_reader :default
    attr_reader :instance_reader
    attr_reader :instance_writer

    def initialize(name, options, default)
      self.name = name
      self.required = options.fetch(:required, true)
      self.instance_reader = options.fetch(:instance_accessor, false) || options.fetch(:instance_reader, false)
      self.instance_writer = options.fetch(:instance_accessor, false) || options.fetch(:instance_writer, false)
      self.default = default
    end

    alias_method :required?, :required
    alias_method :instance_writer?, :instance_writer
    alias_method :instance_reader?, :instance_reader

    private

    attr_writer :name
    attr_writer :required
    attr_writer :default
    attr_writer :instance_writer
    attr_writer :instance_reader
  end
end
