use Mix.Config

# Here {:ok, 'rays'}...
{:ok, hostname} = :inet.gethostname()

# Here :islands@rays...
islands_node = List.to_atom('islands@' ++ hostname)

config :islands_client_rpc, islands_node: islands_node
