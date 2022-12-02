defmodule Scores do
  def score_line("A X"), do: 3
  def score_line("B X"), do: 1
  def score_line("C X"), do: 2
  def score_line("A Y"), do: 4
  def score_line("B Y"), do: 5
  def score_line("C Y"), do: 6
  def score_line("A Z"), do: 8
  def score_line("B Z"), do: 9
  def score_line("C Z"), do: 7
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(&Scores.score_line/1)
|> Enum.sum()
|> IO.inspect()
