defmodule ApiTest do
  use ExUnit.Case
  describe "parse_arguments/1" do
    test "deve retornar um mapa vazio quando nenhum argumento é fornecido" do
      # Arrange
      args = []

      # Act
      options = Api.parse_arguments(args)

      # Assert
      assert options == %{}
    end

    test "deve analisar corretamente a opção de quantidade" do
      # Arrange
      args = ["--q", "5"]

      # Act
      options = Api.parse_arguments(args)

      # Assert
      assert options == %{quantity: 5}
    end

    test "deve analisar corretamente a opção de detalhes" do
      # Arrange
      args = ["--d", "5"]

      # Act
      options = Api.parse_arguments(args)

      # Assert
      assert options == %{day: 5}
    end

    test "deve analisar corretamente a opção de mês" do
      # Arrange
      args = ["--m", "5"]

      # Act
      options = Api.parse_arguments(args)

      # Assert
      assert options == %{month: 5}
    end

    test "deve analisar corretamente a opção de tipo" do
      # Arrange
      args = ["--t", "type_value"]

      # Act
      options = Api.parse_arguments(args)

      # Assert
      assert options == %{type: "type_value"}
    end
  end

  describe "merge_options/1" do
    test "deve mesclar opções padrão quando nenhum argumento é fornecido" do
      # Arrange
      args = []

      # Act
      merged_options = Api.merge_options(args)

      # Assert
      assert merged_options == %{quantity: 10, day: nil, month: nil, type: nil}

    end

    test "deve mesclar corretamente a opção de quantidade" do
      # Arrange
      args = ["--q", "5"]

      # Act
      merged_options = Api.merge_options(args)

      # Assert
      assert merged_options == %{quantity: 5, day: nil, month: nil, type: nil}
    end

    test "deve mesclar corretamente a opção de dia" do
      # Arrange
      args = ["--d", "10"]

      # Act
      merged_options = Api.merge_options(args)

      # Assert
      assert merged_options == %{quantity: 10, day: 10, month: nil, type: nil}
    end

    test "deve mesclar corretamente a opção de mês" do
      # Arrange
      args = ["--m", "12"]

      # Act
      merged_options = Api.merge_options(args)

      # Assert
      assert merged_options == %{quantity: 10, day: nil, month: 12, type: nil}
    end

    test "deve mesclar corretamente a opção de tipo" do
      # Arrange
      args = ["--t", "events"]

      # Act
      merged_options = Api.merge_options(args)

      # Assert
      assert merged_options == %{quantity: 10, day: nil, month: nil, type: "events"}
    end

  end

  describe "build_url/1" do
    test "deve construir corretamente a URL para eventos" do
      # Arrange
      options = %{type: "events", day: 1, month: 1}

      # Act
      result = Api.build_url(options)

      # Assert
      assert result == "https://byabbe.se/on-this-day/1/1/events.json"
    end

    test "deve construir corretamente a URL para mortes" do
      # Arrange
      options = %{type: "deaths", day: 1, month: 1}

      # Act
      result = Api.build_url(options)

      # Assert
      assert result == "https://byabbe.se/on-this-day/1/1/deaths.json"
    end

    test "deve construir corretamente a URL para nascimentos" do
      # Arrange
      options = %{type: "births", day: 1, month: 1}

      # Act
      result = Api.build_url(options)

      # Assert
      assert result == "https://byabbe.se/on-this-day/1/1/births.json"
    end

  end

  describe "check_quantity_and_continue/1" do
    test "deve retornar verdadeiro se a quantidade for um número positivo" do
      # Arrange
      options = %{quantity: 10}

      # Act
      result = Api.check_quantity_and_continue(options)

      # Assert
      assert result == true
    end

    test "deve retornar verdadeiro se a quantidade for zero" do
      # Arrange
      options = %{quantity: 0}

      # Act
      result = Api.check_quantity_and_continue(options)

      # Assert
      assert result == true
    end

    test "deve retornar falso se a quantidade for negativa" do
      # Arrange
      options = %{quantity: -5}

      # Act
      result = Api.check_quantity_and_continue(options)

      # Assert
      assert result == false
    end

    test "deve retornar verdadeiro se a quantidade não estiver definida" do
      # Arrange
      options = %{}

      # Act
      result = Api.check_quantity_and_continue(options)

      # Assert
      assert result == true
    end
  end

  describe "type_operation/1" do
    test "deve retornar 0 para o tipo events" do
      # Arrange
      options = %{type: "events"}

      # Act
      result = Api.type_operation(options)

      # Assert
      assert result == 0
    end

    test "deve retornar 1 para o tipo deaths" do
      # Arrange
      options = %{type: "deaths"}

      # Act
      result = Api.type_operation(options)

      # Assert
      assert result == 1
    end

    test "deve retornar 2 para o tipo births" do
      # Arrange
      options = %{type: "births"}

      # Act
      result = Api.type_operation(options)

      # Assert
      assert result == 2
    end
  end

end
