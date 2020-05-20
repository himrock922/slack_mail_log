# frozen_string_literal: true

$LOAD_PATH << '.'
require 'log_period'
require 'slack_parameter_list'
require 'uri_parse'
require 'parallel'
require 'pry'

# @return [File] Slackに登録されているチャンネルの情報をまとめたリスト 形式 { チャンネルID => チャンネル名}
class FetchSlackInfoList
  include LogPeriod
  include SlackParameterList
  include UriParse
  def initialize; end

  def extract_conversations_list(parameter)
    channels_list = fetch_page(parameter)
    raise 'チャンネルリストの取得に失敗しました。APIキーを再度確認の上、再実行して下さい。' unless channels_list['ok']

    begin
      file = CSV.open('channels_list.csv', 'w:utf-8')
      channels_list['channels'].each do |channel|
        FileUtils.mkdir_p("slack_log/#{channel['name']}") unless FileTest.exist?("slack_log/#{channel['name']}")
        next unless channel['is_channel']

        file.puts [(channel['id']).to_s, (channel['name']).to_s]
      end
      file.close
    rescue IOError => e
      p "class = #{e.class}, message = #{e.message}"
    rescue SystemCallError => e
      p "class = #{e.class}, message = #{e.message}"
    end
  end

  def extract_users_list(parameter)
    users_list = fetch_page(parameter)
    raise 'ユーザリストの取得に失敗しました。APIキーを再度確認の上、再実行して下さい。' unless users_list['ok']

    begin
      file = CSV.open('users_list.csv', 'w:utf-8')
      users_list['members'].each do |user|
        file.puts [(user['id']).to_s, (user['name']).to_s]
      end
      file.close
    rescue IOError => e
      puts "class = #{e.class}, message = #{e.message}"
    rescue SystemCallError => e
      puts "class = #{e.class}, message = #{e.message}"
    end
  end

  def extract_conversations_history(date:, parameter:)
    date = Date.today if date.nil?
    oldest, latest = measure_log_period(date)
    begin
      file = CSV.open('channels_list.csv').read
      Parallel.each(file, in_thread: 4) do |channel|
        channel_history = fetch_channel_history_page(parameter, channel[0], oldest, latest)
        sleep 1
        next unless channel_history['ok']

        FileUtils.mkdir_p("slack_log/#{channel[1]}/#{date}") unless FileTest.exist?("slack_log/#{channel[1]}/#{date}")
        cfile = CSV.open("slack_log/#{channel[1]}/#{date}/channels_history.csv", 'w:utf-8')
        cfile.puts channel_history['messages']
        cfile.close
      end
    rescue IOError => e
      puts "class = #{e.class}, message = #{e.message}"
    rescue SystemCallError => e
      puts "class = #{e.class}, message = #{e.message}"
    end
  end
end
