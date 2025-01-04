extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged()

signal dialog_started(npc_name: String, npc_dialog: Dictionary)
signal dialog_finished(disconnect: bool)

# arena events

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrades)

func emit_player_damaged():
	player_damaged.emit()

# interaction events

func emit_dialog_started(npc_name: String, npc_dialog: Dictionary):
	dialog_started.emit(npc_name, npc_dialog)
	
func emit_dialog_finished(delete_interaction: bool):
	dialog_finished.emit(delete_interaction)

