require "rspec"
require "webmock/rspec"
require "btjunkie"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.mock_with :rspec
end