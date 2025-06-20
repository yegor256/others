# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/others'
require_relative 'test__helper'

# Others main module test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class TestOthers < Minitest::Test
  def test_as_function
    x = others(foo: 42) do
      @foo + 1
    end
    assert_equal(43, x.bar)
  end

  def test_as_function_setter
    x = others(map: {}) do |*args|
      k = args[0].to_s
      if k.end_with?('=')
        @map[k[..2]] = args[1]
      else
        @map[k]
      end
    end
    x.foo = 42
    assert_equal(42, x.foo)
  end

  def test_as_function_with_args
    x = others(foo: 42) do |*args|
      @foo + args[1]
    end
    assert_equal(97, x.bar(55))
  end

  def test_with_block
    x = others(foo: 42) do |*args|
      @foo + args.last.call
    end
    assert_equal(55, x.bar { 13 })
  end

  def test_as_function_with_block
    x = others(foo: 42) do
      yield 42
    end
    assert_raises(StandardError) do
      x.bar { |i| i + 1 }
    end
  end

  def test_as_class
    cx = Class.new do
      def foo(abc)
        abc + 1
      end
      others do |*args|
        args[1] + 2
      end
    end
    x = cx.new
    assert_equal(43, x.foo(42))
    assert_equal(44, x.bar(42))
  end

  def test_as_class_setter
    cx = Class.new do
      def initialize(map)
        @map = map
      end
      others do |*args|
        k = args[0].to_s
        if k.end_with?('=')
          @map[k[..2]] = args[1]
        else
          @map[k]
        end
      end
    end
    x = cx.new({})
    x.foo = 42
    assert_equal(42, x.foo)
  end
end
