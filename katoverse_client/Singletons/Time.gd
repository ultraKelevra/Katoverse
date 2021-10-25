extends Node



var time : int



func update_time():
	time = OS.get_system_time_msecs()


func _ready():
	update_time()


func _process(delta):
	update_time()
