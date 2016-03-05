import Logger

defmodule WsHandler do
  @behaviour :cowboy_websocket_handler

  def init({:tcp, :http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_transport_name, req, _opts) do
    {peer_id, _} = :cowboy_req.qs_val("id", req)
    Process.register(self, String.to_atom(peer_id))
    {:ok, req, :undefined_state}
  end

  def websocket_handle({:text, msg}, req, state) do
    [peer_id, content] = String.split(msg, ",", parts: 2)
    receiver = String.to_atom(peer_id)
    if Process.whereis(receiver) do
      send receiver, {:message, receiver, content}
    end
    {:ok, req, state}
  end

  def websocket_info({:message, sender, content}, req, state) do
    {:reply, {:text, content}, req, state}
  end

  def websocket_terminate(reason, req, state) do
    :ok
  end
end