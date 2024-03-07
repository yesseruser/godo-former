extends CharacterBody2D

const UP = Vector2.UP

@export_category("Movement")
@export var speed := 400.0
@export var stop_step := 40.0
@export var jump_velocity := -800.0
@export var sprite_2d: AnimatedSprite2D
@export var death_height:= 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, stop_step)
	
	if (abs(velocity.x) > 1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
	
	if velocity.x != 0: # Make player stay facing left if they stopped.
		var isLeft = velocity.x < 0
		sprite_2d.flip_h = isLeft
		
	if position.y > death_height:
		die()
	

func die():
	print("Died!")
	get_tree().reload_current_scene()
