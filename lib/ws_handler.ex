import Logger

defmodule WsHandler do
  @behaviour :cowboy_websocket_handler

  def init({:tcp, :http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_transport_name, req, _opts) do
    {peer_id, _} = :cowboy_req.qs_val("id", req)
    send self, {:register, peer_id}
    {:ok, req, 0, 600000}
  end

  def websocket_handle({:text, msg}, req, state) do
    [peer_id, content] = String.split(msg, ",", parts: 2)
    pid = :gproc.where({:n, :l, peer_id})
    if pid != :undefined do
      send pid, {:message, peer_id, content}
    end
    {:ok, req, state + 1}
  end

  def websocket_info({:register, peer_id}, req, state) do
    :gproc.reg({:n, :l, peer_id})
    {:ok, req, state}
  end

  def websocket_info({:message, sender, content}, req, state) do
    {:reply, {:text, content}, req, state + 1}
  end

  def websocket_terminate(reason, req, state) do
    :ok
  end
end