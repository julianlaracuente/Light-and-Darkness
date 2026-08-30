extends Room


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("Can press?: " + str(can_press_start))
		if can_press_start:
			can_press_start = false
			await $Fade.fade(1,1.5).finished
			$Fade.hide()
			change_room.emit(next_room.p1_position, next_room.p2_position)
			change_cam_limits.emit(next_room.top_cam_limit, next_room.bottom_cam_limit, next_room.left_cam_limit, next_room.right_cam_limit, next_room.min_cam_zoom, next_room.max_cam_zoom)
