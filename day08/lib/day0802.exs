defmodule Grid do
  def scenic_score(grid, x, y) do
    score_top(grid, x, y) * score_bottom?(grid, x, y) * score_left?(grid, x, y) *
      score_right?(grid, x, y)
  end

  def score_top(_grid, 1, _y), do: 0

  def score_top(grid, x, y) do
    value = grid[x][y]
    elements_above = Matrex.submatrix(grid, 1..(x - 1), y..y)

    1 +
      (Enum.reverse(elements_above)
       |> Stream.drop(-1)
       |> Stream.take_while(&(&1 < value))
       |> Enum.to_list()
       |> length)
  end

  def score_bottom?(grid, x, y) do
    value = grid[x][y]
    last_row = grid[:rows]

    if x == last_row do
      0
    else
      elements_below = Matrex.submatrix(grid, (x + 1)..last_row, y..y)

      1 +
        (Stream.drop(elements_below, -1)
         |> Stream.take_while(&(&1 < value))
         |> Enum.to_list()
         |> length)
    end
  end

  def score_left?(_grid, _x, 1), do: 0

  def score_left?(grid, x, y) do
    value = grid[x][y]
    elements_left = Matrex.submatrix(grid, x..x, 1..(y - 1))

    1 +
      (Enum.reverse(elements_left)
       |> Stream.drop(-1)
       |> Stream.take_while(&(&1 < value))
       |> Enum.to_list()
       |> length)
  end

  def score_right?(grid, x, y) do
    value = grid[x][y]
    last_col = grid[:cols]

    if y == last_col do
      0
    else
      elements_right = Matrex.submatrix(grid, x..x, (y + 1)..last_col)

      1 +
        (Stream.drop(elements_right, -1)
         |> Stream.take_while(&(&1 < value))
         |> Enum.to_list()
         |> length)
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

Enum.flat_map(1..grid[:rows], fn row ->
  Enum.map(1..grid[:cols], fn col ->
    Grid.scenic_score(grid, row, col)
  end)
end)
|> Enum.max()
|> IO.inspect()
