# frozen_string_literal: true

require 'csv'
require 'open-uri'
require 'json'
require 'fileutils'
require 'optparse'
require 'optparse/date'
$LOAD_PATH << '.'
require 'fetch_slack_info_list'
require 'slack_parameter_list'

class SlackMailLog
  include SlackParameterList
  def initialize
    params = {}
    begin
      OptionParser.new do |opts|
        opts.on('-d ', '--date', Date)
      end.parse!(ARGV, into: params)
      fetch_slack_info_list = FetchSlackInfoList.new
      fetch_slack_info_list.extract_conversations_list(CONVERSATIONS_LIST)
      fetch_slack_info_list.extract_users_list(USERS_LIST)
      fetch_slack_info_list.extract_conversations_history(date: params[:date], parameter: CONVERSATIONS_HISTORY)
    rescue OptionParser::InvalidArgument => e
      p "#{e.message} 不正な入力です。"
    rescue OptionParser::MissingArgument => e
      p "#{e.message} 入力が指定されていません。"
    end
  end
end

SlackMailLog.new
