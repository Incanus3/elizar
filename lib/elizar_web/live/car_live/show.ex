defmodule ElizarWeb.CarLive.Show do
  use ElizarWeb, :live_view

  alias Elizar.CarRental
  import ElizarWeb.Router.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:car, CarRental.get_car!(id))}
  end

  defp page_title(:show), do: "Show Car"
  defp page_title(:edit), do: "Edit Car"

  @impl true
  def render(assigns) do
    ~H"""
      <.header>
        Car <%= @car.id %>
        <:subtitle>This is a car record from your database.</:subtitle>
        <:actions>
          <.link patch={repo_show_edit_path(@socket, "cars", @car.id)} phx-click={JS.push_focus()}>
            <.button>Edit car</.button>
          </.link>
        </:actions>
      </.header>

      <.list>
        <:item title="Model"><%= @car.model %></:item>
        <:item title="Plate"><%= @car.plate %></:item>
        <:item title="Release year"><%= @car.release_year %></:item>
      </.list>

      <.back navigate={repo_index_path(@socket, "cars")}>Back to cars</.back>

      <.modal
        :if={@live_action == :edit}
        id="car-modal"
        show
        on_cancel={JS.patch(repo_show_path(@socket, "cars", @car.id))}
      >
        <.live_component
          module={ElizarWeb.CarLive.FormComponent}
          id={@car.id}
          title={@page_title}
          action={@live_action}
          car={@car}
          patch={repo_show_path(@socket, "cars", @car.id)}
        />
      </.modal>
    """
  end
end
