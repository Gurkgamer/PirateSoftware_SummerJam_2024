extends Node2D
## SPELL COOLDOWN MANAGER ##

var spell_timers = {}

func can_be_cast(spell) -> bool:
	if !spell: #NOTE -> No se deberia necesitar comprobar null si se hace bien
		push_error("No he recibido nada")
		return false
	var spell_name = spell.name
	if spell_timers.has(spell_name) :
		var spell_timer : Timer = spell_timers[spell_name]
		var cooldown_finished = spell_timer.is_stopped()
		if cooldown_finished :
			spell_timer.start()
		return cooldown_finished
	else:
		var spell_timer_cooldown = spell.cooldown
		var new_spell_timer = Timer.new()
		new_spell_timer.autostart = false
		new_spell_timer.one_shot = true
		new_spell_timer.wait_time = spell_timer_cooldown
		get_tree().root.add_child(new_spell_timer)
		new_spell_timer.start()
		spell_timers[spell_name] = new_spell_timer
		return true
		
func get_cooldown_remaing_time(spell_name : String) -> float:
	if spell_name == "Nothing": return 0.0 #FIXME -> Permitir añadir Nothing al sistema de cooldown
	if !spell_name: #NOTE -> No se deberia necesitar comprobar null si se hace bien
		push_error("No ha llegado el nombre de la magia")
	if spell_timers.has(spell_name) :
		var spell_timer : Timer = spell_timers[spell_name]
		return 100.0 - ((100.0 * spell_timer.time_left) / spell_timer.wait_time)
	else : 
		return 0.0
