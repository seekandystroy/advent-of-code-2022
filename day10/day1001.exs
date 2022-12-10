cycles =
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

[
  20 * Enum.at(cycles, 19),
  60 * Enum.at(cycles, 59),
  100 * Enum.at(cycles, 99),
  140 * Enum.at(cycles, 139),
  180 * Enum.at(cycles, 179),
  220 * Enum.at(cycles, 219)
]
|> Enum.sum()
|> IO.inspect()
