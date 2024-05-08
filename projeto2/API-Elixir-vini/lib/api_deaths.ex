defmodule ApiDeaths do
  # Função para mostrar mortes quando a lista de mortes está vazia
  def mostra_deaths([], _), do: nil

  # Função para mostrar mortes quando a quantidade é 0
  def mostra_deaths(_, 0), do: nil

  # Função para mostrar mortes com base nos dados fornecidos e na quantidade especificada
  def mostra_deaths(%{"deaths" => deaths} = _data, quantity) do
    deaths
    |> Enum.take(quantity)
    |> Enum.each(&mostra_morte/1)
  end

  # Função para mostrar uma morte específica
  def mostra_morte(death) do
    year = Map.get(death, "year", "Year not provided")
    description = Map.get(death, "description", "Description not provided")
    formatted_year = format_year(year)
    formatted_description = format_description(description)
    IO.puts "> #{formatted_year} | #{formatted_description}"
  end

  # Função para formatar o ano
  defp format_year(year) do
    case String.split(year, ~r/\s+/) do
      [year_part, "BC"] ->
        year_with_zeros = String.pad_leading(year_part, 4, "0")
        "\e[33m#{year_with_zeros} BC\e[0m"
      [year_part, "AD"] ->
        year_with_zeros = String.pad_leading(year_part, 4, "0")
        "\e[33m#{year_with_zeros} AD\e[0m"
      ["BC", year_part] ->
        year_with_zeros = String.pad_leading(year_part, 4, "0")
        "\e[33m#{year_with_zeros} BC\e[0m"
      ["AD", year_part] ->
        year_with_zeros = String.pad_leading(year_part, 4, "0")
        "\e[33m#{year_with_zeros} AD\e[0m"
      [year_part] ->
        year_with_zeros = String.pad_leading(year_part, 4, "0")
        "\e[33m#{year_with_zeros}   \e[0m"
    end
  end

  # Função para formatar a descrição da morte
  defp format_description(description) do
    description
  end
end
