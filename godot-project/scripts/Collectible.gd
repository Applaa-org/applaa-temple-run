extends Area2D

enum CollectibleType { COIN, GEM, RELIC, SHIELD, SPEED_BOOST, MAGNET }

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var collectible_type: CollectibleType = CollectibleType.COIN
var value: int = 10
var speed: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	animation_player.play("float")

func _process(delta: float):
	# Move collectible with the game speed
	position.y += Global.game_speed * delta

func _on_body_entered(body: Node):
	if body.name == "Player":
		collect()
		queue_free()

func collect():
	match collectible_type:
		CollectibleType.COIN:
			Global.add_coins(value)
			Global.add_score(value)
		CollectibleType.GEM:
			Global.add_coins(value * 5)
			Global.add_score(value * 10)
		CollectibleType.RELIC:
			Global.add_coins(value * 10)
			Global.add_score(value * 20)
		CollectibleType.SHIELD:
			var player = get_node("../Player") as Player
			player.activate_shield()
		CollectibleType.SPEED_BOOST:
			var player = get_node("../Player") as Player
			player.activate_speed_boost()
		CollectibleType.MAGNET:
			# Activate magnet effect
			pass