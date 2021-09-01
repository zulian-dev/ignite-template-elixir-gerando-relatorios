defmodule GenReport.ParserTest do
  use ExUnit.Case

  alias GenReport.Parser

  @file_name "gen_report.csv"
  @list_file_names ~w[part_1.csv part_2.csv part_3.csv]s

  describe "parse_file/1" do
    test "parses the file" do
      file_name = @file_name

      response =
        file_name
        |> Parser.parse_file()
        |> Enum.member?(["daniele", 7, 29, "abril", 2018])

      assert response == true
    end
  end

  describe "parse_many_files/1" do
    test "parse many files" do
      file_names = @list_file_names

      parsed_file =
        file_names
        |> Parser.parse_many_files()

      verify_file1 =
        parsed_file
        |> Enum.member?(["daniele", 7, 29, "abril", 2018])

      verify_file2 =
        parsed_file
        |> Enum.member?(["diego", 4, 29, "outubro", 2020])

      verify_file3 =
        parsed_file
        |> Enum.member?(["giuliano", 6, 3, "outubro", 2017])

      response = [true, true, true] === [verify_file1, verify_file2, verify_file3]

      assert response == true
    end
  end
end
