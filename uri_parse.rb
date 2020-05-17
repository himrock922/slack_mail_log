# frozen_string_literal: true

module UriParse
  include SlackParameterList
  # Slackログファイルを作成するためのパラメータ取得のために各リクエストURLに接続
  # @param [String] request_parameter URLパラメータ
  # @return [String] request_list 各リクエストURLから取得した情報をJSON形式に変換した文字列
  def fetch_page(request_parameter)
    uri = SLACK_URI + request_parameter + 'token=' + API_TOKEN + '&pretty=1'
    connect_uri(uri, 10)
  end

  # 作成したURIに接続し、各パラメーターを取得
  # @param [Object] uri 接続するURI
  # @return [String] request_list 接続したURIで取得したJSON文字列をHashに変換した文字列
  def connect_uri(uri, _limit = 10)
    JSON.parse(URI.open(uri).read)
  rescue OpenURI::HTTPError => e
    p [uri.to_s, e.class, e].join(' : ')
  end
end
