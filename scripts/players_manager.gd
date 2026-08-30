"""
This node holds the players
"""
extends Node2D
@onready var player_1: CharacterBody2D = $Player1
@onready var player_2: CharacterBody2D = $Player2
@onready var multiplayer_camera: Camera2D = $MultiplayerCamera


# 0 = startup, 1 = active, 2 = endscreen
var p1_state = 0
var p2_state = 0


func change_state_all(state:int):
	p1_state = state
	p2_state = state
	player_1.change_state(p1_state)
	player_2.change_state(p2_state)

func start_game():
	multiplayer_camera.add_target(player_1)
	multiplayer_camera.add_target(player_2)
	change_state_all(1)


func _ready() -> void:
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
