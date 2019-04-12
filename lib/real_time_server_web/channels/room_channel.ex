defmodule RealTimeServerWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:after_join, socket) do
    spawn(__MODULE__, :sent_after, [socket])
    {:noreply, socket}
  end

  def sent_after(socket) do
    Process.sleep(1000)
    broadcast!(socket, "tick", %{message: "demo"})
    sent_after(socket)
  end
end
