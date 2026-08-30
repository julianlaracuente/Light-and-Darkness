extends Area2D

@export var hold : bool = false
@export var will_revert_changes : bool = false

var revert_changes := false
signal action(body: Node2D)

func handle_input(player: Node2D, state: String):
	match state:
		"pressed":
			action.emit(player)
			
		"holding":
			if hold:
				action.emit(player)
				
		"released":
			if hold and will_revert_changes:
				revert_changes = true
				action.emit(player)
