extends CharacterBody2D


@export var speed: float = 300.0
@export var acceleration: int = 5

@export var camera: Camera2D

func _ready() -> void:
	$RemoteTransform2D.remote_path = camera.get_path()

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = velocity.move_toward(direction * speed, speed / acceleration)
	
	move_and_slide()
	
	if direction.length() > 0:
		$Sprite.play("walk")
		if direction.x > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
	else:
		$Sprite.play("idle")
	
	var last_direction = direction
