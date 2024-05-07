defmodule Github do
  import HTTPoison, only: [get: 1]

  def obtem_json(url) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Erro na requisição HTTP: #{status_code}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro ao fazer a solicitação HTTP: #{reason}"}
      _ ->
        {:error, "Erro desconhecido ao fazer a solicitação HTTP."}
    end
  end
end
