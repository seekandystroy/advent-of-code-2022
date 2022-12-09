defmodule Terminal do
  def cmd(["cd", "/"], _path), do: ["/"]
  def cmd(["cd", ".."], [_curr | rest]), do: rest
  def cmd(["cd", dir], path), do: [dir | path]
  def cmd(["ls"], path), do: path
end

defmodule DirStructure do
  def add_child(tree, path, ["dir", dir]) do
    Map.update(tree, path, {0, MapSet.new([dir]), MapSet.new()}, fn {size, dirs, files} ->
      {size, MapSet.put(dirs, dir), files}
    end)
  end

  def add_child(tree, path, [file_size, file]) do
    file_size = String.to_integer(file_size)

    Map.update(tree, path, {file_size, MapSet.new(), MapSet.new([file])}, fn {size, dirs, files} ->
      if MapSet.member?(files, file) do
        {size, dirs, files}
      else
        {size + file_size, dirs, MapSet.put(files, file)}
      end
    end)
  end

  def dir_total_size_depth_first(dirs, path) do
    {size, child_dirs, _} = Map.get(dirs, path)

    {child_dirs_total_sizes, flat_list_of_dirs} =
      Enum.reduce(
        child_dirs,
        {Map.new(), []},
        fn child_dir, {map, list} ->
          {tree, children_list} = dir_total_size_depth_first(dirs, [child_dir | path])

          {Map.merge(map, tree), children_list ++ list}
        end
      )

    children_sizes =
      Enum.map(child_dirs_total_sizes, fn {_child, {child_size, _grandchildren}} ->
        child_size
      end)

    children_size_sum = Enum.sum(children_sizes)

    {
      Map.put(Map.new(), path_string(path), {size + children_size_sum, child_dirs_total_sizes}),
      children_sizes ++ flat_list_of_dirs
    }
  end

  defp path_string(["/"]), do: "/"

  defp path_string(reversed_list_path) do
    Enum.reverse(reversed_list_path)
    |> Enum.join("/")
    |> String.replace_prefix("/", "")
  end
end

{_, dirs} =
  File.stream!("input.txt")
  |> Stream.map(&String.trim/1)
  |> Enum.reduce({[], %{}}, fn line, {path, tree} ->
    case String.split(line, " ", parts: 2) do
      ["$", cmd] -> {Terminal.cmd(String.split(cmd, " ", parts: 2), path), tree}
      file_or_dir -> {path, DirStructure.add_child(tree, path, file_or_dir)}
    end
  end)

{_, sizes} = DirStructure.dir_total_size_depth_first(dirs, ["/"])

Stream.filter(sizes, &(&1 <= 100_000))
|> Enum.sum()
|> IO.inspect()
