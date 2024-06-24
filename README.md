# True Object-Oriented Decorator

[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/others)](http://www.rultor.com/p/yegor256/others)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/others/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/others/actions/workflows/rake.yml)
[![PDD status](http://www.0pdd.com/svg?name=yegor256/others)](http://www.0pdd.com/p?name=yegor256/others)
[![Gem Version](https://badge.fury.io/rb/others.svg)](http://badge.fury.io/rb/others)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/others.svg)](https://codecov.io/github/yegor256/others?branch=master)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/others/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/others)](https://hitsofcode.com/view/github/yegor256/others)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/others/blob/master/LICENSE.txt)

Let's say, you have an object that you want to decorate, thus
adding new attributes and methods to it. Here is how:

```ruby
require 'others'
s = ' Jeff Lebowski '
d = others(s, br: ' ') do
  def parts
    @origin.strip.split(@br)
  end
end
assert(d.parts == ['Jeff', 'Lebowski'])
```

You may also turn an existing class into a decorator:

```ruby
require 'others'
class MyString
  def initialize(s, br)
    @s = s
    @br = br
  end
  others(:s)
  def parts
    @origin.strip.split(@br)
  end
end
d = MyString.new('Jeff Lebowski')
assert(d.parts == ['Jeff', 'Lebowski'])
```

That's it.

## How to contribute

Read
[these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have
[Ruby](https://www.ruby-lang.org/en/) 3.2+ and
[Bundler](https://bundler.io/) installed. Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
