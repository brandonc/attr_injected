# attr_injected

Simple dependency injection in ruby

:warning: Proof of concept software. Too slow for production use.

## Rationale

Do you write redundant assignment code in order to inject dependencies into your ruby classes using named arguments?

```ruby
class VerboseExample
  attr_reader :content, :revision, :some_dependency, :notifier

  def initialize(
    content:,
    revision:,
    some_dependency: Service::Example.new(revision: revision),
    notifier: Service::Notifier.new(content: content)
  )
    self.content = content
    self.revision = revision
    self.some_dependency = some_dependency
    self.notifier = notifier
  end

  private

  attr_writer :content, :revision, :some_dependency, :notifier
end
```

attr_injected simplifies this approach by allowing you to specify named initializer parameters along with their defaults
at the class level:

```ruby
class Example
  include Injected

  attr_injected(:content)
  attr_injected(:revision)
  attr_injected(:some_dependency) { Service::Example.new(revision: revision) }
  attr_injected(:notifier, instance_accessor: true) { Service::Notifier.new(content: content) }

  def initialize(options)
    # - Assigns @content, @revision, @some_dependency, and @notifier instance variables
    # - Creates public attr_accessor for @notifier
    # - Throws ArgumentError if :content or :revision were nil or missing
    apply_injected(options)
  end
end

ex = Example.new(content: c, revision: r)
ex.notifier # Defaulted to Service::Notifier instance
```

## Documentation

#### Installation

Add this line to your application's Gemfile:

```ruby
gem "attr_injected", "~> 0.1.0", git: "git://github.com/brandonc/attr_injected.git"
```

And then execute:

```shell
$ bundle
```

#### Usage

```ruby
require "attr_injected"

class MyObject
  include AttrInjected

  attr_injected(:my_field) { "my default value" }
  attr_injected(:required_no_default)

  def initialize(options)
    apply_injected(options)
    # @my_field is now assigned to either the value supplied to the initialized or the default supplied by the block
    # @required_no_default must be assigned by the caller
  end
end

obj = MyObject.new(required_no_default: 1.0, my_field: "my injected value")
```

A default is not required, but it useful for defining default dependencies.

Available options:

* `required` specifies whether this argument is required. Throws an ArgumentError if argument is missing or nil. *(optional, default: true)*
* `instance_reader` specifies whether the class should define a public attr_reader for this field *(optional, default: false)*
* `instance_writer` specifies whether the class should define a public attr_writer for this field *(optional, default: false)*
* `instance_accessor` specifies whether the class should define a public attr_reader and attr_writer for this field *(optional, default: false)*

#### Global Access

To make _any object_ support `attr_injected`, call: `AttrInjected.globalize!`

## Benchmark

```
$ bundle exec ruby ./bin/benchmark.rb
                  user       system     total       real
  attr_injected:  4.830000   0.020000   4.850000 (  4.861008)
named arguments:  0.760000   0.000000   0.760000 (  0.766978)
  options fetch:  1.000000   0.010000   1.010000 (  1.015625)
```

This benchmark shows that initializing 500000 objects with five attr_injected attributes is 5-6x slower than
using named arguments or `Hash#fetch`

## Acknowledgements

Inspired by and name stolen from [codegangsta/attr_inject](https://github.com/codegangsta/attr_inject) but implemented
with the following key differences:

1. objects may define their own default dependencies
2. does not, by default, extend ruby core
