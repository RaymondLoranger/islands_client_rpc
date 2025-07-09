# ┌─────────────────────────────────────────────────────────────────┐
# │ Inspired by the course "Elixir for Programmers" by Dave Thomas. │
# └─────────────────────────────────────────────────────────────────┘
defmodule Islands.Client.RPC do
  @moduledoc """
  Remote procedure calls for the _Game of Islands_.

  ##### Inspired by the course [Elixir for Programmers](https://codestool.coding-gnome.com/courses/elixir-for-programmers) by Dave Thomas.
  """

  require Logger

  alias __MODULE__.{
    CannotConnectToNode,
    ConnectedToNode,
    EngineNodeDown,
    EngineNotStarted,
    EnsureEngineStarted,
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

    # Synchronizes the global name server with all nodes known to this node.
    :ok = :global.sync()
    args = [game_name, player_name, gender, self()]

    # Remote procedure call to call a function on a remote node.
    case :rpc.call(engine_node, Engine, :new_game, args) do
      {:ok, _pid} ->
        game_name

      {:error, {:already_started, _pid}} ->
        GameAlreadyStarted.message(game_name, engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      # Extremely unlikely since we've already connected at this point.
      {:badrpc, :nodedown} ->
        EngineNodeDown.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      # E.g. `iex --sname islands_engine` without adding option `-S mix`.
      {:badrpc, {:EXIT, {:undef, _}}} ->
        EngineNotStarted.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      # E.g. on the engine node after app `:hangman_engine` crashed/exited.
      # To fix the problem: Application.ensure_all_started(:islands_engine)
      {:badrpc, {:EXIT, {:noproc, _}}} ->
        EnsureEngineStarted.message(engine_node) |> ANSI.puts()
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

    # Synchronizes the global name server with all nodes known to this node.
    :ok = :global.sync()
    args = [game_name, player_name, gender, self()]

    # Silence console in case game has timed out or game name is inaccurate.
    :logger.set_handler_config(:default, :level, :none)

    # Remote procedure call to call a function on a remote node.
    case :rpc.call(engine_node, Engine, :add_player, args) do
      %Tally{response: {:ok, :player2_added}} ->
        :logger.set_handler_config(:default, :level, Logger.level())
        game_name

      %Tally{response: {:error, :player2_already_added}} ->
        GameAlreadyUnderway.message(game_name, engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      # Extremely unlikely since we've already connected at this point.
      {:badrpc, :nodedown} ->
        EngineNodeDown.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      # E.g. `iex --sname islands_engine` without adding option `-S mix`.
      {:badrpc, {:EXIT, {:undef, _}}} ->
        EngineNotStarted.message(engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      # E.g. the game may have timed out or the game name is inaccurate.
      {:error, {:noproc, _}} ->
        GameNotStarted.message(game_name, engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      # E.g. the game may have timed out or the game name is inaccurate.
      # Will never occur since `Islands.Engine.add_player/4` is actually
      # using `GenServer.Proxy.call/4` as opposed to `GenServer.call/3`.
      {:badrpc, {:EXIT, {:noproc, _}}} ->
        GameNotStarted.message(game_name, engine_node) |> ANSI.puts()
        self() |> Process.exit(:normal)

      error ->
        exit(error)
    end
  end
end
