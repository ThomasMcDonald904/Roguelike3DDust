extends Node3D

@onready var one_door_room = preload("res://Rooms/one_door.tscn")
@onready var two_doors_room = preload("res://Rooms/two_doors.tscn")
@onready var opposite_doors_room = preload("res://Rooms/opposite_doors.tscn")
@onready var four_doors_room = preload("res://Rooms/four_sides.tscn")

@onready var available_rooms = [one_door_room, two_doors_room, opposite_doors_room, four_doors_room]
# Called when the node enters the scene tree for the first time.
func _ready():
	var initial_room = one_door_room.instantiate()
	add_child(initial_room)
	initial_room.set_global_position(Vector3(0,0,0))
	spawnRoomToDoor(four_doors_room, 1, initial_room, 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnRoomToDoor(room, room_door_index: int, mother_room, mother_room_door_index: int):
	var room_instance = room.instantiate()
	room_instance.set_global_position(Vector3(0,0,0))
	add_child(room_instance)
	var room_door = room_instance.get_node("DoorPositions").get_child(room_door_index)
	var mother_room_door_position = mother_room.get_node("DoorPositions").get_child(mother_room_door_index).get_global_position()
	var mother_room_door_rotation = mother_room.get_node("DoorPositions").get_child(mother_room_door_index).get_global_rotation()
	
	var previous_room_rot = room_door.get_global_rotation()
	room_door.set_global_rotation(mother_room_door_rotation + Vector3(0, deg_to_rad(180), 0))
	var difference_of_rot = room_door.get_global_rotation() - previous_room_rot
	room_instance.set_global_rotation(room_instance.get_global_rotation() + difference_of_rot)
	
	var previous_room_pos = room_door.get_global_position()
	room_door.set_global_position(mother_room_door_position)
	var difference_of_pos = room_door.get_global_position() - previous_room_pos
	room_instance.set_global_position(room_instance.get_global_position() + difference_of_pos)
	
