# TODO: Extract to hex package?

defmodule HexClient do
  def packages(opts) do
    get "/packages?" <> URI.encode_query(opts)
  end

  def get(path) do
    %HTTPotion.Response{body: body} = HexClient.Requester.get(path)
    body
  end

  defmodule Requester do
    use HTTPotion.Base

    @version "1.0"
    @user_agent "HexClient/#{@version} (http://toolbox.elixir.pm)"

    def process_url(path) do
      "https://hex.pm/api" <> path
    end

    def process_request_headers(headers) do
      Dict.put headers, :"User-Agent", @user_agent
    end

    def process_response_body(body) do
      body |> IO.iodata_to_binary |> Poison.decode!
    end
  end
end
