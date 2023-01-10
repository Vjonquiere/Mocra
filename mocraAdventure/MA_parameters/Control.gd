extends Control


var lobby_node

func set_lobby_node(Lobby_node):
	lobby_node = Lobby_node

func set_vars(level_name:String, players:String) -> void:
	$levelVar.set_text(level_name)
	$playerVar.set_text(players)

func _on_disconnectButton_pressed():
	lobby_node.MA_disconnect()
