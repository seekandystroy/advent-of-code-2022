File.read!("input.txt")
|> String.trim()
|> String.graphemes()
|> Stream.chunk_every(14, 1, :discard)
|> Stream.with_index(14)
|> Stream.drop_while(fn {vals, _idx} ->
  length(Enum.uniq(vals)) < 14
end)
|> Enum.take(1)
|> IO.inspect()
