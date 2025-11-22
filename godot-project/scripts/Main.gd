extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var chunk_manager: Node2D = $ChunkManager
@onready var camera: Camera2D = $Camera2D
@onready var ui: Control = $UI

func _ready():
	Global.reset_game()
	Global.is_game_running = true
	
	# Connect UI signals
	ui.restart_pressed.connect(_on_restart_pressed)
	ui.main_menu_pressed.connect(_on_main_menu_pressed)
	ui.close_pressed.connect(_on_close_pressed)

func _process(delta: float):
	if Global.is_game_running:
		# Update distance based on game speed
		Global.add_distance(int(Global.game_speed * delta / 10))
		
		# Check game over conditions
		if player.global_position.y > camera.global_position.y + 500:
			game_over()

func game_over():
	Global.is_game_running = false
	ui.show_game_over()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()