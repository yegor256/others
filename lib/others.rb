# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# A function that catches all undeclared methods.
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

      def method_missing(*args)
        raise 'Block cannot be provided' if block_given?
        b = self.class.class_variable_get(:@@__others_block__)
        instance_exec(*args, &b)
      end

      def respond_to?(_mtd, _inc = false)
        true
      end

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

      def method_missing(*args)
        raise 'Block cannot be provided' if block_given?
        instance_exec(*args, &@block)
      end

      def respond_to?(_mtd, _inc = false)
        true
      end

      def respond_to_missing?(_mtd, _inc = false)
        true
      end
    end
    c.new(attrs, &block)
  end
end
