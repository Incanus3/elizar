defmodule Elizar.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :model, :string
      add :plate, :string
      add :release_year, :integer

      timestamps()
    end
  end
end
