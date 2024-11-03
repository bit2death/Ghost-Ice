extends CharacterBody3D

@onready var head = $Head
@onready var vacuumArea = $Head/VacuumArea
@onready var anim = $AnimationPlayer
@onready var vacuumNozzle = $Head/suckedArea/CollisionShape3D2

# preset values

signal caught_ghost
signal exit_level

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
var sucking = false

func _ready():
	$Head/Vacuum/CPUParticles3D.emitting = false

func _physics_process(delta: float) -> void:
	if position.y == -30:
		position = self.get_parent().position
	look_handler(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("sprint"):
		max_speed = SPRINT_SPEED
	else:
		max_speed = WALK_SPEED
	
	if Input.is_action_pressed("lmb"):
		vacuum()
		if !sucking:
			sucking = true
			anim.play("suck")
	else:
		if sucking:
			sucking = false
			anim.play("stop_sucking")
	
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

func vacuum():
	# play sfx
	var ghosts = vacuumArea.get_overlapping_areas()
	for item in ghosts:
		if item.is_in_group("ghost"):
			item.suck()
		if item.is_in_group("truck"):
			emit_signal("exit_level")
			# end game cutscene

func look_handler(delta):
	rotation.y += deg_to_rad(-mouse_pos.x) * mouse_sens * delta
	head.rotation.x += deg_to_rad(-mouse_pos.y) * mouse_sens * delta
	head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
	mouse_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.relative


func _on_sucked_area_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("ghost"):
		emit_signal("caught_ghost")
		area.get_caught()
