defmodule ApiEvents do
  # Função para mostrar eventos quando a lista de eventos está vazia
  def mostra_events([], _), do: nil

  # Função para mostrar eventos quando a quantidade é 0
  def mostra_events(_, 0), do: nil

  # Função para mostrar eventos com base nos dados fornecidos e na quantidade especificada
  def mostra_events(%{"events" => events} = _data, quantity) do
    events
    |> Enum.take(quantity)
    |> Enum.each(&mostra_evento/1)
  end

  # Função para mostrar um evento específico
  def mostra_evento(event) do
    year = Map.get(event, "year", "Year not provided")
    description = Map.get(event, "description", "Description not provided")
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

  # Função para formatar a descrição do evento
  defp format_description(description) do
    description
  end
end
