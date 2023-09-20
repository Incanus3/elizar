defmodule Elizar.Core.StructRepository do
  @type t() :: %__MODULE__{
          entity_mod: module(),
          storage: map()
        }

  @enforce_keys [:entity_mod, :storage]
  defstruct [:entity_mod, :storage]

  def for(entity_mod), do: %__MODULE__{entity_mod: entity_mod, storage: %{}}

  def from(repo, item_or_attrs) do
    entity_mod = repo.entity_mod

    case item_or_attrs do
      %^entity_mod{} -> item_or_attrs
      %{} -> struct!(repo.entity_mod, keys_to_atoms(item_or_attrs))
    end
  end

  defp keys_to_atoms(map) do
    map |> Enum.map(fn {k, v} -> {key_to_atom(k), v} end) |> Map.new()
  end

  defp key_to_atom(key) when is_atom(key), do: key
  defp key_to_atom(key) when is_binary(key), do: String.to_existing_atom(key)
end

defimpl Elizar.Core.Repository, for: Elizar.Core.StructRepository do
  alias Elizar.Core.StructRepository

  def new!(repo, attrs), do: StructRepository.from(repo, attrs)

  def all(repo), do: Map.values(repo.storage)

  def find(repo, id), do: Map.get(repo.storage, id)

  def save(repo, id, item_or_attrs) do
    %{repo | storage: Map.put(repo.storage, id, StructRepository.from(repo, item_or_attrs))}
  end

  def delete(repo, id), do: %{repo | storage: Map.delete(repo.storage, id)}
end
