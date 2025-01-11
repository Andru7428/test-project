extends CharacterBody2D


@export var speed: float = 300.0
@export var jump_velocity: float = 400.0
@export var coyote_frames: float = 6

var jump_ready: bool = false
var coyote: bool = false
var last_floor: bool = false
var jumping: bool = false

func _ready() -> void:
	$CoyoteTimer.wait_time = coyote_frames / 60

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		$Sprite.play("fall")
	else:
		jumping = false


	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote:
			jump()
			if coyote:
				print("Coyote jump!")
		else:
			$JumpBuffer.start()
			jump_ready = true
	
	if jump_ready and is_on_floor():
		jump()
	
	if !is_on_floor() and last_floor and !jumping:
		$CoyoteTimer.start()
		coyote = true
	
	last_floor = is_on_floor()

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		if is_on_floor():
			$Sprite.play("walk")
		if direction > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor():
			$Sprite.play("idle")

	move_and_slide()


func jump() -> void:
	velocity.y = -jump_velocity
	jump_ready = false
	jumping = true


func _on_jump_buffer_timeout() -> void:
	jump_ready = false


func _on_coyote_timer_timeout() -> void:
	coyote = false
