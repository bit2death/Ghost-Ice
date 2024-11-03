extends Area3D

var being_sucked = false
var caught = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if being_sucked:
		var players = get_tree().get_nodes_in_group("player")
		look_at(players[0].vacuumNozzle.global_position, Vector3.UP) if global_position != players[0].vacuumNozzle.global_position else rotation
		for player in players:
			global_position = global_position.move_toward(player.vacuumNozzle.global_position, delta * 2/global_position.distance_to(player.vacuumNozzle.global_position))
	if caught:
		being_sucked = false
		scale -= Vector3(delta, delta, delta)
		if(scale.x < .2):
			queue_free()
	# hover and float around a little

func suck():
	being_sucked = true

func get_caught():
	# suck animation
	caught = true
