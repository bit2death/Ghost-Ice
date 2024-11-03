extends Node3D

var ghosts_caught : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.caught_ghost.connect(self._on_ghost_caught)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ghost_caught():
	print("YAY")
	ghosts_caught += 1
	$UI/MarginContainer/GridContainer/CaughtLabel.text = str(ghosts_caught)
