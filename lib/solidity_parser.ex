defmodule SolidityParser do
  @moduledoc """
  Documentation for `SolidityParser`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SolidityParser.hello()
      :world

  """
  def hello do
    :world
  end
def parse_code(contract_code) do
  {:ok, tokens, _} = :solidity_leex.string(String.to_charlist(contract_code))
  {:ok, res} = :solidity_yecc.parse(tokens)
   res |> Enum.map(&({:erlang.element(1, &1), add_new_line(:erlang.element(2, &1))}))
end
def parse_struct(contract_code) do
  do_parse(:struct, contract_code)
end
def parse_event(contract_code) do
   do_parse(:event, contract_code)
end
def parse_fun(contract_code) do
  do_parse(:function, contract_code)
end
defp do_parse(name, conttrace_code) do
  parse_code(conttrace_code)
  |> Enum.filter(&(match(name,&1)))
end
defp match(name,{name, _}) do
   true
end
defp match(_, _) do
   false
end
defp add_new_line(lines) do
  lines = :lists.flatten(lines)
  :erlang.list_to_binary(lines |> Enum.map(&("#{&1}\n")))
end
end
