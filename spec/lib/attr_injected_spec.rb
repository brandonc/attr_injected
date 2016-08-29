# frozen_string_literal: true
require "spec_helper"

RSpec.describe AttrInjected do
  class ExampleAttrInjected
    include AttrInjected

    attr_injected(:a_required_field, instance_accessor: true)
    attr_injected(:an_optional_field, instance_accessor: true, required: false)
    attr_injected(:a_defaulted_field, instance_accessor: true) { "default value" }

    def initialize(args)
      apply_injected(args)
    end
  end

  class UnrelatedExampleAttrInjected
    include AttrInjected

    attr_injected(:never_injected, instance_accessor: true)
  end

  subject { ExampleAttrInjected.new(a_required_field: "bruh") }

  describe "#apply_injected" do
    it "requires required arguments" do
      expect(subject.a_required_field).to eql("bruh")
    end

    it "applies field defaults" do
      expect(subject.a_defaulted_field).to eql("default value")
    end

    it "does not include unrelated injections" do
      expect { subject.never_injected }.to raise_error(NoMethodError)
    end

    context "when subclassed" do
      class ExampleAttrInjectedSubclass < ExampleAttrInjected
        attr_injected(:a_subclass_injected_field, instance_accessor: true) { "tojo" }
      end

      subject { ExampleAttrInjectedSubclass.new(a_required_field: "hot take") }

      it "has all fields" do
        expect(subject.a_required_field).to eql("hot take")
        expect(subject.a_subclass_injected_field).to eql("tojo")
      end
    end

    context "defaults" do
      class ExampleAttrInjectedWithoutAccessor
        include AttrInjected

        attr_injected(:my_field)

        def initialize(args)
          apply_injected(args)
        end
      end

      subject { ExampleAttrInjectedWithoutAccessor.new(my_field: "bruh") }

      it "does not define accessor" do
        expect(subject).to_not respond_to(:my_field)
      end

      it "only defines instance method" do
        expect(subject.instance_variable_get(:@my_field)).to be "bruh"
      end
    end
  end

  describe ".globalize!" do
    before do
      AttrInjected.globalize!
    end

    it "extends Object with AttrInjected" do
      class ExampleAttrInjectedWithoutModule
        attr_injected(:automatic, instance_accessor: true) { "word" }

        def initialize
          apply_injected({})
        end
      end

      expect(ExampleAttrInjectedWithoutModule.new.automatic).to eql("word")
    end
  end
end
