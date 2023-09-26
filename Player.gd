extends CharacterBody2D
class_name Player
var run_speed = 75
var attacking = false
var health = 5
enum states {IDLE, CHASE, ATTACK, DEAD, HURT}
var dead = false
var direction
var fireball = false
@export var Fireball : PackedScene
signal health_changed
func _physics_process(delta):
	var input = Input.get_vector("left", "right", "up", "down",)
	velocity = input * run_speed
	if attacking:
		velocity = Vector2.ZERO
		return
	move_and_slide()
	#picking animation
	if not dead:
		if velocity.length() > 0:
			$AnimationPlayer.play("run")
		else:
			$AnimationPlayer.play("idle")
	
		if velocity.x != 0:
			transform.x.x = sign(velocity.x)
	if dead:
		$AnimationPlayer.play("died")
		set_physics_process(false)
		$CollisionShape2D.disabled = true
		
func _input(event):
	if event.is_action_pressed("attack"):
		if not dead:
			attacking = true
			attack()
	if event.is_action_pressed("Fire"):
		if fireball:
			fire()
func attack():
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	attacking = false
	
func hurt(amount, dir):
	health -= amount
	health_changed.emit(health)
	velocity = dir * 100
	print(health)
	await get_tree().create_timer(0.2).timeout
	if health <= 0:
		dead = true

func fire():
	var fireball = Fireball.instantiate()
	fireball.start(position, rotation)
	get_tree().root.add_child(fireball)
	#fireball.position = position
	#var fireball_vars = get_node("/root/Fireball")
	#fireball_vars.direction = velocity
	
	
func _on_hurtbox_body_entered(body):
	body.hurt(1, position.direction_to(body.position))


