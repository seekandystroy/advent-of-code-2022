defmodule CrateStacks do
  def move_crate(crates, [amount, from, to]) do
    old_from_stack = Enum.at(crates, from - 1)
    old_to_stack = Enum.at(crates, to - 1)

    {to_add, new_from_stack} = Enum.split(old_from_stack, amount)
    new_to_stack = to_add ++ old_to_stack

    List.replace_at(crates, from - 1, new_from_stack)
    |> List.replace_at(to - 1, new_to_stack)
  end

  def parse([first_line | rest]) do
    # need to know the length
    parsed_first = parse_line(first_line)
    crates_length = length(parsed_first)

    crates = parsed_first ++ Enum.flat_map(rest, &parse_line/1)

    # list of stacks
    Enum.map(1..crates_length, &stack_on_pos(crates, crates_length, &1))
  end

  defp parse_line(crates_line) do
    String.graphemes(crates_line)
    |> Stream.drop(1)
    |> Enum.take_every(4)
  end

  defp stack_on_pos(crates, crates_length, pos) do
    Stream.drop(crates, pos - 1)
    |> Stream.take_every(crates_length)
    |> Enum.drop_while(&Kernel.==(&1, " "))
  end
end

fstream = File.stream!("input.txt")

crates_lines = Enum.take_while(fstream, &(!String.starts_with?(&1, " 1")))

crates =
  CrateStacks.parse(crates_lines)
  |> IO.inspect()

Stream.drop(fstream, length(crates_lines) + 2)
|> Enum.reduce(crates, fn cmd_string, crates ->
  cmd_args =
    String.split(cmd_string)
    |> Stream.drop(1)
    |> Stream.take_every(2)
    |> Enum.map(&String.to_integer/1)

  CrateStacks.move_crate(crates, cmd_args)
end)
|> Stream.map(&List.first/1)
|> Enum.join()
|> IO.inspect()
