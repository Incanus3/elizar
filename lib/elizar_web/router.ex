defmodule ElizarWeb.Router do
  use ElizarWeb, :router

  alias ElizarWeb.HomeController
  alias ElizarWeb.CarLive

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElizarWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    get "/", HomeController, :home

    scope "/repos/" do
      # these would be generated
      live "/cars", CarLive.Index, :index
      live "/cars/new", CarLive.Index, :new
      live "/cars/:id/edit", CarLive.Index, :edit

      live "/cars/:id", CarLive.Show, :show
      live "/cars/:id/show/edit", CarLive.Show, :edit
    end
  end

  defmodule Helpers do
    alias ElizarWeb.Router
    import Phoenix.VerifiedRoutes

    # and these would be generated
    def repo_index_path(conn, base_path),
      do: path(conn, Router, ~p"/repos/#{base_path}")

    def repo_new_path(conn, base_path),
      do: "#{repo_index_path(conn, base_path)}/new"

    def repo_show_path(conn, base_path, id),
      do: "#{repo_index_path(conn, base_path)}/#{id}"

    def repo_edit_path(conn, base_path, id),
      do: "#{repo_show_path(conn, base_path, id)}/edit"

    def repo_show_edit_path(conn, base_path, id),
      do: "#{repo_show_path(conn, base_path, id)}/show/edit"
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElizarWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elizar, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElizarWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
