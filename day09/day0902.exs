defmodule Rope do
  def motion([dir, steps], rope) do
    Enum.reduce(1..steps, {rope, MapSet.new()}, fn _, {[head_pos | rest], tail_path} ->
      new_head_pos = move_head(dir, head_pos)

      {new_rest, new_tail_pos} =
        Enum.map_reduce(rest, new_head_pos, fn cur_pos, prv_pos ->
          new_cur_pos = move_tail(prv_pos, cur_pos)

          {new_cur_pos, new_cur_pos}
        end)

      {[new_head_pos | new_rest], MapSet.put(tail_path, new_tail_pos)}
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

rope = Enum.map(1..10, fn _ -> {0, 0} end)

{_, visited} =
  File.stream!("input.txt")
  |> Stream.map(&String.split/1)
  |> Stream.map(fn [dir, steps] -> [dir, String.to_integer(steps)] end)
  |> Enum.reduce({rope, MapSet.new()}, fn motion, {rope, visited} ->
    {new_rope, tail_path} = Rope.motion(motion, rope)

    {new_rope, MapSet.union(visited, tail_path)}
  end)

MapSet.size(visited)
|> IO.inspect()
