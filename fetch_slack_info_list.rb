# frozen_string_literal: true

$LOAD_PATH << '.'
require 'slack_parameter_list'
require 'uri_parse'
# @return [File] Slackに登録されているチャンネルの情報をまとめたリスト 形式 { チャンネルID => チャンネル名}
class FetchSlackInfoList
  include SlackParameterList
  include UriParse

  def initialize; end

  def extract_conversations_list(parameter)
    channels_list = fetch_page(parameter)
    raise 'チャンネルリストの取得に失敗しました。APIキーを再度確認の上、再実行して下さい。' unless channels_list['ok']

    begin
      file = CSV.open('channels_list.csv', 'w:utf-8')
      channels_list['channels'].each do |channel|
        unless FileTest.exist?("slack_log/#{channel['name']}")
          FileUtils.mkdir_p("slack_log/#{channel['name']}")
        end
        file.puts [(channel['id']).to_s, (channel['name']).to_s]
      end
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
    rescue IOError => e
      puts "class = #{e.class}, message = #{e.message}"
    rescue SystemCallError => e
      puts "class = #{e.class}, message = #{e.message}"
    end
  end
end
