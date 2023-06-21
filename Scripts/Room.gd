extends StaticBody3D
class_name Room


var grid_position = Vector2(0, 0)

@export_range(1, 4) var generationWeight = 1 

func _ready():
#	if get_parent().name != "RoomCache":
#		visible = true
	pass

func get_side_type(side: String) -> String:
	match side:
		"right":
			return "Wall" if "WallR" in get_groups() else "Door"
		"left":
			return "Wall" if "WallL" in get_groups() else "Door"
		"back":
			return "Wall" if "WallB" in get_groups() else "Door"
		"front":
			return "Wall" if "WallF" in get_groups() else "Door"
		_:
			assert(side in ["right", "left", "front", "back"], "Given side to get type not part of permited sides")
			return "Error"

func set_grid_position(grid: Grid, _grid_position: Vector2):
	grid.set_position_in_grid(_grid_position, self)
	grid_position = _grid_position

func get_grid_position():
	return grid_position

func get_accessible_neighbors() -> Array:
	var neighbor_grid_positions = []
	
	for group in get_groups():
		match group:
			"DoorR":
				neighbor_grid_positions.append(get_grid_position() + Vector2(1, 0))
			"DoorL":
				neighbor_grid_positions.append(get_grid_position() + Vector2(-1, 0))
			"DoorF":
				neighbor_grid_positions.append(get_grid_position() + Vector2(0, 1))
			"DoorB":
				neighbor_grid_positions.append(get_grid_position() + Vector2(0, -1))
	return neighbor_grid_positions

func get_generation_weight():
	return generationWeight

