defmodule Projeto2Web.PageController do
  use Projeto2Web, :controller

  #def home(conn, _params) do
  #  # The home page is often custom made,
  #  # so skip the default app layout.
  #  render(conn, :home, layout: false)
  #end

  def home(conn, _params) do
    developers = ["Felipe", "Daniel", "Vinicius"] # Esta lista pode vir de uma query de banco de dados
    render(conn, :home, developers: developers, layout: false)
  end

  

end
