extends StaticBody3D
class_name Room


var grid_position = Vector2(0, 0)

# Individual rooms must define what each of these sides are with either: "Wall" or "Door"
var right_side
var left_side
var back
var front

# Should use sides enum
func get_side_type(side: String) -> String:
    match side:
        "right_side":
            return right_side
        "left_side":
            return left_side
        "back":
            return back
        "front":
            return front
        _:
            assert(side in ["right_side", "left_side", "front", "back"], "Given side to get type not part of permited sides")
            return "Error"

func set_grid_position(grid_position: Vector2):
    grid_position = grid_position

func get_grid_position():
    return grid_position

func get_accessible_neighbors() -> Array[Vector2]:
    var neighbor_grid_positions = []
    for door in get_node("DoorPositions").get_children():
        match int(door.rotation_degrees.y):
            -90:
                neighbor_grid_positions.append(get_grid_position() + Vector2(-1, 0))
            90:
                neighbor_grid_positions.append(get_grid_position() + Vector2(1, 0))
            180:
                neighbor_grid_positions.append(get_grid_position() + Vector2(0, -1))
            0:
                neighbor_grid_positions.append(get_grid_position() + Vector2(0, 1))
    return neighbor_grid_positions
