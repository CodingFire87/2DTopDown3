extends StaticBody2D
class_name crate
var open = false
var minimap_icon = "alert"
signal removed
func _on_area_2d_body_entered(body):
	if not open:
		$AnimationPlayer.play("Open")
		open = true
		var world_vars = get_node("/root/World")
		world_vars.chest_opened = true
		world_vars.chest_position = position
		world_vars.trapped = true
		set_physics_process(false)
		$Area2D/CollisionShape2D.disabled = true
		removed.emit(self)
