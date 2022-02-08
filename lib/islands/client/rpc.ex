# ┌─────────────────────────────────────────────────────────────────┐
# │ Inspired by the course "Elixir for Programmers" by Dave Thomas. │
# └─────────────────────────────────────────────────────────────────┘
defmodule Islands.Client.RPC do
  @moduledoc """
  Remote procedure calls for the _Game of Islands_.

  ##### Inspired by the course [Elixir for Programmers](https://codestool.coding-gnome.com/courses/elixir-for-programmers) by Dave Thomas.
  """

  alias __MODULE__.{
    CannotConnectToNode,
    ConnectedToNode,
    EngineNodeDown,
    EngineNotStarted,
    GameAlreadyStarted,
    GameAlreadyUnderway,
    GameNotStarted
  }

  alias IO.ANSI.Plus, as: ANSI
  alias Islands.{Engine, Game, Player, Tally}

  @doc """
  Connects to the engine node and starts a new game on that node.
  """
  @spec new_game(node, Game.name(), Player.name(), Player.gender()) ::
          Game.name() | no_return
  def new_game(engine_node, game_name, player_name, gender) do
    if Node.connect(engine_node) do
      ConnectedToNode.message(engine_node) |> ANSI.puts()
    else
      CannotConnectToNode.message(engine_node) |> ANSI.puts()
      self() |> Process.exit(:normal)
    end

    :ok = :global.sync()
    args = [game_name, player_name, gender, self()]

    case :rpc.call(engine_node, Engine, :new_game, args) do
      {:ok, _pid} ->
        game_name

      {:error, {:already_started, _pid}} ->
        GameAlreadyStarted.message(game_name) |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, :nodedown} ->
        EngineNodeDown.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, {:EXIT, {:undef, _}}} ->
        EngineNotStarted.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      error ->
        exit(error)
    end
  end

  @doc """
  Connects to the engine node and adds the second player of a game on that node.
  """
  @spec add_player(node, Game.name(), Player.name(), Player.gender()) ::
          Game.name() | no_return
  def add_player(engine_node, game_name, player_name, gender) do
    if Node.connect(engine_node) do
      ConnectedToNode.message(engine_node) |> ANSI.puts()
    else
      CannotConnectToNode.message(engine_node) |> ANSI.puts()
      self() |> Process.exit(:normal)
    end

    :ok = :global.sync()
    args = [game_name, player_name, gender, self()]

    case :rpc.call(engine_node, Engine, :add_player, args) do
      %Tally{response: {:ok, :player2_added}} ->
        game_name

      %Tally{response: {:error, :player2_already_added}} ->
        GameAlreadyUnderway.message(game_name) |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, {:EXIT, {:undef, _}}} ->
        EngineNotStarted.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, {:EXIT, {:noproc, _}}} ->
        GameNotStarted.message(game_name) |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, :nodedown} ->
        EngineNodeDown.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      error ->
        exit(error)
    end
  end
end
