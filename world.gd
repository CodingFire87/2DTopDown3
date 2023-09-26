extends TileMap
var chest_opened = false
var chest_position 
var trapped
var power
@export var Skeleton : PackedScene
@export var reward : PackedScene
func _ready():
	$"CanvasLayer/Power Tutorial".hide()
func _physics_process(delta):
	if chest_opened:
		if trapped:
			var skelly = Skeleton.instantiate()
			add_child(skelly)
			skelly.position = chest_position
			chest_opened = false
			trapped = false
		else:
			var Potion_reward = reward.instantiate()
			add_child(Potion_reward)
			Potion_reward.position.y = chest_position.y + 20
			Potion_reward.position.x = chest_position.x
			chest_opened = false
	if power:
		$"CanvasLayer/Power Tutorial".show()
		await get_tree().create_timer(4).timeout
		$"CanvasLayer/Power Tutorial".hide()
		power = false
