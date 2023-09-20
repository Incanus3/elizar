defmodule Elizar.CarRentalTest do
  use Elizar.DataCase

  alias Elizar.CarRental

  describe "cars" do
    alias Elizar.CarRental.Car

    import Elizar.CarRentalFixtures

    @invalid_attrs %{model: nil, plate: nil, release_year: nil}

    test "list_cars/0 returns all cars" do
      car = car_fixture()
      assert CarRental.list_cars() == [car]
    end

    test "get_car!/1 returns the car with given id" do
      car = car_fixture()
      assert CarRental.get_car!(car.id) == car
    end

    test "create_car/1 with valid data creates a car" do
      valid_attrs = %{model: "some model", plate: "some plate", release_year: 42}

      assert {:ok, %Car{} = car} = CarRental.create_car(valid_attrs)
      assert car.model == "some model"
      assert car.plate == "some plate"
      assert car.release_year == 42
    end

    test "create_car/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CarRental.create_car(@invalid_attrs)
    end

    test "update_car/2 with valid data updates the car" do
      car = car_fixture()
      update_attrs = %{model: "some updated model", plate: "some updated plate", release_year: 43}

      assert {:ok, %Car{} = car} = CarRental.update_car(car, update_attrs)
      assert car.model == "some updated model"
      assert car.plate == "some updated plate"
      assert car.release_year == 43
    end

    test "update_car/2 with invalid data returns error changeset" do
      car = car_fixture()
      assert {:error, %Ecto.Changeset{}} = CarRental.update_car(car, @invalid_attrs)
      assert car == CarRental.get_car!(car.id)
    end

    test "delete_car/1 deletes the car" do
      car = car_fixture()
      assert {:ok, %Car{}} = CarRental.delete_car(car)
      assert_raise Ecto.NoResultsError, fn -> CarRental.get_car!(car.id) end
    end

    test "change_car/1 returns a car changeset" do
      car = car_fixture()
      assert %Ecto.Changeset{} = CarRental.change_car(car)
    end
  end
end
