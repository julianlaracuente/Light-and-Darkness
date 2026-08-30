extends Area2D

signal reset_progress_ratio

# delete the light
func _on_body_entered(body: Node2D) -> void:
	reset_progress_ratio.emit()
