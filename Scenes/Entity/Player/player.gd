extends CharacterBody3D

@onready var head = $Head

# preset values

const WALK_SPEED = 4
const SPRINT_SPEED = 7
const JUMP_VELOCITY = 4.5
const accel = 100
const friction = 200

var speed = 0 # current speed

var max_speed = 10 # current max speed
var direction: Vector3 = Vector3.ZERO
var mouse_sens = 10

var mouse_pos = Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	look_handler(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("sprint"):
		max_speed = SPRINT_SPEED
	else:
		max_speed = WALK_SPEED
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		speed = move_toward(speed, max_speed, accel * delta)
	else:
		direction = velocity.normalized()
		speed = move_toward(speed, 0, friction * delta)
	
	velocity.x = lerp(velocity.x, direction.x * speed, delta * 10)
	velocity.z = lerp(velocity.z, direction.z * speed, delta * 10)
	
	move_and_slide()

func look_handler(delta):
	rotation.y += deg_to_rad(-mouse_pos.x) * mouse_sens * delta
	head.rotation.x += deg_to_rad(-mouse_pos.y) * mouse_sens * delta
	head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
	mouse_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.relative
