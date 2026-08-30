extends PathFollow2D

@export var speed: float = 500.0

var is_firing: bool = false
signal stop_projectile_sig

func _ready():
	progress_ratio = 0
	set_process(false) 

func fire():
	progress_ratio = 0
	is_firing = true
	set_process(true) 
	$Light/Sprite2D.show()

func _process(delta: float) -> void:
	progress += speed * delta
	
	if progress_ratio >= 1.0:
		stop_projectile()

func stop_projectile():
	set_process(false)
	is_firing = false
	progress_ratio = 0
	stop_projectile_sig.emit()
