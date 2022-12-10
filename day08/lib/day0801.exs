defmodule Grid do
  def visible?(_grid, 1, _), do: true
  def visible?(_grid, _, 1), do: true

  def visible?(grid, x, y) do
    if x == grid[:rows] || y == grid[:cols] do
      true
    else
      visible_from_top?(grid, x, y) || visible_from_bottom?(grid, x, y) ||
        visible_from_left?(grid, x, y) || visible_from_right?(grid, x, y)
    end
  end

  def visible_from_top?(grid, x, y) do
    value = grid[x][y]
    elements_above = Matrex.submatrix(grid, 1..(x - 1), y..y)

    Enum.all?(elements_above, &(&1 < value))
  end

  def visible_from_bottom?(grid, x, y) do
    value = grid[x][y]
    last_row = grid[:rows]

    if x == last_row - 1 do
      grid[last_row][y] < value
    else
      elements_below = Matrex.submatrix(grid, (x + 1)..last_row, y..y)

      Enum.all?(elements_below, &(&1 < value))
    end
  end

  def visible_from_left?(grid, x, y) do
    value = grid[x][y]
    elements_left = Matrex.submatrix(grid, x..x, 1..(y - 1))

    Enum.all?(elements_left, &(&1 < value))
  end

  def visible_from_right?(grid, x, y) do
    value = grid[x][y]
    last_col = grid[:cols]

    if y == last_col - 1 do
      grid[x][last_col] < value
    else
      elements_right = Matrex.submatrix(grid, x..x, (y + 1)..last_col)

      Enum.all?(elements_right, &(&1 < value))
    end
  end
end

grid =
  File.stream!("input.txt")
  |> Enum.map(fn line ->
    String.trim(line)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end)
  |> Matrex.new()

Stream.flat_map(1..grid[:rows], fn row ->
  Enum.map(1..grid[:cols], fn col ->
    if Grid.visible?(grid, row, col), do: 1, else: 0
  end)
end)
|> Enum.sum()
|> IO.inspect()
