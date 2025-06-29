# Functions as Objects, in Ruby

[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/others)](https://www.rultor.com/p/yegor256/others)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/others/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/others/actions/workflows/rake.yml)
[![PDD status](https://www.0pdd.com/svg?name=yegor256/others)](https://www.0pdd.com/p?name=yegor256/others)
[![Gem Version](https://badge.fury.io/rb/others.svg)](https://badge.fury.io/rb/others)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/others.svg)](https://codecov.io/github/yegor256/others?branch=master)
[![Yard Docs](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/github/yegor256/others/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/others)](https://hitsofcode.com/view/github/yegor256/others)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/others/blob/master/LICENSE.txt)

Let's say you need an object that consists of a single function:

```ruby
require 'others'
x = others(foo: 42) do |*args|
  @foo + args[1]
end
assert(x.bar(10) == 52)
```

You can also do this in a class:

```ruby
require 'others'
class Foo
  def foo(a)
    a + 1
  end
  others do |*args|
    args[1] + 10
  end
end
x = Foo.new
assert(x.foo(10) == 11)
assert(x.bar(42) == 52)
```

For example, you can create a decorator that
intercepts all method calls and logs them:

```ruby
logger = others(base: original_object) do |*args, &block|
  puts "Method #{args[0]} called with #{args[1..-1].inspect}"
  @base.__send__(*args, &block)
end
```

It also supports forwarding blocks:

```ruby
x = others(foo: 42) do |*args|
  @foo + args.last.call # this is the block, as the last argument
end
puts x.bar { 12 }  # => 54
```

## How to contribute

Read
[these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have
[Ruby](https://www.ruby-lang.org/en/) 3.2+ and
[Bundler](https://bundler.io/) installed. Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
