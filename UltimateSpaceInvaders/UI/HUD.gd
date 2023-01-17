extends Control

@onready var health = $Health;
@onready var shield = $Shield;
@onready var heat = $Heat;
@onready var hValue = $Health/Value;
@onready var lives = $LIVES/Value;
@onready var level = $LEVEL/Value;
@onready var gOver = $GAME_OVER;
@onready var time = $Time;
@onready var anim = $AnimationPlayer;
@onready var score = $Score;
@onready var scoreMod = $ScoreModifer/ScoreModValue;
@onready var bossBar = $BossBar;

func _ready():
	gOver.visible = false;
	shield.value = 0;
	bossBar.visible = false;
