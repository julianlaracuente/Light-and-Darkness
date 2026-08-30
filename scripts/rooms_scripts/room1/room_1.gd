extends Room

var player_has_key = false

func _process(_delta: float) -> void:
	pass

# This function automatically connects all areas via signals to specific functions.
func _ready():
	
	$"background music".add_to_group("music")
	
	for area in get_children():
		if area is Area2D:
			area.body_entered.connect(_on_any_area_entered.bind(area))
			area.body_exited.connect(_on_any_area_exited)
			area.action.connect(_on_area_action.bind(area))

func area_key_action():
	player_has_key = true
	var items_layer = $TileMap/Items
	var key_position = Vector2i(-22, -5) 
	items_layer.set_cell(key_position, -1)
	puzzle_sound.play()
	print("Key picked up!")

func area_door_action():
	if player_has_key:
		var door_positions = [Vector2(12,-1), Vector2(12, -2)]
		var enviroment2_layer = $TileMap/Enviroment2
		#eliminate door
		enviroment2_layer.set_cell(door_positions[0], -1)
		enviroment2_layer.set_cell(door_positions[1], -1)
		#put the door open layer
		enviroment2_layer.set_cell(door_positions[0], 0, Vector2(12,11))
		enviroment2_layer.set_cell(door_positions[1], 0, Vector2(12,10))
		print("door open!")
		
		
func _on_area_action(player: Player, area: Area2D):
	# Depending of the area, the action will change
	match area.name:
		"Key": 
			if not player_has_key:
				area_key_action()
		"Door" : area_door_action()
