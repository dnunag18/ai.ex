defmodule AI do
  @moduledoc """
  Starts a web broser.  Go to [http://localhost:15080] to test
  """
  def start(_type, _args) do
    dispatch_config = build_dispatch_config
    { :ok, pid } = :cowboy.start_http(
      :http,
      100,
      [{:port, 15080}],
      [{ :env, [{:dispatch, dispatch_config}]}]
    )
    {:ok, pid}
  end

  def build_dispatch_config do
    :cowboy_router.compile([
      { :_,
        [
          {"/", :cowboy_static, {:priv_file, :ai, "index.html"}},
          {"/static/[...]", :cowboy_static, {:priv_dir,  :ai, "static"}},
          {"/websocket", WebsocketHandler, %{}}
      ]}
    ])
  end
end
