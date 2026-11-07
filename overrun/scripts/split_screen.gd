extends Node

@onready var players := {
	"1": {
		subviewport = $"HBoxContainer/SubViewportContainer/SubViewport",
		camera = $HBoxContainer/SubViewportContainer/SubViewport/Camera2D,
		player = $"HBoxContainer/SubViewportContainer/SubViewport/Game/player",
	},
	"2": {
		subviewport = $"HBoxContainer/SubViewportContainer2/SubViewport",
		camera = $HBoxContainer/SubViewportContainer2/SubViewport/Camera2D,
		player = $"HBoxContainer/SubViewportContainer/SubViewport/Game/player2",
	}
}


func _ready() -> void:
	players["2"].subviewport.world_2d = players["1"].subviewport.world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
