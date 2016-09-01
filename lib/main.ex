defmodule FunWithSocks do
	use Application
	@port 8080

	defp routes, do: [
	  {:_, [

	#   {"/", :cowboy_static, {:priv_file, :fun_with_socks, "index.html"}},
	    {'/realtime', Socks.Handle, {}}

	  ]}
	]


	def start(_type, _args) do
		import Supervisor.Spec

		dispatch = :cowboy_router.compile(routes)
		:cowboy.start_http(
			:my_http_listener, 100, 
			[{:port, @port}], 
			[{:env, [{:dispatch, dispatch}]}]
		)
    	IO.puts "Started listening on port #{@port}..."
    	WebSocketSuper.start_link
		Supervisor.start_link(
			[], [name: FunWithSocks.Sup, strategy: :one_for_one]
		)

	end	

  	def stop(_state), do: :ok
end


defmodule WebSocketSuper do
  @behaviour :supervisor

  def start_link do
    :supervisor.start_link {:local, __MODULE__}, __MODULE__, []
  end

  def init([]) do
    {:ok, {{:one_for_one, 10, 10}, []}}
  end
end