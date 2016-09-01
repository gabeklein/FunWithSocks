use Mix.Config

#emergency reference:
	# :global_fallback -- is use when no command is matched down fallback chain
	# :endpoint -- is where new users are sent to 
	# :sub_protocol -- required: websockets being websockets. :/

config :socks,
	#global_fallback: IGlobalDefault,
	endpoint: INewUser,
	sub_protocol: "my-app"

