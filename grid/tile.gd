@tool
class_name Tile extends Sprite2D

@export_category("Coordinates")
@export var latitude: int : get = _get_latitude, set = _set_latitude
@export var longitude: int : get = _get_longitude, set = _set_longitude
@export var elevation: int : get = _get_elevation, set = _set_elevation

var _latitude: int
var _longitude: int
var _elevation: int


func _ready():
	_update_position()

func _init(init_latitude: int = 0, init_longitude: int = 0, init_elevation: int = 0) -> void:
	_latitude = init_latitude
	_longitude = init_longitude
	_elevation = init_elevation

func _to_string() -> String:
	return "Tile@(%d,%d,%d)" % [latitude, longitude, elevation]

func _get_elevation() -> int:
	return _elevation

func _get_latitude() -> int:
	return _latitude

func _get_longitude() -> int:
	return _longitude

func _set_elevation(value: int) -> void:
	_elevation = value
	_update_position()

func _set_latitude(value: int) -> void:
	_latitude = value
	_update_position()

func _set_longitude(value: int) -> void:
	_longitude = value
	_update_position()

func _update_position() -> void:
	var coord = Coord.new(latitude, longitude, elevation)
	var pos_vector3 = coord.to_vector3()
	position = Vector2(pos_vector3.x, pos_vector3.y)
	z_index = pos_vector3.z
