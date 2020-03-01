extends Weapon;

onready var _clip_size = 30;
onready var _fire_rate = 0.1;

func _ready():
	set_clip_size(_clip_size);
	set_fire_rate(_fire_rate);
	set_current_ammo(_clip_size);
