extends Node3D

const MAX_ROOM_SPAWN = 50
var grid: Grid = Grid.new(20, 20)


var side_directions = {
	"front": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"back": Vector2(0, -1),
	"right": Vector2(1, 0)
}

func _ready():
	while get_child_count() < MAX_ROOM_SPAWN:
		grid.clear_grid()
		for child in get_children():
			child.queue_free()
		print("trying")
		var initial_room: Room = pick_random_with_bias($"../RoomCache".get_children()).duplicate()
		initial_room.set_grid_position(grid, Vector2(0, 0))
		var rooms_to_spawn = [initial_room]
		var spawn_counter = 0
		for room_to_generate in rooms_to_spawn:
			for valid_neighbor_position in room_to_generate.get_accessible_neighbors():
				if grid.get_room_at_position(valid_neighbor_position) == null:
					if grid.get_room_at_position(valid_neighbor_position) != false:
						var sets = []
						for direction in side_directions:
							var side_type_check_room: Room = grid.get_room_at_position(side_directions[direction] + valid_neighbor_position)
							if side_type_check_room == null:
								var type_choice = ["Wall", "Door"].pick_random()
								sets.append(create_set_for_direction(type_choice, direction))
							else:
								sets.append(create_set_for_direction_and_room(direction, side_type_check_room))
						var possible_rooms = intersect_arrays(sets[0], sets[1], sets[2], sets[3])
						var chosen_room = pick_random_with_bias(possible_rooms).duplicate()
						chosen_room.set_grid_position(grid, valid_neighbor_position)
						spawn_counter += 1
						rooms_to_spawn.append(chosen_room)
			if spawn_counter >= MAX_ROOM_SPAWN:
				break
		grid.spawn_grid(self)
	$"../RoomCache".queue_free()


func _process(_delta):
	if Input.is_action_just_released("DebugKey"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("DebugSwapCameras"):
		var cameras = get_tree().get_nodes_in_group("Cameras")
		var current_cam_index = cameras.find(get_viewport().get_camera_3d())
		if current_cam_index + 1 >= cameras.size():
			cameras[0].make_current()
		else:
			cameras[current_cam_index + 1].make_current()



func intersect_arrays(arr1, arr2, arr3, arr4) -> Array:
	var arr2_dict = {}
	for v in arr2:
		arr2_dict[v] = true

	var arr3_dict = {}
	for v in arr3:
		arr3_dict[v] = true

	var arr4_dict = {}
	for v in arr4:
		arr4_dict[v] = true

	var intersection = []
	for v in arr1:
		if arr2_dict.has(v) and arr3_dict.has(v) and arr4_dict.has(v):
			intersection.append(v)

	return intersection

func create_set_for_direction(surface_type, direction):
	match surface_type:
		"Door":
			match direction:
				"front":
					return get_tree().get_nodes_in_group("DoorF")
				"back":
					return get_tree().get_nodes_in_group("DoorB")
				"left":
					return get_tree().get_nodes_in_group("DoorL")
				"right":
					return get_tree().get_nodes_in_group("DoorR")
		"Wall":
			match direction:
				"front":
					return get_tree().get_nodes_in_group("WallF")
				"back":
					return get_tree().get_nodes_in_group("WallB")
				"left":
					return get_tree().get_nodes_in_group("WallL")
				"right":
					return get_tree().get_nodes_in_group("WallR")

func create_set_for_direction_and_room(direction: String, room_to_check: Room):
#	assert(room_to_check == Room, "trying to get side of not room")
	match direction:
		"right":
			var side_type = room_to_check.get_side_type("left")
			return create_set_for_direction(side_type, "right")
		"left":
			var side_type = room_to_check.get_side_type("right")
			return create_set_for_direction(side_type, "left")
		"back":
			var side_type = room_to_check.get_side_type("front")
			return create_set_for_direction(side_type, "back")
		"front":
			var side_type = room_to_check.get_side_type("back")
			return create_set_for_direction(side_type, "front")

func pick_random_with_bias(elements: Array) -> Room:
	var weighted_elements = []
	
	for element in elements:
		for i in range(element.get_generation_weight()):
			weighted_elements.append(element)
	
	return weighted_elements.pick_random()


#func spawnRoomToDoor(room, room_door_index: int, mother_room, mother_room_door_index: int):
#    room.set_global_position(Vector3(0,0,0))
#    add_child(room)
#    var room_door = room.get_node("DoorPositions").get_child(room_door_index)
#    var mother_room_door_position = mother_room.get_node("DoorPositions").get_child(mother_room_door_index).get_global_position()
#    var mother_room_door_rotation = mother_room.get_node("DoorPositions").get_child(mother_room_door_index).get_global_rotation()
#
#    var previous_room_rot = room_door.get_global_rotation()
#    room_door.set_global_rotation(mother_room_door_rotation + Vector3(0, deg_to_rad(180), 0))
#    var difference_of_rot = room_door.get_global_rotation() - previous_room_rot
#    room.set_global_rotation(room.get_global_rotation() + difference_of_rot)
#
#    var previous_room_pos = room_door.get_global_position()
#    room_door.set_global_position(mother_room_door_position)
#    var difference_of_pos = room_door.get_global_position() - previous_room_pos
#    room.set_global_position(room.get_global_position() + difference_of_pos)
#
#    return room
