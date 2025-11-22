extends CharacterBody2D

enum PlayerState { RUNNING, JUMPING, SLIDING, STUMBLING }

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var slide_collision: CollisionShape2D = $SlideCollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const LANES: Array[int] = [200, 400, 600]
const LANE_SWITCH_SPEED: float = 800.0
const JUMP_VELOCITY: float = -600.0
const GRAVITY: float = 1800.0

var current_lane: int = 1
var target_lane_x: float = LANES[current_lane]
var state: PlayerState = PlayerState.RUNNING
var is_switching_lanes: bool = false
var has_shield: bool = false
var speed_multiplier: float = 1.0

func _ready():
	Global.is_game_running = true
	slide_collision.disabled = true

func _physics_process(delta: float):
	if not Global.is_game_running:
		return
	
	# Handle lane switching
	if not is_switching_lanes:
		handle_lane_switch_input()
	
	# Smooth lane switching
	if abs(global_position.x - target_lane_x) > 5:
		var direction = sign(target_lane_x - global_position.x)
		velocity.x = direction * LANE_SWITCH_SPEED
		is_switching_lanes = true
	else:
		velocity.x = 0
		global_position.x = target_lane_x
		is_switching_lanes = false
	
	# Handle jumping and sliding
	match state:
		PlayerState.RUNNING:
			handle_running_input()
		PlayerState.JUMPING:
			velocity.y += GRAVITY * delta
			if is_on_floor():
				state = PlayerState.RUNNING
				animation_player.play("run")
		PlayerState.SLIDING:
			velocity.y = 0
			if not animation_player.is_playing():
				state = PlayerState.RUNNING
				collision_shape.disabled = false
				slide_collision.disabled = true
				animation_player.play("run")
		PlayerState.STUMBLING:
			velocity.y += GRAVITY * delta
			if is_on_floor():
				state = PlayerState.RUNNING
				animation_player.play("run")
	
	# Apply gravity when not on floor
	if not is_on_floor() and state != PlayerState.SLIDING:
		velocity.y += GRAVITY * delta
	
	# Move and slide
	move_and_slide()

func handle_lane_switch_input():
	if Input.is_action_just_pressed("ui_left") and current_lane > 0:
		current_lane -= 1
		target_lane_x = LANES[current_lane]
	elif Input.is_action_just_pressed("ui_right") and current_lane < LANES.size() - 1:
		current_lane += 1
		target_lane_x = LANES[current_lane]

func handle_running_input():
	if Input.is_action_just_pressed("ui_up"):
		jump()
	elif Input.is_action_just_pressed("ui_down"):
		slide()

func jump():
	if state == PlayerState.RUNNING:
		state = PlayerState.JUMPING
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump")

func slide():
	if state == PlayerState.RUNNING:
		state = PlayerState.SLIDING
		collision_shape.disabled = true
		slide_collision.disabled = false
		animation_player.play("slide")

func hit_obstacle():
	if has_shield:
		has_shield = false
		# Remove shield visual effect
	else:
		state = PlayerState.STUMBLING
		velocity.y = JUMP_VELOCITY * 0.5
		animation_player.play("stumble")

func activate_shield():
	has_shield = true
	# Add shield visual effect

func activate_speed_boost():
	speed_multiplier = 1.5
	# Add speed boost visual effect
	await get_tree().create_timer(5.0).timeout
	speed_multiplier = 1.0