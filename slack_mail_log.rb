# frozen_string_literal: true

require 'csv'
require 'open-uri'
require 'json'
require 'fileutils'
require 'optparse'
require 'optparse/date'
$LOAD_PATH << '.'
require 'fetch_conversations_list'
class SlackMailLog
  def initialize
    params = {}
    begin
      OptionParser.new do |opts|
        opts.on('-d ', '--date', Date)
      end.parse!(ARGV, into: params)
      FetchConversationsList.new
    rescue OptionParser::InvalidArgument => e
      p "#{e.message} 不正な入力です。"
    rescue OptionParser::MissingArgument => e
      p "#{e.message} 入力が指定されていません。"
    end
  end
end

SlackMailLog.new
