defmodule GenReport do
  alias GenReport.Parser

  @users ~w[
    cleiton
    daniele
    danilo
    diego
    giuliano
    jakeliny
    joseph
    mayk
    rafael
    vinicius
  ]s
  @available_years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  @available_months ~w[
    janeiro
    fevereiro
    março
    abril
    maio
    junho
    julho
    agosto
    setembro
    outubro
    novembro
    dezembro
  ]s

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), &sum_values/2)
  end

  def build_from_many do
    {:error, "Insira uma lista de nomes de arquivos"}
  end

  def build_from_many(file_name) do
    file_name
    |> Parser.parse_many_files()
    |> Enum.reduce(report_acc(), &sum_values/2)
  end

  defp sum_values(row, report) do
    report
    |> sum_values_all_hours(row)
    |> sum_values_hours_per_month(row)
    |> sum_values_hours_per_year(row)
  end

  defp sum_values_all_hours(
         %{"all_hours" => all_hours} = report,
         [nome, horas, _dia, _mes, _ano]
       ) do
    all_hours = Map.put(all_hours, nome, all_hours[nome] + horas)
    %{report | "all_hours" => all_hours}
  end

  defp sum_values_hours_per_month(
         %{"hours_per_month" => hours_per_month} = report,
         [nome, horas, _dia, mes, _ano]
       ) do
    user_months = %{hours_per_month[nome] | mes => hours_per_month[nome][mes] + horas}
    hours_per_month = %{hours_per_month | nome => user_months}

    %{report | "hours_per_month" => hours_per_month}
  end

  defp sum_values_hours_per_year(
         %{"hours_per_year" => hours_per_year} = report,
         [nome, horas, _dia, _mes, ano]
       ) do
    user_year = Map.put(hours_per_year[nome], ano, hours_per_year[nome][ano] + horas)
    hours_per_year = Map.put(hours_per_year, nome, user_year)

    %{report | "hours_per_year" => hours_per_year}
  end

  defp report_acc do
    available_months = enum_into(@available_months)
    available_years = enum_into(@available_years)

    all_hours = enum_into(@users)
    hours_per_month = enum_into(@users, available_months)
    hours_per_year = enum_into(@users, available_years)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp enum_into(keys), do: enum_into(keys, 0)
  defp enum_into(keys, values), do: Enum.into(keys, %{}, &{&1, values})
end
