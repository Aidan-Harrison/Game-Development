extends Node;

enum AGENTS{SAGE, PHOENIX, BREACH};
# Agent specific | Charges -> Cost | (Ult cost = number of orbs)
var sage_abi_charges = [2, 2, 2, 1];
var sage_abi_cost = [200, 200, 200, 7];

var phoenix_abi_charges = [2, 2, 1, 1];
var phoenix_abi_cost = [200, 200, 400, 5];

func SKILL_TO_AGENT(agent, skill):
	skill.parent = agent;
	skill.global_position = agent.abiSpatial.global_position;

func ASSIGN(player, id : int) -> void:
	# player.abilities.clear();
	match(id):
		AGENTS.SAGE:
			# Charges
			player.abilityCharges = sage_abi_charges;
			player.abilityCosts = sage_abi_cost;
			# Create and assign
			var s_wall = Preloader.sage_wall.instantiate();
			player.add_child(s_wall);
			player.abilities[0] = s_wall;
			var s_orb = Preloader.sage_orb.instantiate();
			player.cam.add_child(s_orb);
			player.abilities[1] = s_orb;
			s_orb.global_position = Vector3(player.cam.global_position.x,player.cam.global_position.y-0.5,player.cam.global_position.z-1.0);
		AGENTS.PHOENIX:
			player.abilityCharges = phoenix_abi_charges;
			player.abilityCosts = phoenix_abi_cost;
			var p_flash = Preloader.phoenix_flash.instantiate();
			player.add_child(p_flash);
			player.abilities[0] = p_flash;
			var p_wall = Preloader.phoenix_wall.instantiate();
			player.add_child(p_wall);
			player.abilities[1] = p_wall;
		AGENTS.BREACH:
			pass
