extends Node

var test = ''
var mocra_ID = null
var color = "#313131"
var credits = "NA"
var shiny_credits = "NA"
var boost = "NA"
var card = null
var pack_content = {}
var card_index = 0
var card_number = 0
var collection_card = null
var current_page = 0
var page_number = 0
var page_array = {}
var battle_result = []
var opponent_card_str = []
var card_str = []
var username = ""
var global_points = ""
var peer
var colors = {"Common":"#7D7D7D", "Not Much Common":"#2c65e8", "Unusual":"#00D989", "Rare":"#C3DD25", "Extremely Rare":"#C40000", "Unbelievable":"#0091B4", "Mythical":"#FF9000", "RAINBOW":"#00CDAD"}
var alterable_inputs = ["editor_zoom_-", "editor_zoom_+", "offensive", "ui_left", "ui_right", "ui_up", "ui_down", "use"]
var options = {}
var null_value = null
