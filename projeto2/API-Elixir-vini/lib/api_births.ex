defmodule ApiBirths do
  # Função para mostrar nascimentos quando a lista de nascimentos está vazia
  def mostra_births([], _), do: nil

  # Função para mostrar nascimentos quando a quantidade é 0
  def mostra_births(_, 0), do: nil

  # Função para mostrar nascimentos com base nos dados fornecidos e na quantidade especificada
  def mostra_births(%{"births" => births} = _data, quantity) do
    births
    |> Enum.take(quantity)
    |> Enum.each(&mostra_nascimento/1)
  end

  # Função para mostrar um nascimento específico
  def mostra_nascimento(birth) do
    year = Map.get(birth, "year", "Year not provided")
    description = Map.get(birth, "description", "Description not provided")
    formatted_year = format_year(year)
    formatted_description = format_description(description)
    IO.puts "> #{formatted_year} | #{formatted_description}"
  end

  # Função para formatar o ano de nascimento
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

  # Função para formatar a descrição do nascimento
  defp format_description(description) do
    description
  end
end
