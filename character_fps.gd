extends KinematicBody;

export var gravity = 0.8;
export var speed = 10;
export var acceleration = 5;
export var jump = 35;
export var mouse_sensitivity = 0.4;

onready var head = $HeadPivot;
onready var camera = $HeadPivot/Camera;
onready var weapon = $HeadPivot/Weapon;
onready var weapon_animation = $HeadPivot/Weapon/AnimationPlayer;

var velocity = Vector3();
var jump_allow = false;


# Mouse input
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity));
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity));
	head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90));

# Physics frame by frame
func _physics_process(delta):
	
	# Get body local transform
	var body_basis = get_global_transform().basis;
	var direction = Vector3();
	
	jump_allow = is_on_floor();
	
	if Input.is_action_pressed("move_forward"):
		direction -= body_basis.z.normalized();
	elif Input.is_action_pressed("move_backward"):
		direction += body_basis.z.normalized();
		
	if Input.is_action_pressed("move_left"):
		direction -= body_basis.x.normalized();
	elif Input.is_action_pressed("move_right"):
		direction += body_basis.x.normalized();
		
	if Input.is_action_pressed("jump") and is_on_floor():
		direction.y += jump;
	
	# Smoothly interpolate and slide body
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta);
	velocity.y -= gravity;
	velocity = move_and_slide(velocity, Vector3.UP);
