defmodule Assignments do
  def either_subset?([b1, e1, b2, e2]) do
    b1 = String.to_integer(b1)
    b2 = String.to_integer(b2)
    e1 = String.to_integer(e1)
    e2 = String.to_integer(e2)

    (b1 >= b2 && e1 <= e2) || (b1 <= b2 && e1 >= e2)
  end
end

File.stream!("input.txt")
|> Stream.map(&String.split(&1, ~r{[\n,-]}, trim: true))
|> Enum.filter(&Assignments.either_subset?/1)
|> length
|> IO.inspect()
