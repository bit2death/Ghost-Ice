extends Node3D

var is_driving_off = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_driving_off:
		position.z += 5 * delta

func drive_off():
	is_driving_off = true
