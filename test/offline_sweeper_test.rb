require 'test_helper'

class TestSweeper < ActionController::Caching::Sweeper
end

# much of this cribbed from caching_test.rb
class FragmentCachingTestController < ActionController::Base
  def some_action; end;
end

class OfflineSweeperTest < ActiveSupport::TestCase
  def setup
    ActionController::Base.perform_caching = true
    @hash_key = {
      :controller => 'some_controller',
      :action => 'whatever_action',
      :random_param => 'blah',
    }
    @store = ActiveSupport::Cache::MemoryStore.new
    ActionController::Base.cache_store = @store
    @sweeper = TestSweeper.instance
  end

  def teardown
    ActionController::Base.perform_caching = false
  end

  def test_generate_fragment_string_key_without_controller
    assert @sweeper.fragment_cache_key("key1")
  end

  def test_generate_fragment_hash_key_without_controller
    assert @sweeper.fragment_cache_key(@hash_key)
  end

  def test_fragment_hash_key_is_same_offline_as_for_web_request
    @controller = FragmentCachingTestController.new
    @params = {:controller => 'posts', :action => 'index'}
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @controller.params = @params
    @controller.request = @request
    @controller.response = @response
    @controller.send(:initialize_current_url)
    @controller.send(:initialize_template_class, @response)
    @controller.send(:assign_shortcuts, @request, @response)
    assert_equal @controller.fragment_cache_key(@hash_key), @sweeper.fragment_cache_key(@hash_key)
  end

  def test_offline_sweeper_really_expires_the_fragment_cache
    @store.write("views/key", "value")
    @sweeper.expire_fragment("key")
    assert_nil @store.read("views/key")
  end

  #test "offline sweeper still works as an observer"
  #test "action cache keys work?"
end
