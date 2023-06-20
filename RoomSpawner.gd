extends Node3D

const MAX_ROOM_SPAWN = 6

func _ready():
#    var set1 = get_tree().get_nodes_in_group("DoorF")
#    var set2 = get_tree().get_nodes_in_group("WallB")
#    var set3 = get_tree().get_nodes_in_group("WallR")
#    var set4 = get_tree().get_nodes_in_group("WallL")
#    var intersection = intersect_arrays(set1, set2, set3, set4)
#    var room_to_spawn = intersection[0].duplicate()
    $"../RoomCache".get_children().pick_random()

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

func intersect_arrays(arr1, arr2, arr3, arr4):
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
