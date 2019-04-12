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
    cycle = Stream.cycle(["abc", "def", "ghi", "jkl", "mno"])
    spawn(__MODULE__, :sent_after, [socket, cycle])
    {:noreply, socket}
  end

  def sent_after(socket, cycle) do
    n = Enum.random(0..10)
    elem = cycle |> Enum.take(n) |> List.last()
    Process.sleep(1000)
    broadcast!(socket, "tick", %{message: elem})
    sent_after(socket, cycle)
  end
end
