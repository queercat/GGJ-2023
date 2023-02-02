extends Sprite3D

var player : Node
var move_speed = .5
var initial : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_child(0)
	initial = transform.origin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin = lerp(transform.origin, player.transform.origin, delta * move_speed)

	transform.origin.y = initial.y
	
