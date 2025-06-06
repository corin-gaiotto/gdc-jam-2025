extends Node2D


func _on_fish_boundary_left_area_entered(area: Area2D) -> void:
	area.Direction.x *= -1
	
func _on_fish_boundary_right_area_entered(area: Area2D) -> void:
	area.Direction.x *= -1


func _on_fish_boundary_bottom_area_entered(area: Area2D) -> void:
	area.Direction.y *= -1


func _on_fish_boundary_top_area_entered(area: Area2D) -> void:
	area.Direction.y *= -1
