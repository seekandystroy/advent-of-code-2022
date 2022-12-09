File.read!("input.txt")
|> String.trim()
|> String.graphemes()
|> Stream.chunk_every(4, 1, :discard)
|> Stream.with_index(4)
|> Stream.drop_while(fn {vals, _idx} ->
  length(Enum.uniq(vals)) < 4
end)
|> Enum.take(1)
|> IO.inspect()
