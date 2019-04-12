defmodule RealtTimeServer.Repo do
  use Ecto.Repo,
    otp_app: :real_time_server,
    adapter: Ecto.Adapters.Postgres
end
