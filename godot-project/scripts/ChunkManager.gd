extends Node2D

@export var chunk_scene: PackedScene
@export var obstacle_scenes: Array[PackedScene]
@export var collectible_scenes: Array[PackedScene]

var chunks: Array[Node2D] = []
var spawn_distance: float = 800.0
var despawn_distance: float = 200.0
var last_chunk_y: float = -100.0
var difficulty_timer: float = 0.0

func _ready():
	# Create initial chunks
	for i in range(3):
		spawn_chunk()

func _process(delta: float):
	if not Global.is_game_running:
		return
	
	# Increase difficulty over time
	difficulty_timer += delta
	if difficulty_timer > 10.0:
		Global.game_speed = min(Global.game_speed * 1.05, 600.0)
		difficulty_timer = 0.0
	
	# Check if we need to spawn new chunks
	var player = get_node("../Player")
	if player and player.global_position.y < last_chunk_y - spawn_distance:
		spawn_chunk()
	
	# Remove old chunks
	for chunk in chunks:
		if chunk.global_position.y > player.global_position.y + despawn_distance:
			chunk.queue_free()
			chunks.erase(chunk)

func spawn_chunk():
	var chunk = chunk_scene.instantiate() as Node2D
	add_child(chunk)
	chunk.global_position.y = last_chunk_y
	
	# Generate obstacles and collectibles in this chunk
	generate_chunk_content(chunk)
	
	chunks.append(chunk)
	last_chunk_y -= 400.0  # Chunk height

func generate_chunk_content(chunk: Node2D):
	var num_obstacles = randi_range(2, 4)
	var num_collectibles = randi_range(3, 6)
	
	# Spawn obstacles
	for i in range(num_obstacles):
		var obstacle_type = randi() % obstacle_scenes.size()
		var obstacle = obstacle_scenes[obstacle_type].instantiate()
		chunk.add_child(obstacle)
		
		# Random lane position
		var lane = randi() % 3
		obstacle.global_position.x = [200, 400, 600][lane]
		obstacle.global_position.y = randf_range(-350, -50)
	
	# Spawn collectibles
	for i in range(num_collectibles):
		var collectible_type = randi() % collectible_scenes.size()
		var collectible = collectible_scenes[collectible_type].instantiate()
		chunk.add_child(collectible)
		
		# Random lane position
		var lane = randi() % 3
		collectible.global_position.x = [200, 400, 600][lane]
		collectible.global_position.y = randf_range(-350, -50)