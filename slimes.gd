extends CharacterBody2D
class_name Mob
var speed = 35
enum states {IDLE, CHASE, ATTACK, DEAD, HURT}
var state = states.IDLE
var player
var health = 3
var attack = false
var shoot_direction
var minimap_icon = "mob"
signal removed
@export var projectile : PackedScene
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
			$AnimationPlayer.play("movement")
			velocity = position.direction_to(player.position) * speed * -1
			if velocity.x != 0:
				transform.x.x = sign(velocity.x)
			shoot_direction = position.direction_to(player.position)
			if not attack:
				var Projectile = projectile.instantiate()
				Projectile.start(position, shoot_direction)
				get_tree().root.add_child(Projectile)
				attack = true
				$AttackTimer.start()
		states.ATTACK:
			velocity = Vector2.ZERO
			$AnimationPlayer.play("Attack")
			



func _on_detect_body_entered(body):
	player = body
	state = states.CHASE


func _on_detect_body_exited(body):
	state = states.IDLE


func _on_attack_body_entered(body):
	player = body
	state = states.ATTACK


func _on_attack_body_exited(body):
	state = states.CHASE

func hurt(amount, dir):
	health -= amount
	var prev_state = state
	state = states.HURT
	velocity = dir * 100
	$AnimationPlayer.play("damage")
	await get_tree().create_timer(0.4).timeout
	state = prev_state
	if health <= 0:
		removed.emit(self)
		state = states.DEAD


func _on_attack_timer_timeout():
	attack = false
