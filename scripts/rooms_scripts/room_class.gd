extends Node2D
class_name Room

signal shoot_light

"""
Notes :
	TileMap Scale = 10
	Text size = 100
"""

"""
This node will be the superclass for ALL rooms.
Each room must have a reference to each Player in a variable.
This is important because each room will manage the player differently,
using different nodes, logic, and Area2D scenarios.

"""

@onready var player_1 : Player
@onready var player_2  : Player

@export var next_room : Room
@export var p1_position : Vector2
@export var p2_position : Vector2
@export var top_cam_limit: float
@export var bottom_cam_limit: float
@export var left_cam_limit: float
@export var right_cam_limit: float
@export var max_cam_zoom: float
@export var min_cam_zoom: float

@onready var puzzle_sound = get_parent().get_node_or_null("PuzzleSolved")
@onready var light_sound = get_parent().get_node_or_null("LightSound")

var can_press_start = true

signal change_room(p1_pos, p2_pos)
signal change_cam_limits(top,bottom,left,right, min_zoom, max_zoom)
signal win

# this functions is used in game_manager.gd
func set_players_reference(p1 : Player, p2 : Player):
	player_1 = p1
	player_2 = p2

func set_up_players_pos():
	player_1.position = p1_position
	player_2.position = p2_position

func _process(_delta: float) -> void:
	pass

"""
This should implement connecting all the area signals.
This is implemented in a room scene that inherits from
this script. If you want more information, look in the
room scripts folder.
"""
func _ready():
	can_press_start = true

# ---------------- Area Handle ---------------------
func _on_any_area_entered(body: Node2D, area: Area2D):
	if body is Player:
		body.current_area = area

func _on_any_area_exited(body: Node2D):
	if body is Player:
		body.current_area = null

#this is just an example
func _on_area_action(player: Player, area: Area2D):
	# Depending of the area, the action will change
	match area.name:
		"Area2D":  print(player.name + ": lever pulled")
		"Area2D2": print(player.name + ": chest opened")
		_:         print(player.name + " interacted with " + area.name)


func _on_exit_level_body_entered(body: Node2D) -> void:
	await $Fade.fade(1,1.5).finished
	$Fade.hide()
	if next_room == null:
		#change the scene to win screen
		pass
	elif next_room.name == "end_screen":
		print("can press spacebar")
		can_press_start = true 
	change_room.emit(next_room.p1_position, next_room.p2_position)
	change_cam_limits.emit(next_room.top_cam_limit, next_room.bottom_cam_limit, next_room.left_cam_limit, next_room.right_cam_limit, next_room.min_cam_zoom, next_room.max_cam_zoom)
