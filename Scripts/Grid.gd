extends Node
class_name Grid

var grid

var x_size = 0
var y_size = 0
var centerX
var centerY

# Large initial size is recommended
func _init(_x_size: int, _y_size: int):
	x_size = _x_size
	y_size = _y_size
	centerX = floor(x_size / 2)
	centerY = floor(y_size / 2)
	
	grid = []
	for row in range(y_size):
		var row_buffer = []
		for column in range(x_size):
			row_buffer.append(null)
		grid.append(row_buffer)

func set_position_in_grid(grid_position: Vector2, room: Room):
	# Returns false if couldn't place room because: Reached boundaries or room already there 
	var translatedX = grid_position.x + centerX
	var translatedY = grid_position.y * -1 + centerY
	
	if grid[translatedY][translatedX] != null:
		return false
	if translatedX > x_size or translatedY > y_size:
		return false
	
	grid[translatedY][translatedX] = room
	return true

func get_room_at_position(grid_position: Vector2):
	var translatedX = grid_position.x + centerX
	var translatedY = grid_position.y * -1 + centerY
	return grid[translatedY][translatedX]

func get_grid():
	return grid

func spawn_grid(container: Node):
	for row in grid:
		for item in row:
			if item != null:
				var world_position_x = item.get_grid_position().x * item.get_node("Mesh").scale.x * 2
				var world_position_y = item.get_grid_position().y * item.get_node("Mesh").scale.z * 2
				item.set_global_position(Vector3(world_position_x, 0, world_position_y))
				container.add_child(item)
				
