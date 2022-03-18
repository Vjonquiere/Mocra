extends Control

var new_player_data = {"username":null, "email":null, "password":null}

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
			$LoginLabel.visible = false
			$PasswordLabel.visible = false
			$PasswordConfirmLabel.visible = false
			$EmailLabel.visible = false
			$LabelERROR.set_position(Vector2(465,300))
		else:
			$LabelERROR.set_text("ERROR: username already taken")
	else:
		$LabelERROR.set_text("ERROR: Passwords must be identical")
	
	$LabelERROR.visible = true



func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_Step1NextButton_pressed():
	
	var username = $Step1/LoginLabel/LoginLineEdit.get_text()
#if ";" in username or "=" in username:
	var data = "check_username/" + username
	Networking.con.put_data(data.to_utf8())
	#Networking.waiting_for_server()[0]
	if "next_step" == "next_step":
		new_player_data["username"] = username
		$ProgressBar.set_value(25)
		$Step1.visible = false
		$Step2.visible = true
	else:
		error("ERROR: username already taken")

func _on_Timer_timeout():
	$LabelERROR.visible = false

func _on_Step2NextButton_pressed():
	var password = $Step2/PasswordLabel/PasswordLineEdit.get_text()
	if password == $Step2/ConfirmPasswordLabel/ConfirmPasswordLineEdit.get_text():
		if len(password) > 7:
			new_player_data["password"] = password
			$Step2.visible = false
			$Step3.visible = true
		else:
			error("ERROR: Password lenght is 7 at least")
	else:
		error("ERROR: passwords must be indentical")


func _on_Step2PreviousButton_pressed():
	$Step2.visible = false
	$Step1.visible = true

func _on_Step3NextButton_pressed():
	var email = $Step3/EmailLabel/EmailLineEdit.get_text()
	if "@" in email and "." in email:
		new_player_data["email"] = email
	else:
		error("ERROR: invalid email format")


func _on_Step3PreviousButton_pressed():
	$Step3.visible = false
	$Step2.visible = true


func error(error_str):
	$LabelERROR.set_text(error_str)
	$LabelERROR.visible = true
	$Timer.start()

func _on_Step1_draw():
	$ProgressBar.set_value(0)

func _on_Step2_draw():
	$ProgressBar.set_value(25)

func _on_Step3_draw():
	$ProgressBar.set_value(50)






