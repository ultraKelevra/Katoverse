extends Node

func generate_token_for_request():
	randomize()
	var random_n = randi()
	print(str(random_n))
	var hashed = str(random_n).sha256_text()
	print(hashed)
	var timestamp = str(OS.get_unix_time())
	print(timestamp)
	var token = hashed + timestamp
	return token
