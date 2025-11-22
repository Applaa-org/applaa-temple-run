extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var obstacle_type: String = "wall"
var speed: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta: float):
	# Move obstacle with the game speed
	position.y += Global.game_speed * delta

func _on_body_entered(body: Node):
	if body.name == "Player":
		var player = body as Player
		if obstacle_type == "wall" and player.state == Player.PlayerState.SLIDING:
			# Player slides under wall
			pass
		elif obstacle_type == "low" and player.state == Player.PlayerState.JUMPING:
			# Player jumps over low obstacle
			pass
		else:
			# Player hits obstacle
			player.hit_obstacle()
			Global.game_speed *= 0.8  # Slow down on hit

func destroy():
	queue_free()