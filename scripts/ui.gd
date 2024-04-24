extends CanvasLayer

signal skip_stage_clicked
signal end_turn_clicked
signal move_clicked
signal attack_clicked

func _ready():
	print("READY (ui.gd)")
	$MenuBar/Container/SkipTurnButton.pressed.connect(func(): skip_stage_clicked.emit())
	$MenuBar/Container/EndTurnButton.pressed.connect(func(): end_turn_clicked.emit())
	$MenuBar/Container/MoveButton.pressed.connect(func(): move_clicked.emit())
	$MenuBar/Container/AttackButton.pressed.connect(func(): attack_clicked.emit())
func update_timer(time_left: int):
	var text = ""
	if time_left % 60 == 0:
		text = str(time_left/60)+":"+str(time_left%60)+"0"
	elif time_left % 60 < 10:
		text = str(time_left/60)+":0"+str(time_left%60) 
	else: 
		text = str(time_left/60)+":"+str(time_left%60)
	$MenuBar/Container/TurnCountdown.text = text

func update_timer_hacky_donotuse(text: String):
	$MenuBar/Container/TurnCountdown.text = text

func update_tallies(players: Array[Player], current_player: Player):
	var text = ""
	for player in players:
		text += "P{num} ".format({"num":player._id})
		if player._id == current_player._id:
			text += " <--"
		text += "\n"
	$Tallies.text = text

enum GameState {
	SELECT_ATTACKER,
	SELECT_ATTACKED,
	ADDING_TROOPS,
	ATTACK,
	MOVING_FROM,
	MOVING_TO,
	INITIAL_STATE,
}

func update_game_state(state: GameState) -> void:
	$MenuBar/Container/GameState.text = GameState.keys()[state]
	if state == GameState.INITIAL_STATE:
		$MenuBar/Container/SkipTurnButton.visible = false
		$MenuBar/Container/EndTurnButton.visible = false
		return
	if state != GameState.MOVING_FROM and state != GameState.MOVING_TO:
		$MenuBar/Container/SkipTurnButton.visible = true
		$MenuBar/Container/EndTurnButton.visible = false
	else:
		$MenuBar/Container/EndTurnButton.visible = true
		$MenuBar/Container/SkipTurnButton.visible = false
