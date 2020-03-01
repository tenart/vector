extends Weapon;

onready var _clip_size = 30;
onready var _fire_rate = 0.1;
onready var _reload_rate = 3.5;
onready var _full_auto = true;
onready var anim = get_node("AnimationPlayer")

func _ready():
	set_clip_size(_clip_size);
	set_fire_rate(_fire_rate);
	set_current_ammo(_clip_size);
	set_reload_rate(_reload_rate);
	set_full_auto(_full_auto);

func fire():
	set_can_fire(false);
	current_ammo -= 1;
	
	anim.play("fire",-1,3);
	anim.get_animation(anim.current_animation).loop = false;
	
	check_collision();
	
	yield(get_tree().create_timer(fire_rate), "timeout");
	set_can_fire(true);

func reload():
	reloading = true;
	anim.play("reload");
	anim.get_animation(anim.current_animation).loop = false;
	
	yield(get_tree().create_timer(reload_rate), "timeout");
	current_ammo = clip_size;
	reloading = false;

func _on_AnimationPlayer_finished():
	anim.stop();
