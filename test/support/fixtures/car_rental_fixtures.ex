defmodule Elizar.CarRentalFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Elizar.CarRental` context.
  """

  @doc """
  Generate a car.
  """
  def car_fixture(attrs \\ %{}) do
    {:ok, car} =
      attrs
      |> Enum.into(%{
        model: "some model",
        plate: "some plate",
        release_year: 42
      })
      |> Elizar.CarRental.create_car()

    car
  end
end
