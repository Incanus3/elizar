defmodule ElizarWeb.HomeHTML do
  use ElizarWeb, :html
  import ElizarWeb.Router.Helpers

  def home(assigns) do
    ElizarWeb.Router.Helpers.repo_index_path(assigns.conn, "cars") |> dbg()

    ~H"""
      <.flash_group flash={@flash} />

      <div class="px-4 py-10 sm:px-6 sm:py-28 lg:px-8 lg:py-30 xl:px-10 xl:py-32">
        <div class="mx-auto max-w-xl lg:mx-0">
          <h1 class="text-brand mt-10 flex items-center text-[3rem] font-semibold leading-6">
            Elizar
          </h1>

          <p class="text-[2rem] mt-6 font-semibold leading-10 tracking-tighter text-zinc-900">
            Avaliable repositories:
          </p>

          <ul class="mt-3 list-disc list-inside">
            <li>
              <.link
                navigate={repo_index_path(@conn, "cars")}
                class="text-zinc-900 hover:text-zinc-700"
              >
                Vozidla
              </.link>
            </li>
          </ul>
        </div>
      </div>
    """
  end
end
