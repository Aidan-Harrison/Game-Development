extends Node;

var ActiveCharacter = null;
var CharacterDisplay = null;
var CurrentTooltip = null;

enum ADJUST_ID{HEALTH, MANA, SPEED};

func REFRESH_DISPLAY() -> void:
	CharacterDisplay.SkillPoints.text = str(ActiveCharacter.SkillPointsLeft);
	CharacterDisplay.HealthValue.text = str(ActiveCharacter.Health);
	CharacterDisplay.ManaValue.text   = str(ActiveCharacter.Mana);

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
	if(Value > 0.0):
		ActiveCharacter.SkillPointsLeft -= 1;
	else:
		ActiveCharacter.SkillPointsLeft += 1;
	CharacterDisplay.SkillPoints.text = str(ActiveCharacter.SkillPointsLeft);

func STAT_ADJUST_DEFENCE(STAT_TO_ADJUST : int, Value : float) -> void:
	pass;
	
func STAT_ADJUST_RESISTANCE(STAT_TO_ADJUST : int, Value : float) -> void:
	pass;
