@tool
class_name Grid extends Node2D

@export var focused_layer: int = 0


func _ready():
	for child in get_children():
		if child is GridLayer:
			var layer = child as GridLayer
			layer.position.y = -2 * Coord.COORDINATE_SCALE * layer.layer_number
			print("Layer %d is at %s" % [layer.layer_number, layer.position])
	print("> Grid ready")