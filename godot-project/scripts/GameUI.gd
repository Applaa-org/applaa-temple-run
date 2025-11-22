extends Control

signal restart_pressed
signal main_menu_pressed
signal close_pressed

@onready var score_label: Label = $TopPanel/HBoxContainer/ScoreLabel
@onready var coins_label: Label = $TopPanel/HBoxContainer/CoinsLabel
@onready var distance_label: Label = $TopPanel/HBoxContainer/DistanceLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var final_score_label: Label = $GameOverPanel/VBoxContainer/FinalScoreLabel
@onready var final_coins_label: Label = $GameOverPanel/VBoxContainer/FinalCoinsLabel
@onready var final_distance_label: Label = $GameOverPanel/VBoxContainer/FinalDistanceLabel

func _ready():
	game_over_panel.visible = false
	
	# Connect button signals
	$GameOverPanel/VBoxContainer/RestartButton.pressed.connect(func(): restart_pressed.emit())
	$GameOverPanel/VBoxContainer/MainMenuButton.pressed.connect(func(): main_menu_pressed.emit())
	$GameOverPanel/VBoxContainer/CloseButton.pressed.connect(func(): close_pressed.emit())
	
	# Connect global signals
	Global.score_changed.connect(_on_score_changed)
	Global.coins_changed.connect(_on_coins_changed)
	Global.distance_changed.connect(_on_distance_changed)

func _on_score_changed(new_score: int):
	score_label.text = "Score: %d" % new_score

func _on_coins_changed(new_coins: int):
	coins_label.text = "Coins: %d" % new_coins

func _on_distance_changed(new_distance: int):
	distance_label.text = "Distance: %dm" % new_distance

func show_game_over():
	game_over_panel.visible = true
	final_score_label.text = "Final Score: %d" % Global.score
	final_coins_label.text = "Coins Collected: %d" % Global.coins
	final_distance_label.text = "Distance: %dm" % Global.distance