@tool
class_name Tile extends Sprite2D

@export_category("Coordinates")
@export var latitude: int : get = _get_latitude, set = _set_latitude
@export var longitude: int : get = _get_longitude, set = _set_longitude
@export var elevation: int : get = _get_elevation, set = _set_elevation

@onready var _coord: Coord = Coord.new(0, 0, 0)


func _get_elevation() -> int:
	return _coord.elevation

func _get_latitude() -> int:
	return _coord.latitude

func _get_longitude() -> int:
	return _coord.longitude

func _set_elevation(value: int) -> void:
	_coord.elevation = value
	_update_position()

func _set_latitude(value: int) -> void:
	_coord.latitude = value
	_update_position()

func _set_longitude(value: int) -> void:
	_coord.longitude = value
	_update_position()

func _update_position() -> void:
	var pos_vector3 = _coord.to_vector3()
	position = Vector2(pos_vector3.x, pos_vector3.y)
	z_index = pos_vector3.z
