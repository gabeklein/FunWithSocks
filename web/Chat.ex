defmodule AChatRoom do
	use Socks.Actor
	require Process
	@emoji <<240, 159, 154, 168>>

	#~~~~~~~~ Access ~~~~~~~~~#

		def init(owner, name, opts) do
			IO.inspect({owner, name, opts})
			Process.flag(:trap_exit, true)
			{:ok, %{
				name: name,
				admin: owner,
				settings: opts,
				denizens: [owner]
			}}
		 end

	#~~~~~~~~ GenServer ~~~~~~~~#

		call :join?, {userPID, userName}, %{denizens: users} do
			#send self, {:message, {"Chatroom", ~s(New user "#{userName}" has joined the lobby!)}}
			emit {:ok, AChatRoom.User}, %{denizens: [userPID | users]}
		end

		info :message, data, %{denizens: users} do
			for user <- users do
				send user, {:said, data}
			end
			nil
		end

		info :yell, message, _ do
			send self, {:message, {@emoji <> "  THE ADMIN " <> @emoji <> " ", message}}
			nil
		end

	#~~~~~~~~~ API ~~~~~~~~~#

		role Admin, AChatRoom.User do

			get "yell", message, %{in: room} do
				send(:the_chatroom, {:yell, message})
				return
			end
		end

		role User, IUserBasic do

			get "say", message, %{username: un, in: room} do
				send room, {:message, {un, message}}
				return
			end

			got :said, {user, message}, %{username: name} do
				if name != user
					do ~s(#{user}: #{message})
					else :nothing
				end |> return
			end

			#remember to remove in production!
			get "crash", do: Process.exit :user_crashed_on_purpose_idk
		end

 end
