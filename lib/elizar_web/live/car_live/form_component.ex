defmodule ElizarWeb.CarLive.FormComponent do
  use ElizarWeb, :live_component

  alias Elizar.CarRental

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage car records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="car-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:model]} type="text" label="Model" />
        <.input field={@form[:plate]} type="text" label="Plate" />
        <.input field={@form[:release_year]} type="number" label="Release year" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Car</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{car: car} = assigns, socket) do
    changeset = CarRental.change_car(car)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"car" => car_params}, socket) do
    changeset =
      socket.assigns.car
      |> CarRental.change_car(car_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"car" => car_params}, socket) do
    save_car(socket, socket.assigns.action, car_params)
  end

  defp save_car(socket, :edit, car_params) do
    case CarRental.update_car(socket.assigns.car, car_params) do
      {:ok, car} ->
        notify_parent({:saved, car})

        {:noreply,
         socket
         |> put_flash(:info, "Car updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_car(socket, :new, car_params) do
    case CarRental.create_car(car_params) do
      {:ok, car} ->
        notify_parent({:saved, car})

        {:noreply,
         socket
         |> put_flash(:info, "Car created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
