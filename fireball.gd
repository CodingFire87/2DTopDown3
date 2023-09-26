extends CharacterBody2D

var direction
var speed = 120
# Called when the node enters the scene tree for the first time.
func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	transform.x.x = sign(velocity.x)
	$AnimationPlayer.play("Fire")


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		pass
	else:
		queue_free()
		body.hurt(1, position.direction_to(body.position))
		

