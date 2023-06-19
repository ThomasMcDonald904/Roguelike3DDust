extends Node3D

@onready var one_door_room = preload("res://Rooms/one_door.tscn")
@onready var two_doors_room = preload("res://Rooms/two_doors.tscn")
@onready var opposite_doors_room = preload("res://Rooms/opposite_doors.tscn")
@onready var four_doors_room = preload("res://Rooms/four_sides.tscn")

@onready var available_rooms = [one_door_room, two_doors_room, opposite_doors_room, four_doors_room]
@onready var endcaps = [one_door_room]

const MAX_ROOM_SPAWN = 6

func _ready():
	var initial_room = one_door_room.instantiate()
	add_child(initial_room)
	initial_room.set_global_position(Vector3(0,0,0))
	var room_list = [initial_room]
	var room_spawn_counter = 0
	while room_list.is_empty() == false:
		for room in room_list:
			var room_door_count = room.get_node("DoorPositions").get_child_count()
			for door_index in range(room_door_count):
				var chosen_room = available_rooms[randi_range(0, 3)]
				chosen_room = chosen_room.instantiate()
				var spawned_room = spawnRoomToDoor(chosen_room, randi_range(0, chosen_room.get_node("DoorPositions").get_child_count() - 1), room, door_index )
				if spawned_room not in endcaps:
					room_list.append(spawned_room)
				room_spawn_counter += 1
			room_list.erase(room)
			if room_spawn_counter >= MAX_ROOM_SPAWN:
#				# Add endcaps
#				for final_room in room_list:
#					var final_room_door_count = room.get_node("DoorPositions").get_child_count()
#					for final_door_index in range(final_room_door_count):
#						var chosen_room = endcaps.pick_random()
#						chosen_room = chosen_room.instantiate()
#						spawnRoomToDoor(chosen_room, 0, final_room, final_door_index)
				room_list = []
				break


func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().reload_current_scene()


func spawnRoomToDoor(room, room_door_index: int, mother_room, mother_room_door_index: int):
	room.set_global_position(Vector3(0,0,0))
	add_child(room)
	var room_door = room.get_node("DoorPositions").get_child(room_door_index)
	var mother_room_door_position = mother_room.get_node("DoorPositions").get_child(mother_room_door_index).get_global_position()
	var mother_room_door_rotation = mother_room.get_node("DoorPositions").get_child(mother_room_door_index).get_global_rotation()
	
	var previous_room_rot = room_door.get_global_rotation()
	room_door.set_global_rotation(mother_room_door_rotation + Vector3(0, deg_to_rad(180), 0))
	var difference_of_rot = room_door.get_global_rotation() - previous_room_rot
	room.set_global_rotation(room.get_global_rotation() + difference_of_rot)
	
	var previous_room_pos = room_door.get_global_position()
	room_door.set_global_position(mother_room_door_position)
	var difference_of_pos = room_door.get_global_position() - previous_room_pos
	room.set_global_position(room.get_global_position() + difference_of_pos)
	
	return room
	
