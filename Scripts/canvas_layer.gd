extends CanvasLayer

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save.json"
const SECURITY_KEY = "1DF7S7H"
var player_data = playerData.new()

func _ready():
	verify_player_data(SAVE_DIR)

func verify_player_data(path: String):
	DirAccess.make_dir_absolute(path)

func save_data(path: String):
	# Open the file with write access
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
		
	var data: Dictionary = {
		"player_data":{
			"health": player_data.health,
			"coins": player_data.coins,
			"global_position":{
				"x": player_data.global_position.x,
				"y": player_data.global_position.y
			}
		}
	}
	
	# Convert data into JSON 
	var json_string = JSON.stringify(data, "\t")
	
	# Save the data 
	file.store_string(json_string)
	
	# Close the file
	file.close()
	print("Save Done!")

func load_data(path: String):
	# Check if file is not exists 
	if !FileAccess.file_exists(path):
		printerr("Cannot open non-existent file at %s!" % [path])
		return
	
	# Open the file with read access
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return

	var content = file.get_as_text()
	# Close the file
	file.close()

	# Convert data into string
	var data = JSON.parse_string(content)
	if data == null:
		printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
		return
	
	# Assign the data	
	player_data = playerData.new()
	player_data.health = data.player_data.health
	player_data.coins = data.player_data.coins
	player_data.global_position = Vector2(data.player_data.global_position.x, data.player_data.global_position.y)
	
	# Print Data into console
	print(player_data.health)
	print(player_data.coins)
	print(player_data.global_position)
	
func _on_save_pressed():
	save_data(SAVE_DIR + SAVE_FILE_NAME)

func _on_load_pressed():
	load_data(SAVE_DIR + SAVE_FILE_NAME)
