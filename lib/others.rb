# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Creates an object that responds to any method call by executing a provided block.
#
# This method can be used in two ways:
# 1. As a standalone function to create an object with dynamic method handling
# 2. Inside a class definition to add catch-all method handling to instances
#
# @param attrs [Hash] Instance variables to set on the created object (only for standalone usage)
# @param block [Proc] The block to execute when any method is called on the object
#
# @example Standalone usage with instance variables
#   obj = others(counter: 0) do |method_name, *args|
#     @counter += args.first
#   end
#   obj.add(5)  # => 5
#   obj.increment(3)  # => 8
#
# @example Class usage for catch-all methods
#   class Calculator
#     def add(a, b)
#       a + b
#     end
#     others do |method_name, *args|
#       args.reduce(:*)
#     end
#   end
#   calc = Calculator.new
#   calc.add(2, 3)  # => 5 (defined method)
#   calc.multiply(2, 3, 4)  # => 24 (caught by others)
#
# @return [Object] An instance that responds to any method call
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
def others(attrs = {}, &block)
  if is_a?(Class)
    class_exec(block) do |b|
      # rubocop:disable Style/ClassVars
      class_variable_set(:@@__others_block__, b)
      # rubocop:enable Style/ClassVars

      # Handles all undefined method calls by executing the stored block.
      #
      # @param args [Array] Method name and arguments passed to the undefined method
      # @raise [RuntimeError] If a block is provided to the method call
      # @return [Object] The result of executing the stored block
      def method_missing(*args, &block)
        b = self.class.class_variable_get(:@@__others_block__)
        instance_exec(*args + [block], &b)
      end

      # Always returns true to indicate this object responds to any method.
      #
      # @param _mtd [Symbol, String] The method name being queried
      # @param _inc [Boolean] Whether to include private methods
      # @return [true] Always returns true
      def respond_to?(_mtd, _inc = false)
        true
      end

      # Indicates that any missing method should be considered as responding.
      #
      # @param _mtd [Symbol, String] The method name being queried
      # @param _inc [Boolean] Whether to include private methods
      # @return [true] Always returns true
      def respond_to_missing?(_mtd, _inc = false)
        true
      end
    end
  else
    c = Class.new do
      def initialize(attrs, &block)
        # rubocop:disable Style/HashEachMethods
        # rubocop:disable Lint/UnusedBlockArgument
        attrs.each do |k, v|
          instance_eval("@#{k} = v", __FILE__, __LINE__) # @foo = v
        end
        # rubocop:enable Style/HashEachMethods
        # rubocop:enable Lint/UnusedBlockArgument
        @block = block
      end

      # Handles all undefined method calls by executing the stored block.
      #
      # @param args [Array] Method name and arguments passed to the undefined method
      # @raise [RuntimeError] If a block is provided to the method call
      # @return [Object] The result of executing the stored block
      def method_missing(*args, &block)
        instance_exec(*args + [block], &@block)
      end

      # Always returns true to indicate this object responds to any method.
      #
      # @param _mtd [Symbol, String] The method name being queried
      # @param _inc [Boolean] Whether to include private methods
      # @return [true] Always returns true
      def respond_to?(_mtd, _inc = false)
        true
      end

      # Indicates that any missing method should be considered as responding.
      #
      # @param _mtd [Symbol, String] The method name being queried
      # @param _inc [Boolean] Whether to include private methods
      # @return [true] Always returns true
      def respond_to_missing?(_mtd, _inc = false)
        true
      end
    end
    c.new(attrs, &block)
  end
end
