# Include hook code here
require 'offline_sweeper'
Rails.configuration.after_initialize do

  class ::ActionController::Caching::Sweeper
    # now we always have a controller, so no silent failures
    def method_missing(method, *arguments)
      @controller ||= OfflineSweeper::FakeController.new
      @controller.__send__(method, *arguments)
    end
  end

  class ::ActionController::Base
    def fragment_cache_key(key)
      ActiveSupport::Cache.expand_cache_key(OfflineSweeper::CacheKey.new(key).to_s, :views)
    end
  end

end

