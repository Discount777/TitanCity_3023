extends Camera2D


#var _target_zoom: float = 1.0
#
#const max_zoom: float = 1.5
#const min_zoom: float = 0.6
#const zoom_incr: float =0.1
#const zoom_rate: float = 3
#
#func zoom_in() -> void:
#	_target_zoom= max(_target_zoom - zoom_incr, min_zoom)
#	set_physics_process(true)
#
#func zoom_out() -> void:
#	_target_zoom= min(_target_zoom + zoom_incr, max_zoom)
#	set_physics_process(true)


# Called when the node enters the scene tree for the first time.
#func _unhandled_input(event:InputEvent):
#	if event is InputEventMouseMotion:
#		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
#			position -= event.relative * zoom
#	elif event is InputEventMouseButton:
#		if event.is_pressed():
#			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
#				zoom_out()
#			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#				zoom_in()
#
#
#
#
#func _physics_process(delta:float):
#	zoom = lerp(zoom, _target_zoom * Vector2.ONE, zoom_rate*delta)
#	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))
