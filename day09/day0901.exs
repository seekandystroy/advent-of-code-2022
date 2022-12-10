defmodule Rope do
  def motion([dir, steps], head_pos, tail_pos) do
    Enum.reduce(1..steps, {head_pos, tail_pos, MapSet.new()}, fn _,
                                                                 {head_pos, tail_pos, tail_path} ->
      new_head_pos = move_head(dir, head_pos)
      new_tail_pos = move_tail(new_head_pos, tail_pos)

      {new_head_pos, new_tail_pos, MapSet.put(tail_path, new_tail_pos)}
    end)
  end

  defp move_head("R", {x, y}), do: {x + 1, y}
  defp move_head("L", {x, y}), do: {x - 1, y}
  defp move_head("U", {x, y}), do: {x, y + 1}
  defp move_head("D", {x, y}), do: {x, y - 1}

  defp move_tail({hx, hy}, {tx, ty}) when abs(hx - tx) <= 1 and abs(hy - ty) <= 1, do: {tx, ty}
  defp move_tail({x, hy}, {x, ty}) when hy > ty, do: {x, ty + 1}
  defp move_tail({x, hy}, {x, ty}) when hy < ty, do: {x, ty - 1}
  defp move_tail({hx, y}, {tx, y}) when hx > tx, do: {tx + 1, y}
  defp move_tail({hx, y}, {tx, y}) when hx < tx, do: {tx - 1, y}
  defp move_tail({hx, hy}, {tx, ty}) when hx > tx and hy > ty, do: {tx + 1, ty + 1}
  defp move_tail({hx, hy}, {tx, ty}) when hx > tx and hy < ty, do: {tx + 1, ty - 1}
  defp move_tail({hx, hy}, {tx, ty}) when hx < tx and hy > ty, do: {tx - 1, ty + 1}
  defp move_tail({hx, hy}, {tx, ty}) when hx < tx and hy < ty, do: {tx - 1, ty - 1}
end

{_, _, visited} =
  File.stream!("input.txt")
  |> Stream.map(&String.split/1)
  |> Stream.map(fn [dir, steps] -> [dir, String.to_integer(steps)] end)
  |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new()}, fn motion, {head_pos, tail_pos, visited} ->
    {new_head_pos, new_tail_pos, tail_path} = Rope.motion(motion, head_pos, tail_pos)

    {new_head_pos, new_tail_pos, MapSet.union(visited, tail_path)}
  end)

MapSet.size(visited)
|> IO.inspect()
