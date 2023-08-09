extends WindowWrapper

const WATER_REQUEST_TIME_SEC: float = 25

var _time_until_need_water_sec: float = 0

func water():
	_time_until_need_water_sec = WATER_REQUEST_TIME_SEC
	$Window/ProgressBar.paused = false

var pot_status: = App_Pot.PotStatus.EMPTY:
	set(val):
		match val:
			App_Pot.PotStatus.EMPTY:
				$Window/Sprite_PotEmpty.show()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.hide()
				$Window/Sprite_PotDead.hide()
			App_Pot.PotStatus.HAS_SEED:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.show()
				$Window/Sprite_PotGrown.hide()
				$Window/Sprite_PotDead.hide()

				$Window/ProgressBar.show()
				$Window/ProgressBar.paused = false
				_time_until_need_water_sec = WATER_REQUEST_TIME_SEC
			App_Pot.PotStatus.GROWN:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.show()
				$Window/Sprite_PotDead.hide()

				$Window/ProgressBar.hide()
				$Window/ProgressBar.paused = true
			App_Pot.PotStatus.DEAD:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.hide()
				$Window/Sprite_PotDead.show()

				$Window/ProgressBar.hide()
				$Window/ProgressBar.paused = true
		pot_status = val

func _process(_delta):
	if pot_status == App_Pot.PotStatus.HAS_SEED:
		_time_until_need_water_sec -= _delta
		if _time_until_need_water_sec < 0:
			$Window/ProgressBar.paused = true

		if $Window/ProgressBar.progress >= 1:
			pot_status = App_Pot.PotStatus.GROWN
