require "/scripts/vec2.lua"

function init()
	activeItem.setHoldingItem(false)

	if status.statusProperty("pat_creditcard", nil) == nil then
		status.setStatusProperty("pat_creditcard", 0)
		world.spawnItem({name = "pat_freewatermelon"}, mcontroller.position(), 1, {}, {0, 0}, 0)
	end
	
	self.heldTime = 0
	self.addCooldown = 0
	self.particleCooldown = 0
	self.multiplier = 0
end

function update(dt, fireMode, shiftHeld)
	world.debugText("^shadow;"..status.statusProperty("pat_creditcard", 0), vec2.add(mcontroller.position(), {1.5, 2}), "red")
	world.debugText("^shadow;"..self.addCooldown, vec2.add(mcontroller.position(), {1.5, 1}), "orange")
	world.debugText("^shadow;"..self.heldTime, vec2.add(mcontroller.position(), {1.5, 0}), "yellow")
	world.debugText("^shadow;"..self.particleCooldown, vec2.add(mcontroller.position(), {1.5, -1}), "green")
	world.debugText("^shadow;"..self.multiplier, vec2.add(mcontroller.position(), {1.5, -2}), "cyan")
	
	if self.fireMode ~= "none" then
		self.addCooldown = math.max(0, self.addCooldown - dt)
	end
	self.particleCooldown = math.max(0, self.particleCooldown - dt)
	
	self.multiplier = (self.heldTime >= 2.5 and 10 or 1) * (self.heldTime >= 5 and 10 or 1) * (self.heldTime >= 10 and 10 or 1)
	
	if fireMode ~= self.lastFireMode then
		self.heldTime = 0
		
		if self.lastFireMode ~= "none" then
			particle()
		end
	end
	
	if fireMode == "primary" then
		if self.addCooldown == 0 and player.currency("money") > 0 then
			status.setStatusProperty(
				"pat_creditcard", 
				status.statusProperty("pat_creditcard", 0) + math.min(
					player.currency("money"),
					(shiftHeld and 1 or 10) * self.multiplier
				)
			)
			
			player.consumeCurrency(
				"money",
				math.min(
					player.currency("money"),
					(shiftHeld and 1 or 10) * self.multiplier
				)
			)
			
			self.addCooldown = math.max(0, 0.25 - (self.heldTime / 10))
		end
			
		if self.particleCooldown == 0 then
			particle()
			self.particleCooldown = 0.5
		end
		
		self.heldTime = self.heldTime + dt
	end
	
	if fireMode == "alt" then
		if self.addCooldown == 0 and status.statusProperty("pat_creditcard", 0) > 0 then
			player.addCurrency(
				"money", 
				math.min(
					status.statusProperty("pat_creditcard", 0),
					(shiftHeld and 1 or 10) * self.multiplier
				)
			)
			
			status.setStatusProperty(
				"pat_creditcard",
				status.statusProperty("pat_creditcard", 0) - math.min(
					status.statusProperty("pat_creditcard", 0),
					(shiftHeld and 1 or 10) * self.multiplier
				)
			)
			
			self.addCooldown = math.max(0, 0.25 - (self.heldTime / 10))
		end
			
		if self.particleCooldown == 0 then
			particle()
			self.particleCooldown = 0.5
		end
		
		self.heldTime = self.heldTime + dt
	end
	
	self.lastFireMode = fireMode
end

function particle()
	self.moners = status.statusProperty("pat_creditcard", 0)
	
	local params = {}
	params.actionOnReap = root.assetJson("/pat/freemelon/number/number.projectile").actionOnReap
	params.actionOnReap[1].specification.text = "^shadow;"..self.moners
			
	world.spawnProjectile(
		"pat_creditcardnumber",
		vec2.add(mcontroller.position(), {0, 2.5}),
		activeItem.ownerEntityId(),
		{0, 0},
		false,
		params
	)
end