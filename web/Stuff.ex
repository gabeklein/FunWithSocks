defmodule INewUser do
	use Socks.Role

	get "do nothing" do
		return "ok, nothing has been accomplished."
	end

	get "set thing to", what, _state do
		return "ok done.", %{thing: what}
	end

	get "get the thing", %{thing: thingy} do
		return "that would be " <> thingy
	end

	get "login as", name, _state do
	 	return "logged in.", %{username: name}, IUserLobby
	end

end

defmodule IUserLobby do
	use Socks.Role, IUserBasic

	get "who am i?", %{username: myname} do
		return myname
	end

	get "join chat", %{username: name} do
		pid = :the_chatroom

		{:ok, role} = GenServer.call(pid, {:join?, {self, name}}) |> IO.inspect

		return "joined chatroom", %{in: pid}, role
	end

	get "new chat", state do
		{:ok, pid} = 
			GenServer.start_link(AChatRoom, %{
				denizens: [self]
			})

		Process.register pid, :the_chatroom

		return "ok", %{in: pid}, AChatRoom.Admin
	end

end

defmodule IUserBasic do
	use Socks.Role

	get "ping" do
		return "pong"
	end

	fallback message: "An error that doesn't have to blame me"

end
