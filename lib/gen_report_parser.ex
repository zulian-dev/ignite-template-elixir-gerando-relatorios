defmodule GenReport.Parser do
  @index_nome 0
  @index_horas 1
  @index_dia 2
  @index_mes 3
  @index_ano 4

  @convert_mouth %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }
  def parse_file(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [nome, horas, dia, mes, ano] =
      line
      |> String.trim()
      |> String.split(",")
      |> List.update_at(@index_nome, &String.downcase/1)
      |> List.update_at(@index_horas, &String.to_integer/1)
      |> List.update_at(@index_dia, &String.to_integer/1)
      |> List.update_at(@index_mes, &parse_mouth/1)
      |> List.update_at(@index_ano, &String.to_integer/1)

    [nome, horas, dia, mes, ano]
  end

  defp parse_mouth(mes), do: @convert_mouth[mes]
end
