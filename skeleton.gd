extends CharacterBody2D
class_name mob
signal removed
var speed = 40
enum states {IDLE, CHASE, ATTACK, DEAD, HURT}
var state = states.IDLE
var player
var health = 3
var attacking = false
var minimap_icon = "mob"
func _physics_process(delta):
		choose_action()
		move_and_slide()

func choose_action():
	$Label.text = states.keys()[state]
	match state:
		states.DEAD:
			$AnimationPlayer.play("death")
			set_physics_process(false)
			$CollisionShape2D.disabled = true
		states.IDLE:
			$AnimationPlayer.play("idle")
			velocity = Vector2.ZERO
		states.CHASE:
			$AnimationPlayer.play("running")
			velocity = position.direction_to(player.position) * speed
			if velocity.x != 0:
				transform.x.x = sign(velocity.x)
		states.ATTACK:
			velocity = Vector2.ZERO
			attacking = true
			$AnimationPlayer.play("attacking")
			transform.x.x = sign(position.direction_to(player.position).x)
			await $AnimationPlayer.animation_finished
			attacking = false


func _on_detect_body_entered(body):
	player = body
	state = states.CHASE


func _on_detect_body_exited(body):
	state = states.IDLE


func _on_attack_body_entered(body):
	state = states.ATTACK


func _on_attack_body_exited(body):
	if attacking:
		await $AnimationPlayer.animation_finished
	state = states.CHASE

func hurt(amount, dir):
	health -= amount
	var prev_state = state
	state = states.HURT
	velocity = dir * 100
	await get_tree().create_timer(0.2).timeout
	state = prev_state
	if health <= 0:
		removed.emit(self)
		state = states.DEAD



func _on_hurt_box_body_entered(body):
	body.hurt(1, position.direction_to(body.position))
