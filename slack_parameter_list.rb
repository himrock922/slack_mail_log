# frozen_string_literal: true

# Slack API経由で情報を取得するためんのAPIトークンやURIパラメータ等をまとめたリスト
module SlackParameterList
  SLACK_URI = 'https://slack.com/api/'
  API_TOKEN = ''
  CONVERSATIONS_LIST = 'conversations.list?'
end

SlackParameterList.freeze
