extends Room

func _ready():
	build_layers()
	for area in get_children():
		if area is Area2D:
			if area.name != "WinCondition":
				area.body_entered.connect(_on_any_area_entered.bind(area))
				area.body_exited.connect(_on_any_area_exited)
				area.action.connect(_on_area_action.bind(area))

func build_layers():
	$TileMap/Enviroment.set_cell(Vector2i(-6, -9), 0, Vector2i(2, 5))
	$TileMap/Enviroment.set_cell(Vector2i(-5, -9), 0, Vector2i(2, 5))

func remove_layers():
	$TileMap/Enviroment.set_cell(Vector2i(-6, -9), -1)
	$TileMap/Enviroment.set_cell(Vector2i(-5, -9), -1)

func _on_area_action(player: Player, area: Area2D):
	var sprite : Sprite2D = area.get_node_or_null("Sprite2D")
	# Depending of the area, the action will change
	match area.name:
		"LightButton": 
			shoot_light.emit()
			light_sound.play()
			if sprite:
					sprite.frame = 4
		"Button": 
			if area.revert_changes:
				build_layers()
				area.revert_changes = false
				if sprite != null:
					sprite.frame = 1
			else:
				remove_layers()
				if sprite != null:
					sprite.frame = 4

func delete_door():
	$TileMap/Enviroment.set_cell(Vector2i(10, 5), -1)
	$TileMap/Enviroment.set_cell(Vector2i(10, 6), -1)
	$TileMap/Enviroment.set_cell(Vector2i(9, -1), 0, Vector2(12,10))
	$TileMap/Enviroment.set_cell(Vector2i(9, 0), 0, Vector2(12,11))

func _on_path_follow_2d_stop_projectile_sig() -> void:
	$LightButton/Sprite2D.frame = 1
	$Path2D/PathFollow2D/Light/Sprite2D.hide()
	

func _on_win_condition_area_entered(area: Area2D) -> void:
	if area.name == "Light":
		delete_door()
		$WinCondition/Sprite2D.show()
		puzzle_sound.play()
