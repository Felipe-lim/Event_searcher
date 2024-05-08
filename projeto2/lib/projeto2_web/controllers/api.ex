defmodule Api_event do
  def call_api() do
    System.cmd("cmd", ["/c", "echo hello"])
  end
end

Api_event.call_api()

#defmodule Api_event do
#  def call_api(month, day, type) do
#    escript_path = "api"  # ajuste conforme necessário
#
#    {result, exit_status} = System.cmd(escript_path, ["--m", Integer.to_string(month), "--d", Integer.to_string(day), "--t", type], stderr_to_stdout: true)
#
#    case exit_status do
#      0 -> IO.inspect(result)
#      _ -> IO.puts("Erro ao executar escript: #{result}")
#    end
#  rescue
#    e -> IO.puts("Erro ao executar System.cmd: #{inspect(e)}")
#  end
#end
#
#Api_event.call_api(5, 5, "deaths")
