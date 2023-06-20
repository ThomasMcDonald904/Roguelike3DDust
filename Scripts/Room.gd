extends StaticBody3D
class_name Room


var grid_position = Vector2(0, 0)

func _ready():
    if get_parent().name != "RoomCache":
        visible = true

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
