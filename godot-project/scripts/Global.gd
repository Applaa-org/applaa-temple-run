extends Node

signal score_changed(new_score: int)
signal coins_changed(new_coins: int)
signal distance_changed(new_distance: int)

var score: int = 0
var coins: int = 0
var distance: int = 0
var high_score: int = 0
var total_coins: int = 0
var game_speed: float = 300.0
var is_game_running: bool = false

func _ready():
	load_high_score()

func add_score(points: int):
	score += points
	score_changed.emit(score)
	if score > high_score:
		high_score = score
		save_high_score()

func add_coins(amount: int):
	coins += amount
	total_coins += amount
	coins_changed.emit(coins)

func add_distance(meters: int):
	distance += meters
	distance_changed.emit(distance)
	add_score(meters) # 1 point per meter

func reset_game():
	score = 0
	coins = 0
	distance = 0
	game_speed = 300.0
	is_game_running = false
	score_changed.emit(score)
	coins_changed.emit(coins)
	distance_changed.emit(distance)

func save_high_score():
	# In a real game, you'd save to file
	pass

func load_high_score():
	# In a real game, you'd load from file
	high_score = 0