extends Control

func _ready():
	pass

func _password_verif(password, password_confirm):
	if password == password_confirm && password != "":
		return true
	else:
		return false


func _on_Button_pressed():
	$LabelERROR.visible = false
	var login = $LoginLabel/LoginLineEdit.get_text()
	var password = $PasswordLabel/PasswordLineEdit.get_text()
	var password_confirm = $PasswordConfirmLabel/ConfirmPasswordLineEdit.get_text()
	var email = $EmailLabel/EmailEntry.get_text()
	
	if _password_verif(password, password_confirm) == true:
		var password_hash = password.sha256_text()
		var send_str = "create_account/" + login + "/" + email +"/" + password_hash 
		Networking.con.put_data(send_str.to_utf8())
		
		var recieved_data = Networking.waiting_for_server()
		print(recieved_data)
		
		if recieved_data[0] == "working":
			$LabelERROR.set_text("Account has been added")
		else:
			$LabelERROR.set_text("ERROR: username already taken")
	else:
		$LabelERROR.set_text("ERROR: Passwords must be identical")
	
	$LabelERROR.visible = true



func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")
