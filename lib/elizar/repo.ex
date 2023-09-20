defmodule Elizar.Repo do
  use Ecto.Repo,
    otp_app: :elizar,
    adapter: Ecto.Adapters.Postgres
end
