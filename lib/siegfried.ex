defmodule Siegfried do
  @behaviour :application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(__MODULE__, [], function: :run)
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Siegfried.Supervisor)
  end

  def run do
    routes = [
      {"/websocket", WsHandler, []}
    ]

    dispatch = :cowboy_router.compile([{:_, routes}])
    {:ok, _} = :cowboy.start_http(:http, 100, [{:port, 8080}],
                                  [{:env, [{:dispatch, dispatch}]}])
  end

  def stop(_state) do
    :ok
  end
end