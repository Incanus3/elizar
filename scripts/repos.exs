alias Elizar.Core.Repository
alias Elizar.Core.StructRepository
alias Elizar.Core.PersistentRepository

# map_repo = %{
#   a: 1, b: 2, c: 3,
# }

# Repository.all(map_repo)
# |> dbg()

# Repository.find(map_repo, :b)
# |> dbg()

# map_repo
# |> Repository.save(:d, 4)
# |> Repository.find(:d)
# |> dbg()

# {:ok, persistent} = PersistentRepository.start_link(map_repo)

# Repository.save(persistent, :d, 4)

# Repository.all(persistent) |> dbg()
# Repository.find(persistent, :d) |> dbg()

defmodule MyEntity do
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end

struct_repo = StructRepository.for(MyEntity)

Repository.new!(struct_repo, %{id: 1, name: "a"}) |> dbg()
Repository.save(struct_repo, 1, %{"id" => 1, "name" => "a"}) |> dbg()

{:ok, persistent_struct_repo} = PersistentRepository.start_link(struct_repo)

Repository.save(persistent_struct_repo, 1, %{"id" => 1, "name" => "a"})

Repository.all(persistent_struct_repo) |> dbg()
Repository.find(persistent_struct_repo, 1) |> dbg()
