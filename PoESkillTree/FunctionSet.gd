extends Node;

var ActiveCharacter = null;
var CharacterDisplay = null;

enum ADJUST_ID{HEALTH, MANA, SPEED};

func STAT_ADJUST_CORE(STAT_TO_ADJUST : int, Value : float) -> void:
	match(STAT_TO_ADJUST):
		ADJUST_ID.HEALTH: 
			ActiveCharacter.Health += Value;
			CharacterDisplay.HealthValue.text = str(ActiveCharacter.Health);
		ADJUST_ID.MANA:   
			ActiveCharacter.Mana   += Value;
			CharacterDisplay.ManaValue.text = str(ActiveCharacter.Mana);
		ADJUST_ID.SPEED:  
			ActiveCharacter.Speed  += Value;
			CharacterDisplay.SpeedValue.text = str(ActiveCharacter.Speed);

func STAT_ADJUST_DEFENCE(STAT_TO_ADJUST : int, Value : float) -> void:
	pass;
	
func STAT_ADJUST_RESISTANCE(STAT_TO_ADJUST : int, Value : float) -> void:
	pass;