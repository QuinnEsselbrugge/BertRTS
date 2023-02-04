extends KinematicBody

var velocity = Vector3.ZERO

export var camera_momentum = 40
export var accel = 9

func compute_movement(current_direction, delta):
	var camera_x = global_transform.basis.x
	var camera_z = global_transform.basis.z
	var scene = get_tree().get_current_scene()
	
	if (Input.is_action_pressed("camera_forward")):
		current_direction -= camera_z
		
	if (Input.is_action_pressed("camera_backwards")):
		current_direction += camera_z
		
	if (Input.is_action_pressed("camera_left")):
		current_direction -= camera_x
		
	if (Input.is_action_pressed("camera_right")):
		current_direction += camera_x

	current_direction = (transform.basis * Vector3(current_direction.x, 0, current_direction.z)).normalized()
	
	velocity.x = lerp(velocity.x, current_direction.x * camera_momentum, accel * delta)
	velocity.z = lerp(velocity.z, current_direction.z * camera_momentum, accel * delta)
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
func handle_fov_zooming(event):
	if event is InputEventMouseButton:
		event as InputEventMouseButton
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_DOWN:
					if ($Cam.fov < 90):
						$Cam.fov = $Cam.fov + 2
				BUTTON_WHEEL_UP:
					if ($Cam.fov > 20):
						$Cam.fov = $Cam.fov - 2
						
func _input(event : InputEvent) -> void:
	handle_fov_zooming(event)
	
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _physics_process(delta):
	if (General.camera_movement_enabled == true):
		var velocity = compute_movement(Vector3.ZERO, delta)
