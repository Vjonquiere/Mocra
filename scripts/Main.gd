extends Control


func _ready():
	pass



func _on_Button_pressed():
	
	var login = $LoginEntry.get_text()
	var password = $PasswordEntry.get_text().sha256_text()
	var final = "login_test/"+login+"/"+password
	
	if $ErrorLabel.visible:
		$ErrorLabel.visible = false
		
	Networking.con.put_data(final.to_utf8())
	
	var rcv = Networking.waiting_for_server()
	print(rcv)

	if rcv[0] == "display_user_infos":
		Global.credits= rcv[2]
		Global.shiny_credits = rcv[3]
		Global.boost = str(stepify(float(rcv[4]),0.01))
		get_tree().change_scene("res://scenes/Menu.tscn")
		
	if rcv[0] == "error" && rcv[1] == "invalid_login":
		$ErrorLabel.set_text("ERROR: Invalid login or password")
		$ErrorLabel.visible = true



func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/Register.tscn")
