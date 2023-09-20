defmodule Elizar.Core.PersistentRepository do
  use Agent
  alias Elizar.Core.Repository

  @derive [Repository]

  @enforce_keys :pid
  defstruct [:pid]

  def start_link(repo) do
    with {:ok, pid} <- Agent.start_link(fn -> repo end) do
      {:ok, %__MODULE__{pid: pid}}
    end
  end

  defdelegate new!(repo, attrs), to: Repository

  def all(pers_reg) do
    Agent.get(pers_reg.pid, fn repo -> Repository.all(repo) end)
  end

  def find(pers_reg, id) do
    Agent.get(pers_reg.pid, fn repo -> Repository.find(repo, id) end)
  end

  def save(pers_reg, id, item) do
    Agent.update(pers_reg.pid, fn repo -> Repository.save(repo, id, item) end)
    pers_reg
  end

  def delete(pers_reg, id) do
    Agent.update(pers_reg.pid, fn repo -> Repository.delete(repo, id) end)
    pers_reg
  end
end
