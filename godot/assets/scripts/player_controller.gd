extends KinematicBody

var move_speed = 20
var mouse_sensitivity = 1

var camera : Camera

var velocity : Vector3

var mouse : Vector2

var flashlight : SpotLight
var flashlight_timer : float
var flashlight_on : bool
var flashlight_duration = 6
var flashlight_cooldown : bool
var flashlight_base : SpotLight
var flashlight_sound_emitter : AudioStreamPlayer3D
var flashlight_hud_color : Polygon2D
var flashlight_cooldown_bonus = 2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_viewport().get_camera()
	flashlight = $Camera/Flashlight
	flashlight_sound_emitter = $Camera/Flashlight/Clicker
	flashlight_hud_color = $Camera/Polygon2D

func activate_flashlight():
	flashlight_sound_emitter.play()
	
	if !flashlight_cooldown:
		flashlight_on = !flashlight_on
		
	update_flashlight()
	
func update_flashlight():
	if flashlight_on:
		flashlight.light_energy = 5
		flashlight_on = true
	else:
		flashlight.light_energy = 0
		flashlight_on = false

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
		
	if input.is_action_just_pressed("ui_activate"):
		activate_flashlight()
		
	rotate_y(-mouse.x * mouse_sensitivity * delta)
	camera.rotate_x(-mouse.y * mouse_sensitivity * delta)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	mouse = Vector2()

func do_physics(_delta):
	var _result = move_and_collide(Vector3(0, -1, 0))
		
func do_logic(delta):
	# flashlight logic 
	var on = 1
	if !flashlight_on:
		on = -1
	
	var bonus = 1
	
	if !flashlight_cooldown and !flashlight_on:	
		bonus = flashlight_cooldown_bonus
	
	flashlight_timer = clamp(flashlight_timer + (delta * on * bonus), 0, flashlight_duration)	
	
	
	if flashlight_timer >= flashlight_duration:
		flashlight_cooldown = true
		flashlight_on = false
		update_flashlight()
	
	if flashlight_timer <= 0:
		flashlight_cooldown = false
	
	# setting hud flashlight color
	var r = (flashlight_timer/flashlight_duration)
	var g = (((flashlight_timer/flashlight_duration) * -1) + 1)

	flashlight_hud_color.color = Color(r, g, 0)
	
	if (flashlight_cooldown):
		flashlight_hud_color.color = Color(0, 0, 0)
		
func _input(event):
	if event is InputEventMouseMotion:
		mouse = event.relative
		
func _process(delta):
	handle_input(Input, delta)
	do_physics(delta)
	do_logic(delta)
	
	var _result = move_and_collide(velocity)
