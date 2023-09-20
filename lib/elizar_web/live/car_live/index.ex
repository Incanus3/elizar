defmodule ElizarWeb.CarLive.Index do
  use ElizarWeb, :live_view

  alias Elizar.CarRental
  alias Elizar.CarRental.Car

  import ElizarWeb.Router.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cars, CarRental.list_cars())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Car")
    |> assign(:car, CarRental.get_car!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Car")
    |> assign(:car, %Car{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cars")
    |> assign(:car, nil)
  end

  @impl true
  def handle_info({ElizarWeb.CarLive.FormComponent, {:saved, car}}, socket) do
    {:noreply, stream_insert(socket, :cars, car)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    car = CarRental.get_car!(id)
    {:ok, _} = CarRental.delete_car(car)

    {:noreply, stream_delete(socket, :cars, car)}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.page_header socket={@socket} />

      <.car_table socket={@socket} cars={@streams.cars} />
      <.car_modal socket={@socket} car={@car} action={@live_action} title={@page_title} />
    """
  end

  def page_header(assigns) do
    ~H"""
      <.header>
        Listing Cars
        <:actions>
          <.link patch={repo_new_path(@socket, "cars")}>
            <.button>New Car</.button>
          </.link>
        </:actions>
      </.header>
    """
  end

  def car_table(assigns) do
    ~H"""
      <.table
        id="cars"
        rows={@cars}
        row_click={fn {_id, car} -> JS.navigate(repo_show_path(@socket, "cars", car.id)) end}
      >
        <:col :let={{_id, car}} label="Model"><%= car.model %></:col>
        <:col :let={{_id, car}} label="Plate"><%= car.plate %></:col>
        <:col :let={{_id, car}} label="Release year"><%= car.release_year %></:col>

        <:action :let={{_id, car}}>
          <div class="sr-only">
            <.link navigate={repo_show_path(@socket, "cars", car.id)}>Show</.link>
          </div>
          <.link patch={repo_edit_path(@socket, "cars", car.id)}>Edit</.link>
        </:action>

        <:action :let={{id, car}}>
          <.link
            phx-click={JS.push("delete", value: %{id: car.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    """
  end

  def car_modal(assigns) do
    ~H"""
      <.modal
        :if={@action in [:new, :edit]}
        id="car-modal"
        show
        on_cancel={JS.patch(repo_index_path(@socket, "cars"))}
      >
        <.live_component
          module={ElizarWeb.CarLive.FormComponent}
          id={@car.id || :new}
          title={@title}
          action={@action}
          car={@car}
          patch={repo_index_path(@socket, "cars")}
        />
      </.modal>
    """
  end
end
