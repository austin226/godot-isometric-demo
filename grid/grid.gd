@tool
class_name Grid extends Node2D

@export var focused_layer: int : get = _get_focused_layer, set = _set_focused_layer

var _focused_layer: int = 0

var _min_layer: int = 0
var _max_layer: int = 0

const EXTRA_LAYER_GAP_DOWN: float = Coord.COORDINATE_SCALE * 5
const EXTRA_LAYER_GAP_UP: float = Coord.COORDINATE_SCALE * 7
const LAYER_MOVE_DURATION_S: float = 0.5


func _ready():
	if not Engine.is_editor_hint():
		$"/root/G_GameState".focus_layer_changed.connect(_on_focus_layer_changed)
	for child in get_children():
		if child is GridLayer:
			var layer = child as GridLayer
			layer.position.y = _default_layer_position_y(layer.layer_number)
			_min_layer = min(layer.layer_number, _min_layer)
			_max_layer = max(layer.layer_number, _max_layer)
			print("Layer %d is at %s" % [layer.layer_number, layer.position])
	_get_sorted_layers()
	print("> Grid ready")

func _get_focused_layer() -> int:
	return _focused_layer

func _get_sorted_layers() -> Array:
	var result = []
	for child in get_children():
		if child is GridLayer:
			result.append(child)
	result.sort_custom(_sort_layers)
	return result

func _on_focus_layer_changed(layer_delta: int) -> void:
	focused_layer = clamp(focused_layer + layer_delta, _min_layer, _max_layer)

func _default_layer_position_y(layer_number: int) -> float:
	return -2 * Coord.COORDINATE_SCALE * layer_number

func _move_layer_to_y(layer: GridLayer, y: float) -> void:
	if Engine.is_editor_hint():
		# Just snap immediately
		layer.position.y = y
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(layer, "position:y", y, LAYER_MOVE_DURATION_S)

func _set_focused_layer(value: int) -> void:
	_focused_layer = value
	for layer in _get_sorted_layers():
		var y = _default_layer_position_y(layer.layer_number)
		if layer.layer_number < _focused_layer:
			y += EXTRA_LAYER_GAP_DOWN
		elif layer.layer_number > _focused_layer:
			y -= EXTRA_LAYER_GAP_UP
		_move_layer_to_y(layer, y)
	print("Focused layer: %d" % value)

func _sort_layers(a: GridLayer, b: GridLayer) -> bool:
	return a.layer_number < b.layer_number