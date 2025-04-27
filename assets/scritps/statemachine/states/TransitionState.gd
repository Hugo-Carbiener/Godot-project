extends State
class_name TransitionState

## States that have a fixed duration (usually a single animation loop)

@export var has_boost_frame : bool
@export var boost_frame_timing : boost_frame_timings
@export var boost_frame_custom_timer: float

enum boost_frame_timings {
	ON_ANIMATION_START,
	ON_ANIMATION_END,
	ON_CUSTOM_TIMING
}

func allow_lateral_movement () -> bool : return false;
func allow_input() -> bool : return false
func prevent_drag() -> bool : return true

func enter():
	super()
	match boost_frame_timing :
		boost_frame_timings.ON_ANIMATION_START : 
			animation_controller.connect("animation_changed", on_animation_start)
		boost_frame_timings.ON_ANIMATION_END : 
			animation_controller.connect("animation_finished", on_animation_end)
		boost_frame_timings.ON_CUSTOM_TIMING :
			var timer = Timer.new()
			add_child(timer)
			timer.start(boost_frame_custom_timer)
			timer.connect("timeout", on_timer_end)

func exit():
	match boost_frame_timing :
		boost_frame_timings.ON_ANIMATION_START : 
			animation_controller.disconnect("animation_changed", on_animation_start)
		boost_frame_timings.ON_ANIMATION_END : 
			animation_controller.disconnect("animation_finished", on_animation_end)
		boost_frame_timings.ON_CUSTOM_TIMING :
			pass
	pass
	
func on_animation_start() : 
	pass

func on_animation_end() : 
	pass

func on_timer_end():
	pass
