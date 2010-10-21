# OfflineSweeper
class OfflineSweeper
  class FakeController < ActionController::Base
  end

  class CacheKey
    DEFAULT={:controller=>'cache_controller',:action=>'cache_action'}
    def initialize(args)
      @key = args
      if args.is_a?(Hash)
        @key = ActionController::Routing::Routes.generate(DEFAULT.merge(args.symbolize_keys))
      end
    end
    def to_s
      @key.to_s
    end
  end
end
