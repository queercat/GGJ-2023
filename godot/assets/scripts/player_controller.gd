extends KinematicBody

var move_speed = 20
var mouse_sensitivity = 1

var camera : Camera
var velocity : Vector3

var mouse : Vector2

func handle_input(input : InputDefault, delta):
	velocity.x = 0
	velocity.y = 0
	velocity.z = 0
	
	if input.is_action_pressed("ui_right"):
		velocity += camera.global_transform.basis.x * delta * move_speed
		
	if input.is_action_pressed("ui_left"):
		velocity -= camera.global_transform.basis.x * delta * move_speed
		
	if input.is_action_pressed("ui_up"):
		velocity -= global_transform.basis.z * delta * move_speed
		
	if input.is_action_pressed("ui_down"):
		velocity += global_transform.basis.z * delta * move_speed
	
	
	rotate_y(-mouse.x * mouse_sensitivity * delta)
	camera.rotate_x(-mouse.y * mouse_sensitivity * delta)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	mouse = Vector2()

func do_physics():
	move_and_slide(Vector3(0, -100, 0))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_viewport().get_camera()
		
func _input(event):
	if event is InputEventMouseMotion:
		mouse = event.relative
		
func _process(delta):
	handle_input(Input, delta)
	do_physics()
	var _result = move_and_collide(velocity)
	pass
