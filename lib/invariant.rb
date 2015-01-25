require "invariant/version"

module Invariant
  @invariant = nil

  def invariant &block
    @invariant = block
  end

  def verify object
    object.instance_eval &@invariant
  end

  def enabled
    parent = Module.new do
      def self.wrap mod
        # parent の制約を厳しくしてはいけない
        mod.public_instance_methods(false).each do |name|
          module_eval %Q{
            def #{name}
              pre_assert
              result = super
              post_assert
              result
            end
          }
        end
      end

      private
      # Proc じゃないと and 演算子が優先度負けて危険だった
      def assert &condition
        raise unless condition.call
      end

      def pre_assert
        self.class.verify self
      end

      def post_assert
        self.class.verify self
      end
    end
    parent.wrap self
    prepend parent
  end
end
