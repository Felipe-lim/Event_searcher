defmodule Api do

  def main(args) do
    # Verifica se não foram fornecidos argumentos
    if Enum.empty?(args) do
      display_usage()

    else
      # Converte os argumentos em um mapa de opções
      args_map = parse_args(args)

      # Verifica se as opções fornecidas pelo usuário são válidas
      case verify_options(args_map) do
        {:ok, true} ->
          # Mescla as opções definidas pelo usuário com as opções padrão
          options = merge_options(args)

          # Verifica se a quantidade de issues é positiva
          if check_quantity_and_continue(options) do
            # Pegando a quantidade de issues a serem mostradas
            quantity = Map.get(options, :quantity)

            # Precisa verificar se irá retornar as issues ou os repositórios
            tipo = type_operation(options)

            # Montando a URL com base nos argumentos da linha de comando
            url = build_url(options)

            # Obtendo o JSON do Github e mostrando o resultado
            Github.obtem_json(url)
            |> mostra_resultado(quantity, tipo)
          end

        {:error, reason} ->
          # Se as opções fornecidas não forem válidas, exibe uma mensagem de erro com o motivo
          IO.puts("Erro: #{reason}")
          display_usage()
      end
    end
  end

  defp display_usage do
    IO.puts("Uso: ./api --m [mês] --d [dia] --t [tipo] [--q [quantidade]]")
    IO.puts("")
    IO.puts("Descrição:")
    IO.puts("  Esta aplicação é usada para obter dados de eventos, mortes ou nascimentos para um determinado dia e mês.")
    IO.puts("")
    IO.puts("Parâmetros:")
    IO.puts("  \e[33m--m\e[0m [mês]         Especifica o mês (intervalo de 1 a 12).")
    IO.puts("  \e[33m--d\e[0m [dia]         Especifica o dia (intervalo de 1 a 31).")
    IO.puts("  \e[33m--t\e[0m [tipo]        Especifica o tipo de dados a serem obtidos (events, deaths ou births).")
    IO.puts("  \e[33m--q\e[0m [quantidade]  Especifica a quantidade de resultados a serem mostrados (padrão é 10).")
    IO.puts("")
    IO.puts("Exemplos de uso:")
    IO.puts("  ./api --m 5 --d 20 --t events              # Obtém eventos para o dia 20 de maio.")
    IO.puts("  ./api --m 3 --d 8 --t deaths --q 5         # Obtém as cinco primeiras mortes para o dia 8 de março.")
    IO.puts("  ./api --m 11 --d 11 --t births             # Obtém nascimentos para o dia 11 de novembro.")
  end

 defp parse_args(args) do
    # Agrupa os argumentos em pares de chave e valor
    args
    |> Enum.chunk_every(2)
    # Converte cada par de argumentos em uma tupla de chave e valor
    |> Enum.map(fn [key, value] -> {key, value} end)
    # Converte a lista de tuplas em um mapa
    |> Enum.into(%{})
  end

  defp verify_options(args) do
    # Lista de argumentos permitidos
    allowed_args = ["--m", "--d", "--t", "--q"]

    # Verifica se todos os argumentos fornecidos estão na lista permitida
    if Enum.all?(args, fn {arg, _value} -> Enum.member?(allowed_args, arg) end) do
      # Verifica se todas as opções necessárias estão presentes
      if Enum.all?(["--m", "--d", "--t"], &Map.has_key?(args, &1)) do
        # Verifica se o valor de "--m" está dentro do intervalo correto (1-12)
        month = String.to_integer(Map.get(args, "--m"))
        if month >= 1 and month <= 12 do
          # Verifica se o valor de "--d" está dentro do intervalo correto (1-31)
          day = String.to_integer(Map.get(args, "--d"))
          if day >= 1 and day <= 31 do
            # Verifica se o valor de "--t" é válido
            type = Map.get(args, "--t")
            if Enum.member?(["events", "deaths", "births"], type) do
              {:ok, true}
            else
              {:error, "O valor para '--t' deve ser 'events', 'deaths' ou 'births'."}
            end
          else
            {:error, "O valor para '--d' deve estar dentro do intervalo de 1 a 31."}
          end
        else
          {:error, "O valor para '--m' deve estar dentro do intervalo de 1 a 12."}
        end
      else
        {:error, "Por favor, forneça as opções '--m', '--d' e '--t'."}
      end
    else
      {:error, "Argumento não reconhecido."}
    end
  end

  def check_quantity_and_continue(options) do
    # Pegando a quantidade de issues a serem mostradas
    quantity = Map.get(options, :quantity)

    # Verifica se a quantidade é maior ou igual a zero
    if quantity >= 0 do
      true
    else
      # Se a quantidade for negativa, exibe uma mensagem de erro
      IO.puts "A quantidade de issues deve ser um número positivo."
      false
    end
  end

  def merge_options(args) do

    # Define as opções padrão
    default_options = %{quantity: 10, day: nil, month: nil, type: nil}

    # Analisa os argumentos da linha de comando
    user_options = parse_arguments(args)

    # Mescla as opções definidas pelo usuário com as opções padrão
    Map.merge(default_options, user_options)

  end

  # Função para analisar os argumentos da linha de comando
  def parse_arguments(args) do
    {options, _, _} = OptionParser.parse(args, switches: [q: :integer, d: :integer, m: :integer, t: :string])
    Enum.reduce(options, %{}, fn
      {:q, value}, acc -> Map.put(acc, :quantity, value)
      {:d, value}, acc -> Map.put(acc, :day, value)
      {:m, value}, acc -> Map.put(acc, :month, value)
      {:t, value}, acc -> Map.put(acc, :type, value)
      _, acc -> acc
    end)
  end

  def type_operation(options) do

    # Obtém o valor do tipo do mapa de opções.
    type = Map.get(options, :type)

    # Condição de correspondência para determinar o valor de retorno com base no tipo.
      case type do
        "events" -> 0
        "deaths" -> 1
        "births" -> 2
    end
  end

  def build_url(options) do

    # Obtém o valor do tipo do mapa de opções.
    type = Map.get(options, :type)

    # Obtém o dia e o mês do mapa de opções.
    day = Map.get(options, :day)
    month = Map.get(options, :month)

    # Constrói a URL com base no tipo.
    "https://byabbe.se/on-this-day/#{month}/#{day}/#{type}.json"
  end

  # Função para mostrar o resultado obtido
  defp mostra_resultado({ :error, _ }, _, _) do
    IO.puts "Ocorreu um erro"
  end

  defp mostra_resultado({:ok, json}, quantity, tipo) do
    { :ok, saida } = Poison.decode(json)

    # Chama a função de dispatch correspondente ao tipo de evento
    dispatch_show_function(tipo, saida, quantity)
  end

  # Função de dispatch para chamar a função correta com base no tipo de evento
  defp dispatch_show_function(0, data, quantity), do: ApiEvents.mostra_events(data, quantity)
  defp dispatch_show_function(1, data, quantity), do: ApiDeaths.mostra_deaths(data, quantity)
  defp dispatch_show_function(2, data, quantity), do: ApiBirths.mostra_births(data, quantity)

end
