extends CharacterBody2D

var direction
var speed = 120
var bullet_path
# Called when the node enters the scene tree for the first time.
func start(_position, _direction):
	bullet_path = _direction
	position = _position
	velocity = bullet_path * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	transform.x.x = sign(velocity.x)


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		pass
	else:
		queue_free()
		body.hurt(1, position.direction_to(body.position))


func _on_timer_timeout():
	queue_free()
