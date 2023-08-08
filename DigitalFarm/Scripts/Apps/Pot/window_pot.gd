extends WindowWrapper

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
			App_Pot.PotStatus.GROWN:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.show()
				$Window/Sprite_PotDead.hide()
			App_Pot.PotStatus.DEAD:
				$Window/Sprite_PotEmpty.hide()
				$Window/Sprite_PotHasSeed.hide()
				$Window/Sprite_PotGrown.hide()
				$Window/Sprite_PotDead.show()
		pot_status = val
