# OfflineSweeper
class OfflineSweeper
  class FakeController < ActionController::Base
  end

  class CacheKey
    DEFAULT={:controller=>'cache_controller',:action=>'cache_action'}
    def initialize(args)
      @key = args
      if args.is_a?(Hash)
        with_dynamic_relative_root(nil) do
          @key = ActionController::Routing::Routes.generate(DEFAULT.merge(args.symbolize_keys))
        end
      end
    end
    def to_s
      @key.to_s
    end

    protected

    def with_dynamic_relative_root(temp_root, &block)
      if defined?(DynamicRelativeRoot)
        begin
          original_root = DynamicRelativeRoot.current_root
          DynamicRelativeRoot.current_root = temp_root
          yield
        ensure
          DynamicRelativeRoot.current_root = original_root
        end
      else
        yield
      end
    end

  end
end
