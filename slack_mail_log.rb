# frozen_string_literal: true

$LOAD_PATH << '.'
require 'fetch_channel_list'
class SlackMailLog
  def initialize
    FetchChannelList.new
  end
end

SlackMailLog.new
