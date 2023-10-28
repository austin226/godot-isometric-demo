@tool
class_name Grid extends Node2D

@export var focused_layer: int : get = _get_focused_layer, set = _set_focused_layer

@onready var _game_state: GameState = $"/root/G_GameState"

var _focused_layer: int = 0

var _min_layer: int = 0
var _max_layer: int = 0


func _ready():
	_game_state.focus_layer_changed.connect(_on_focus_layer_changed)
	for child in get_children():
		if child is GridLayer:
			var layer = child as GridLayer
			layer.position.y = -2 * Coord.COORDINATE_SCALE * layer.layer_number
			_min_layer = min(layer.layer_number, _min_layer)
			_max_layer = max(layer.layer_number, _max_layer)
			print("Layer %d is at %s" % [layer.layer_number, layer.position])
	print("> Grid ready")

func _get_focused_layer() -> int:
	return _focused_layer

func _on_focus_layer_changed(layer_delta: int) -> void:
	focused_layer = clamp(focused_layer + layer_delta, _min_layer, _max_layer)

func _set_focused_layer(value: int) -> void:
	_focused_layer = value
	print("Focused layer: %d" % value)