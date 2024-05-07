#defmodule Api_event do
#  def call_api(month, day, type) do
#    # Caminho completo até o escript compilado
#    escript_path = "C:/Users/felip/Documents/UFPB/2023.2/Funcional/proj_api/API-Elixir/api.exe"
#
#    # Comando para executar a API com os argumentos corretos
#    {result, 0} = System.cmd(escript_path, ["--m", Integer.to_string(month), "--d", Integer.to_string(day), "--t", type])
#
#    # Processar o resultado como necessário
#    IO.inspect(result)
#
#  rescue
#    e in RuntimeError -> IO.puts("Erro ao executar escript: #{inspect(e)}")
#  end
#end
#
#Api_event.call_api(5, 5, "deaths")

defmodule Api_event do
  def call_api(month, day, type) do
    escript_path = "C:/API-Elixir "  # ajuste conforme necessário

    {result, exit_status} = System.cmd(escript_path, ["--m", Integer.to_string(month), "--d", Integer.to_string(day), "--t", type], stderr_to_stdout: true)

    case exit_status do
      0 -> IO.inspect(result)
      _ -> IO.puts("Erro ao executar escript: #{result}")
    end
  rescue
    e -> IO.puts("Erro ao executar System.cmd: #{inspect(e)}")
  end
end

Api_event.call_api(5, 5, "deaths")
