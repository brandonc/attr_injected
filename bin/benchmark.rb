require "attr_injected"
require "benchmark"

class BenchmarkObject
  def initialize

  end
end

class NamedArgDI
  attr_accessor :cheap, :expensive1, :expensive2, :expensive3, :expensive4, :expensive5

  def initialize(cheap: "my adidias", expensive1: BenchmarkObject.new, expensive2: BenchmarkObject.new,
                 expensive3: BenchmarkObject.new, expensive4: BenchmarkObject.new, expensive5: BenchmarkObject.new)
    @cheap = cheap
    @expensive1 = expensive1
    @expensive2 = expensive2
    @expensive3 = expensive3
    @expensive4 = expensive4
    @expensive5 = expensive5
  end
end

class OptionsFetchDI
  attr_accessor :cheap, :expensive1, :expensive2, :expensive3, :expensive4, :expensive5

  def initialize(options = {})
    @cheap = options.fetch(:cheap) { "my adidias" }
    @expensive1 = options.fetch(:expensive1) { BenchmarkObject.new }
    @expensive2 = options.fetch(:expensive2) { BenchmarkObject.new }
    @expensive4 = options.fetch(:expensive3) { BenchmarkObject.new }
    @expensive4 = options.fetch(:expensive4) { BenchmarkObject.new }
    @expensive5 = options.fetch(:expensive5) { BenchmarkObject.new }
  end
end

class AttrInjectedDI
  include AttrInjected

  attr_accessor :cheap, :expensive1, :expensive2, :expensive3, :expensive4, :expensive5

  attr_injected(:cheap, required: false) { "my adidas" }
  attr_injected(:expensive1, required: false) { BenchmarkObject.new }
  attr_injected(:expensive2, required: false) { BenchmarkObject.new }
  attr_injected(:expensive3, required: false) { BenchmarkObject.new }
  attr_injected(:expensive4, required: false) { BenchmarkObject.new }
  attr_injected(:expensive5, required: false) { BenchmarkObject.new }

  def initialize(options = {})
    apply_injected(options)
  end
end

n = 500000

Benchmark.bm do |x|
  x.report("inject:")  { n.times { AttrInjectedDI.new } }
  x.report(" named:")  { n.times { NamedArgDI.new } }
  x.report(" fetch:")  { n.times { OptionsFetchDI.new } }
end
