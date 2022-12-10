File.stream!("input.txt")
|> Stream.map(&String.split/1)
|> Enum.reduce([1], fn [op | args], [cur_cycle | _] = rcycles ->
  case op do
    "noop" ->
      [cur_cycle | rcycles]

    "addx" ->
      to_add = List.first(args) |> String.to_integer()
      [cur_cycle + to_add | [cur_cycle | rcycles]]
  end
end)
|> Enum.reverse()
|> Stream.drop(-1)
|> Stream.with_index()
|> Enum.each(fn {x, idx} ->
  pos = rem(idx, 40)

  if x - 1 <= pos and pos <= x + 1 do
    IO.write("#")
  else
    IO.write(".")
  end

  if pos == 39, do: IO.puts("")
end)
