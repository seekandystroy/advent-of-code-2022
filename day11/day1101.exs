defmodule Monkey do
  defstruct [:items, :op, :test, :true_target, :false_target, inspected: 0]

  def parse([_, items, op, test, true_target, false_target | _]) do
    %Monkey{
      items: parse_items(items),
      op: parse_op(op),
      test: parse_test(test),
      true_target: parse_true_target(true_target),
      false_target: parse_false_target(false_target)
    }
  end

  defp parse_items(items_string) do
    items_string
    |> String.trim()
    |> String.split()
    |> Stream.drop(2)
    |> Stream.map(&String.replace_suffix(&1, ",", ""))
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_op(op_string) do
    op_string
    |> String.replace_prefix("  Operation: new = old ", "")
    |> String.split()
    |> op_fun()
  end

  defp op_fun(["+", "old"]), do: fn old -> old + old end
  defp op_fun(["+", number]), do: fn old -> old + String.to_integer(number) end
  defp op_fun(["*", "old"]), do: fn old -> old * old end
  defp op_fun(["*", number]), do: fn old -> old * String.to_integer(number) end

  defp parse_test(test_string) do
    divisor =
      test_string
      |> String.replace_prefix("  Test: divisible by ", "")
      |> String.trim()
      |> String.to_integer()

    fn worry -> rem(worry, divisor) == 0 end
  end

  defp parse_true_target(true_target_string) do
    true_target_string
    |> String.replace_prefix("    If true: throw to monkey ", "")
    |> String.trim()
    |> String.to_integer()
  end

  defp parse_false_target(false_target_string) do
    false_target_string
    |> String.replace_prefix("    If false: throw to monkey ", "")
    |> String.trim()
    |> String.to_integer()
  end
end

defmodule MonkeyBusiness do
  def round(monkeys) do
    Enum.reduce(0..(length(monkeys) - 1), monkeys, fn idx, monkeys ->
      cur_monkey = Enum.at(monkeys, idx)
      idx_true_target = cur_monkey.true_target
      idx_false_target = cur_monkey.false_target

      true_target_monkey = Enum.at(monkeys, idx_true_target)
      false_target_monkey = Enum.at(monkeys, idx_false_target)

      {rsent_to_true, rsent_to_false} =
        Enum.reduce(cur_monkey.items, {[], []}, fn item, {rsent_to_true, rsent_to_false} ->
          updated_item = cur_monkey.op.(item) |> div(3)

          if cur_monkey.test.(updated_item) do
            {[updated_item | rsent_to_true], rsent_to_false}
          else
            {rsent_to_true, [updated_item | rsent_to_false]}
          end
        end)

      sent_to_true = Enum.reverse(rsent_to_true)
      sent_to_false = Enum.reverse(rsent_to_false)

      updated_monkey = %{
        cur_monkey
        | items: [],
          inspected: cur_monkey.inspected + length(cur_monkey.items)
      }

      updated_true_target_monkey = %{
        true_target_monkey
        | items: true_target_monkey.items ++ sent_to_true
      }

      updated_false_target_monkey = %{
        false_target_monkey
        | items: false_target_monkey.items ++ sent_to_false
      }

      List.replace_at(monkeys, idx, updated_monkey)
      |> List.replace_at(idx_true_target, updated_true_target_monkey)
      |> List.replace_at(idx_false_target, updated_false_target_monkey)
    end)
  end
end

monkeys =
  File.stream!("input.txt")
  |> Stream.chunk_every(7)
  |> Enum.map(&Monkey.parse/1)

Enum.reduce(1..20, monkeys, fn _, monkeys -> MonkeyBusiness.round(monkeys) end)
# |> IO.inspect(charlists: :as_lists)
|> Stream.map(& &1.inspected)
|> Enum.sort(&(&1 >= &2))
|> Stream.take(2)
|> Enum.product()
|> IO.inspect()
