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
var jump_count = 0;
var on_ground = false;
var flip_state = 0;


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
	
	if Input.is_action_pressed("move_forward"):
		direction -= body_basis.z.normalized();
	elif Input.is_action_pressed("move_backward"):
		direction += body_basis.z.normalized();
		
	if Input.is_action_pressed("move_left"):
		direction -= body_basis.x.normalized();
	elif Input.is_action_pressed("move_right"):
		direction += body_basis.x.normalized();
	
	if Input.is_action_just_pressed("box_flip"):
		box_flip();
	
	#Reset jumping when on ground
	if is_on_floor():
		jump_count = 0;
	
	#Single jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if jump_count == 0:
			direction.y += jump;
			jump_count = 1;
	
	#Double jump
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_count == 1:
			direction.y += jump;
			jump_count = 2;
	
	# Smoothly interpolate and slide body
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta);
	velocity.y -= gravity;
	velocity = move_and_slide(velocity, Vector3.UP);

func box_flip():
	for cube in get_tree().get_nodes_in_group("Cubes1"):
		if cube.is_visible():
			cube.hide();
		else:
			cube.show();
		
		match [flip_state]:
			[0]:
				cube.get_node("CollisionShape").set_disabled(true);
				cube.set_ray_pickable(false);
			[1]:
				cube.get_node("CollisionShape").set_disabled(false);
				cube.set_ray_pickable(true);
	
	for cube in get_tree().get_nodes_in_group("Cubes2"):
		if cube.is_visible():
			cube.hide();
		else:
			cube.show();
			
		match [flip_state]:
			[0]:
				cube.get_node("CollisionShape").set_disabled(false);
				cube.set_ray_pickable(true);
			[1]:
				cube.get_node("CollisionShape").set_disabled(true);
				cube.set_ray_pickable(false);
	
	match [flip_state]:
		[0]:
			flip_state = 1;
		[1]:
			flip_state = 0;
