defmodule Elizar.CarRental.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :model, :string
    field :plate, :string
    field :release_year, :integer

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [:model, :plate, :release_year])
    |> validate_required([:model, :plate, :release_year])
  end
end
