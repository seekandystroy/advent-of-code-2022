defmodule Rucksack do
  def group_badge([frst, scnd, thrd]) do
    frst_set =
      String.graphemes(frst)
      |> Enum.uniq()
      |> MapSet.new()

    scnd_set =
      String.graphemes(scnd)
      |> Enum.uniq()
      |> MapSet.new()

    thrd_set =
      String.graphemes(thrd)
      |> Enum.uniq()
      |> MapSet.new()

    MapSet.intersection(frst_set, scnd_set)
    |> MapSet.intersection(thrd_set)
    |> MapSet.to_list()
    |> List.first()
  end

  # Pattern matching gets integer codepoint fom the string
  # These codepoints follow the alphabet
  # codepoints a to z go from 97 to 122
  # subtract 96 to get priority for lowercase
  def priority(<<codepoint::utf8>>) when codepoint >= 97, do: codepoint - 96
  # codepoints A to Z go from 65 to 90
  # subtract 38 to get priority for uppercase
  def priority(<<codepoint::utf8>>) when codepoint <= 90, do: codepoint - 38
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.chunk_every(3)
|> Stream.map(&Rucksack.group_badge/1)
|> Stream.map(&Rucksack.priority/1)
|> Enum.sum()
|> IO.inspect()
