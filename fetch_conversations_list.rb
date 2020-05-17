# frozen_string_literal: true

$LOAD_PATH << '.'
require 'slack_parameter_list'
require 'uri_parse'
# @return [File] Slackに登録されているチャンネルの情報をまとめたリスト 形式 { チャンネルID => チャンネル名}
class FetchConversationsList
  include SlackParameterList
  include UriParse
  def initialize
    channel_list = fetch_page(CONVERSATIONS_LIST)
    # URLが取得できた場合は、チャンネル毎にパラメーターを区切ってファイルに保存
    raise 'チャンネルリストの取得に失敗しました。APIキーを再度確認の上、再実行して下さい。' unless channel_list['ok']

    begin
      file = CSV.open('channel_list.csv', 'w:utf-8')
      channel_list['channels'].each do |channel|
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
end
