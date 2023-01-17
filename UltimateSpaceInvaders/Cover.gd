extends Node2D

var layout = [
	' ',' ','#','#',' ',' ',
	' ','#','#','#','#',' ',
	' ','#','#','#','#',' ',
	'#','#','#','#','#','#',
	'#','#','#','#','#','#',
	'#','#','#','#','#','#',
];

var segmentSize : int = 1;
var height : int = 6;
var width : int = 6;

var blocks = [];
var counter : int = 0;

@onready var text = preload("res://icon.svg");

func TakeDamage(_value : int) -> void:
	var index : int = randi_range(0, blocks.size()-1);
	while(blocks[index] == null):
		index = randi_range(0, blocks.size()-1);
	if(blocks[index] != null):
		blocks[index].queue_free();
	counter-=1;
	if(counter == 0):
		queue_free();

func _ready():
	var pointer : Vector2 = Vector2(global_position.x-(segmentSize*width)/2, global_position.y-(segmentSize*height)/2);
	for i in range(0, height):
		for j in range(0, width):
			pointer.x += segmentSize*10;
			if(layout[(i*width)+j] == ' '):
				continue;
			var newSprite : Sprite2D = Sprite2D.new();
			add_child(newSprite);
			newSprite.texture = text;
			newSprite.scale = newSprite.scale * 0.1;
			newSprite.global_position = pointer;
			blocks.append(newSprite);
		pointer.x = global_position.x-(segmentSize*width)/2;
		pointer.y += segmentSize*10;
	counter = blocks.size();
	#$CollisionShape2d.global_position = Vector2(global_position.x+segmentSize*width/2, global_position.y+segmentSize*height/2);

func _on_cover_area_entered(area):
	if(area.is_in_group("Projectile")):
		TakeDamage(area.get_parent().damage); # Optimise
		area.get_parent().queue_free();
