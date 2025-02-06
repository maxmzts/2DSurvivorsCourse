extends PanelContainer

func _ready():
	%KillCount.text = str(Globals.current_game_enemies_killed)
	%ExpCount.text = str(Globals.current_game_experience_collected)
	
