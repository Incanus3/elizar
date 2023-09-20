defprotocol Elizar.Core.Repository do
  def new!(repo, attrs)
  def all(repo)
  def find(repo, id)
  def save(repo, id, item)
  def delete(repo, id)
  # we will probably need some function to convert from map of attrs to item
end

defimpl Elizar.Core.Repository, for: Any do
  # this is useful when you have a module that already implements Repository methods with exactly
  # the same signature internally, but we want to be able to call them using Repository instead of
  # directly
  defmacro __deriving__(module, _struct, _options) do
    quote do
      defimpl Elizar.Core.Repository, for: unquote(module) do
        defdelegate new!(repo, attrs), to: unquote(module)
        defdelegate all(repo), to: unquote(module)
        defdelegate find(repo, id), to: unquote(module)
        defdelegate save(repo, id, item), to: unquote(module)
        defdelegate delete(repo, id), to: unquote(module)
      end
    end
  end

  # we don't really want to define these - there's no sensible default,
  # the Any implementation is just for deriving
  def new!(_repo, _attrs), do: nil
  def all(_repo), do: nil
  def find(_repo, _id), do: nil
  def save(_repo, _id, _item), do: nil
  def delete(_repo, _id), do: nil
end

defimpl Elizar.Core.Repository, for: Map do
  def new!(_repo, attrs), do: attrs
  def all(repo), do: Map.values(repo)
  def find(repo, id), do: Map.get(repo, id)
  def save(repo, id, item), do: Map.put(repo, id, item)
  def delete(repo, id), do: Map.delete(repo, id)
end
