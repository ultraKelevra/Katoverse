extends Node



var server_time_timestamp : int
var last_server_time : int
var time  setget , get_server_time
var latency_buffer = []
var med_latency : int = 0
var decimal_storage = 0

signal synched()
var synched = false

func get_server_time():
	return Time.time - server_time_timestamp + last_server_time


func update_latency_buffer(latency):
	if latency_buffer.size() > 32:
		latency_buffer.pop_back()
		latency_buffer.pop_front()
	
	if latency_buffer.size() == 0:
		latency_buffer.append(latency)
		return
	
	med_latency = latency_buffer[0]
	var buffer_size = latency_buffer.size()
	
	latency_buffer.append(latency)
	latency_buffer.sort()
	
	med_latency = latency_buffer[(buffer_size + 1)/2]


func update_server_time(server_time, client_time):
	var latency = ((Time.time - client_time) / 2)
	update_latency_buffer(latency)
	var next_server_time = server_time + med_latency
	
	if last_server_time < next_server_time:
		last_server_time = next_server_time
		server_time_timestamp = Time.time
		if not synched:
			synched = true
			emit_signal("synched")


func request_server_time_update():
	WorldClient.request_server_time()


func start_server_time_clock():
	var timer = Timer.new()
	timer.connect("timeout", self, "request_server_time_update")
	timer.start(.5)
	add_child(timer)
	request_server_time_update()
