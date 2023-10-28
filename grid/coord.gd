## A 3-D coordinate.
@tool
class_name Coord extends Node

var latitude: int
var longitude: int
var elevation: int

enum RelativeDirection {
	UNKNOWN,
	UP,
	DOWN,
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	SOUTHEAST,
	SOUTHWEST,
	NORTHWEST,
}

const CARDINAL_DIRECTIONS = [
	RelativeDirection.UP,
	RelativeDirection.DOWN,
	RelativeDirection.NORTH,
	RelativeDirection.SOUTH,
	RelativeDirection.EAST,
	RelativeDirection.WEST,
]
const COORDINATE_SCALE = 32
const FLAT_BORDER_DIRECTIONS = [
	RelativeDirection.NORTH,
	RelativeDirection.SOUTH,
	RelativeDirection.EAST,
	RelativeDirection.WEST,
	RelativeDirection.NORTHEAST,
	RelativeDirection.SOUTHEAST,
	RelativeDirection.SOUTHWEST,
	RelativeDirection.NORTHWEST,
]


func _init(_latitude: int, _longitude: int, _elevation: int):
	latitude = _latitude
	longitude = _longitude
	elevation = _elevation

func _to_string():
	return "(%d,%d,%d)" % [latitude, longitude, elevation]

func _direction_to_delta(relative_direction: RelativeDirection) -> Coord:
	match relative_direction:
		RelativeDirection.NORTH:
			return Coord.new(1, 0, 0)
		RelativeDirection.EAST:
			return Coord.new(0, 1, 0)
		RelativeDirection.SOUTH:
			return Coord.new(-1, 0, 0)
		RelativeDirection.WEST:
			return Coord.new(0, -1, 0)
		RelativeDirection.UP:
			return Coord.new(0, 0, 1)
		RelativeDirection.DOWN:
			return Coord.new(0, 0, -1)
		RelativeDirection.NORTHEAST:
			return Coord.new(1, 1, 0)
		RelativeDirection.SOUTHEAST:
			return Coord.new(-1, 1, 0)
		RelativeDirection.SOUTHWEST:
			return Coord.new(-1, -1, 0)
		RelativeDirection.NORTHWEST:
			return Coord.new(1, -1, 0)
		_:
			push_warning("Unknown direction passed to _direction_to_delta")
			return Coord.new(0, 0, 0)

## Return the direction to get to a neighboring cube, or RelativeDirection.UNKNOWN if not a neighbor.
func get_relative_direction(other: Coord) -> RelativeDirection:
	match self.minus(other).to_array():
		[1, 0, 0]:
			return RelativeDirection.NORTH
		[0, 1, 0]:
			return RelativeDirection.EAST
		[-1, 0, 0]:
			return RelativeDirection.SOUTH
		[0, -1, 0]:
			return RelativeDirection.WEST
		[0, 0, 1]:
			return RelativeDirection.UP
		[0, 0, -1]:
			return RelativeDirection.DOWN
		_:
			push_warning("%s does not neighbor %s" % [self, other])
			return RelativeDirection.UNKNOWN

func minus(other: Coord) -> Coord:
	return Coord.new(
		other.latitude - latitude,
		other.longitude - longitude,
		other.elevation - elevation,
	)

func plus(other: Coord) -> Coord:
	return Coord.new(
		latitude + other.latitude,
		longitude + other.longitude,
		elevation + other.elevation
	)

func plus_direction(relative_direction: RelativeDirection) -> Coord:
	var delta = _direction_to_delta(relative_direction)
	return plus(delta)

func to_array() -> Array:
	return [latitude, longitude, elevation]

## Returns (x offset, y offset, z-index)
func to_vector3() -> Vector3:
	return Vector3(
		2 * COORDINATE_SCALE * longitude - 2 * COORDINATE_SCALE * latitude, # x offset
		-COORDINATE_SCALE * longitude - COORDINATE_SCALE * latitude - 2 * COORDINATE_SCALE * elevation, # y offset
		-latitude - longitude # z index
	)

static func dir_to_str(dir: RelativeDirection) -> String:
	var _relative_direction_keys: Array = Coord.RelativeDirection.keys()
	return _relative_direction_keys[dir]

static func from_array(a: Array) -> Coord:
	if len(a) != 3:
		push_error("Invalid coord array: %s" % a)
		return null
	return Coord.new(int(a[0]), int(a[1]), int(a[2]))

## Convert key (lat,lng,ele) to Coord
static func from_string(s: String) -> Coord:
	if s == "":
		push_error("Empty coord key")
		return null
	var a = s.trim_prefix("(").trim_suffix(")").split(",")
	return from_array(a)
