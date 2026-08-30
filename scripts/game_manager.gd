extends Node2D

@onready var players = get_node_or_null("Players")
@onready var player_1 = players.get_node_or_null("Player1")
@onready var player_2 = players.get_node_or_null("Player2")
@onready var camera: Camera2D = players.get_node_or_null("MultiplayerCamera")
@onready var start_up_screen: Room = $start_up_screen

"""
This will automatically ensure that ALL the rooms have references for each player.
"""
func set_up_all_rooms():
	for room in get_children():
		if room is Room:
			room.set_players_reference(player_1, player_2)

func _ready() -> void:
	set_up_all_rooms()
	_set_up_players_positions(start_up_screen.p1_position, start_up_screen.p2_position)
	_set_up_cam_limits(start_up_screen.top_cam_limit, start_up_screen.bottom_cam_limit, start_up_screen.left_cam_limit, start_up_screen.right_cam_limit, start_up_screen.min_cam_zoom, start_up_screen.max_cam_zoom)

func _set_up_players_positions(p1_pos, p2_pos):
	player_1.position = p1_pos
	player_2.position = p2_pos



func _set_up_cam_limits(top: Variant, bottom: Variant, left: Variant, right: Variant, min_zoom: Variant, max_zoom: Variant) -> void:
	if camera:
		print("Camera found")
		camera.limit_top = top
		camera.limit_bottom = bottom
		camera.limit_left = left
		camera.limit_right = right
		camera.min_zoom = min_zoom
		camera.max_zoom = max_zoom
	else:
		print("No camera")
