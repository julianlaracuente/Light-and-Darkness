extends Room


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if can_press_start:
			can_press_start = false
			await $Fade.fade(1,1.5).finished
			$Fade.hide()
			change_room.emit(next_room.p1_position, next_room.p2_position)
			change_cam_limits.emit(next_room.top_cam_limit, next_room.bottom_cam_limit, next_room.left_cam_limit, next_room.right_cam_limit, next_room.min_cam_zoom, next_room.max_cam_zoom)
			fade_out_and_stop_music($"menu music")
			get_tree().call_group("music", "play")
			
			
func fade_out_and_stop_music(music: AudioStreamPlayer):
	var tween = create_tween()
	tween.tween_property(music, "volume_db", -80, 1.5) # FADE THE MUSIC OUT OVER 1.5s
	tween.tween_callback(music.stop)
			
