# Protocol vs Behavior

- protocol defines interface that can be implemented by specific data structure,
  then you can pass the data structure to the protocol module functions
- behavior defines interface of the module itself, then you can pass the module itself to some
  function that expects this interface to be implemented by the module
- behavior can also be used to "include" some reusable functionality into a module

## Protocol

- defines functions that should be implemented (and nothing else)
- can be implemented outside of the target module
- when module implements the protocol, the protocol module functions can be called with implementing
  structures as first param
- main motivation for usage - you want a generic way to work with some kind of structure,
  without actually caring about it's specific type, e.g. Enum.map on lists, streams, maps, ranges, ...
- built-in protocols from stdlib:
  - `String.Chars` - provides `to_string`
  - `List.Chars` - provides `to_charlist`
  - `Collectable` - defines `into`, mainly used by `Enum.Into`
  - `Enumerable` - defines `reduce`, `count`, `member?` and `slice`, used by `Enum` and `Stream` modules
  - `Inspect` - for pretty printing, defines `inspect`
- example:

```elixir
defprotocol Repository do
  def all(repo)
  def find(repo, id)
  def save(repo, id, item)
end

defimpl Repository, for: Map do
  def all(repo), do: Map.values(repo)
  def find(repo, id), do: Map.get(repo, id)
  def save(repo, id, item), do: Map.put(repo, id, item)
end

map_repo = %{
  a: 1, b: 2, c: 3,
}

Repository.all(map_repo) # [1, 2, 3]
Repository.find(map_repo, :b) # 2
map_repo
|> Repository.save(:d, 4)
|> Repository.find(:d) # 4
```

## Behavior

- defines functions that should be implemented and can provide other functions, that rely on these
- is always implemented inside the target module
- motivations:
  - you want to bring some common functionality into the module (to avoid duplication), you will
    still call the module functions explicitly, e.g. Task, Agent, GenServer
  - you will be passing the module itself to some other function, that expects it to have some functions
- example of the second case:
```elixir
defmodule Parser do
  @callback parse(String.t) :: {:ok, term} | {:error, atom}
end

defmodule JSONParser do
  @behaviour Parser

  @impl Parser
  def parse(str), do: {:ok, "some json " <> str} # ... parse JSON
end

# MyFileHandler expects parser to have the `parse(string)` method
MyFileHandler.process(file, JSONParser)
```

# Macros

## Special hook macros

```
~/.asdf/installs/elixir/1.15.5-otp-26/lib/elixir/lib (0586b37)
❯ rg --no-heading --no-line-number --no-filename -o '__\w+__' | sort | uniq
__access__
__after_compile__
__after_verify__
__aliases__
__before_compile__
__behaviour__
__block__
__build__
__built_in__
__CALLER__
__check_attributes__
__cursor__
__dbg__
__derive__
__deriving__
__DIR__
__ensure_defimpl__
__env__
__ENV__
__eval__
__exception__
__FILE__
__functions__
__functions_spec__
__get_attribute__
__impl__
__import__
__info__
__keyword__
__merge__
__MODULE__
__on_definition__
__open__
__protocol__
__put_attribute__
__record__
__records__
__recv_opt_info__
__RELATIVE__
__STACKTRACE__
__struct__
__target__
__unregister__
__using__
```
