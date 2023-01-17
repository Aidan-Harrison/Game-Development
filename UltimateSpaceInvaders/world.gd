extends Node2D

@export var eGridX : int = 10;
@export var eGridY : int = 4;

@export var eGridXSpace : float = 65.0;
@export var eGridYSpace : float = 65.0;

@export var shiftSizeX : float = 20.0;
@export var shiftSizeY : float = 30.0;

@onready var enemy = preload("res://Enemy.tscn");
@onready var boss = preload("res://Gameplay/Boss.tscn");
@onready var powerShip = preload("res://PowerUpShip.tscn");
@onready var abilityShip = preload("res://Gameplay/AbilityShip.tscn");
@onready var cover = preload("res://Cover.tscn");

@onready var numOfCovers : int = 4;

@onready var tRate = $TickRate;

var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width");
var screenHeight = ProjectSettings.get_setting("display/window/size/viewport_height");
@onready var debugSprite = preload("res://icon.svg");

# Used for knowing bounds
	# Right and left for movement
	# Bottom for shooting
var RIGHT : int = eGridX-1;
var LEFT : int = 0;
var BOTTOM : int = eGridY-1;

var rightPos : Vector2 = Vector2.ZERO;
var leftPos : Vector2 = Vector2.ZERO;

var enemies = [];
var right : bool = true; # Rename
var counter : int = 0;
var level : int = 1;
var maxLevel : int = 4;
var bossLevel : bool = true;
var time : int = 0;
var hasShip : bool = false;

var score : int = 0;
var scoreModifier : float = 1.0;
var globalModiferTimer : int = 30; # In seconds

var powerShipFrequency : int = 2;
var abilityShipFrequency : int = 4;
var side : int = 0; # 0 == Left, 1 == Right
var matchingShipSpawns : bool = false;

# Boss
var hasBoss : bool = true;
var bossLevels = [2];

@onready var scoreModTimer : Timer = $ScoreTimer;

@onready var ui : Control = $UI/HUD;

@onready var player = $Player;

func _ready() -> void:
	randomize();
	Generate();
	# Cover generation;
	var coverPos : Vector2 = Vector2(-screenWidth/2+125.0, 125.0);
	for i in range(0, numOfCovers):
		var newCover = cover.instantiate();
		add_child(newCover);
		newCover.global_position = coverPos;
		coverPos.x += 275.0;
	ui.health.value = player.health;
	GenerateBoss();

func Generate() -> void:
	print('Generated');
	RIGHT = eGridX-1;
	BOTTOM = eGridY-1;
	var offset : Vector2 = Vector2(-screenWidth/2+150.0,-screenHeight/2+100.0);
	var xCount : int = 0;
	for i in range(0, eGridX*eGridY):
		var newEnemy = enemy.instantiate();
		add_child(newEnemy);
		enemies.append(newEnemy);
		newEnemy.global_position = offset;
		offset.x += eGridXSpace;
		xCount+=1;
		if(xCount >= eGridX):
			offset.x = -screenWidth/2+150.0;
			offset.y += eGridYSpace;
			xCount=0;
	RowCheck(BOTTOM);
	
func GenerateBoss() -> void:
	var newBoss = boss.instantiate();
	add_child(newBoss);
	newBoss.global_position = Vector2(screenWidth/2, 0.0-screenHeight*0.3);
	ui.bossBar.visible = true;

func ColumnCheck(column : int) -> bool:
	for i in eGridY:
		if((i*eGridX)+column < enemies.size() && enemies[(i*eGridX)+column] != null):
			enemies[(i*eGridX)+column].modulate = Color.MEDIUM_PURPLE;
			return false;
	return true;
	
func RowCheck(row : int) -> bool:
	for i in eGridX:
		if(i+(row*eGridX) < enemies.size() && enemies[i+(row*eGridX)] != null):
			enemies[i+(row*eGridX)].get_node("Sprite2d").texture = debugSprite;
			#enemies[i+(row*eGridX)].modulate = Color.VIOLET;
			return false;
	return true;

func GameState(value : int) -> void:
	if(bossLevel): # Alter function
		return;
	counter += value;
	scoreModifier += 0.2;
	score += 100 * scoreModifier;
	scoreModTimer.start();
	ui.score.text = str(score);
	ui.scoreMod.text = str(scoreModifier);
	if(counter == enemies.size()):
		level += 1;
		player.heat = 0;
		ui.heat.value = player.heat;
		for i in enemies: # Safety measure for debugging and custom settings
			if(i != null):
				i.queue_free();
		enemies.clear();
		counter = 0;
		for i in bossLevels:
			if(level == i): # BOSS
				print('FOUND BOSS');
				GenerateBoss();
				return;
		Generate();
		if(level == maxLevel): # Make happen after level end!
			player.canQuickExit = true;
			ui.gOver.visible = true;
			ui.anim.play("GameOver");
			return;

func _on_tick_rate_timeout() -> void: # Optimise!!
	for i in enemies:
		if(i == null):
			continue;
		if(right):
			i.position.x += shiftSizeX;
		else:
			i.position.x -= shiftSizeX;
	if(right):
		rightPos.x += shiftSizeX;
		leftPos.x += shiftSizeX;
	else:
		rightPos.x -= shiftSizeX;
		leftPos.x -= shiftSizeX;
	if(rightPos.x > screenWidth/2 || leftPos.x < -screenWidth/2):
		if(right):
			right = false;
		else:
			right = true;
		for i in enemies:
			if(i == null):
				continue;
			i.position.y += shiftSizeY;

# Make random
func _on_attack_rate_timeout() -> void:
	if(bossLevel):
		return;
	var index = randi_range(0, eGridX-1);
	#for i in range(0, eGridX):
	if(enemies[index+(BOTTOM*eGridX)] != null):
		enemies[index+(BOTTOM*eGridX)].SpawnProjectile();

func _on_counter_timeout():
	time+=1;
	ui.time.text = str(time);
	if(!time % powerShipFrequency && !time % abilityShipFrequency):
		matchingShipSpawns = true;
	if(!time % powerShipFrequency): # Spawn powerup
		if(!hasShip):
			hasShip = true;
		else:
			hasShip = false;
		if(hasShip):
			return;
		var newPowerShip = powerShip.instantiate();
		side = randi_range(0, 1); # Randomise side
		add_child(newPowerShip);
		# Relay game state to spawning
		if(player.health >= player.maxHealth-1):
			newPowerShip.powerFlags[newPowerShip.POWERS.HEALTH] = false;
		if(player.shield > 0):
			newPowerShip.powerFlags[newPowerShip.POWERS.SHIELD] = false;
		if(player.numOfStreams > 1):
			newPowerShip.powerFlags[newPowerShip.POWERS.D_SHOT] = false;
		# Spawn
		if(side): # left -> right
			newPowerShip.position = Vector2(-screenWidth/2-5.0, -screenHeight/2+10.0);
		else:
			newPowerShip.position = Vector2(screenWidth/2, -screenHeight/2+10.0);
			newPowerShip.SPEED = -newPowerShip.SPEED;
	if(!time % abilityShipFrequency):
		var newAbilityShip = abilityShip.instantiate();
		if(matchingShipSpawns): # Force opposite
			if(side): side = 0;
			else: side = 1;
		else:
			side = randi_range(0, 1);
		add_child(newAbilityShip);
		if(side): # left -> right
			newAbilityShip.position = Vector2(-screenWidth/2-5.0, -screenHeight/2+10.0);
		else:
			newAbilityShip.position = Vector2(screenWidth/2, -screenHeight/2+10.0);
			newAbilityShip.SPEED = -newAbilityShip.SPEED;
	matchingShipSpawns = false;

func _on_score_timer_timeout():
	scoreModifier = 1.0;
	ui.scoreMod.text = str(scoreModifier);
