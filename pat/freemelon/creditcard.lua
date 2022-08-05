function init()
	activeItem.setHoldingItem(false)
end

function activate()
  activeItem.interact("ScriptPane", config.getParameter("windowConfig"))
end


--[[
require "/scripts/vec2.lua"

function init()
	activeItem.setHoldingItem(false)
  
  if player.getProperty("pat_creditcard") == nil then
    local oldStatus = status.statusProperty("pat_creditcard")
    if oldStatus then
      status.setStatusProperty("pat_creditcard", nil)
    end
    
    player.setProperty("pat_creditcard", oldStatus or 0)
		world.spawnItem("pat_freewatermelon", mcontroller.position(), 1, {}, {0, 0}, 0)
  end
	
	self.heldTime = 0
	self.addCooldown = 0
  
  self.ownerId = activeItem.ownerEntityId()
  
  self.particleParams = {}
  self.particleParams.actionOnReap = root.assetJson("/pat/freemelon/particles/number.projectile").actionOnReap
end

function update(dt, fireMode, shiftHeld)
	--world.debugText("^shadow;"..status.statusProperty("pat_creditcard", 0), vec2.add(mcontroller.position(), {1.5, 1}), "red")
	--world.debugText("^shadow;"..self.addCooldown, vec2.add(mcontroller.position(), {1.5, 0}), "orange")
	--world.debugText("^shadow;"..self.heldTime, vec2.add(mcontroller.position(), {1.5, -1}), "yellow")
	
  local currentCard = player.getProperty("pat_creditcard", 0)
	particle(currentCard)
	
	if fireMode ~= self.lastFireMode then
		self.heldTime = 0
	end
	
	if self.fireMode ~= "none" then
		self.addCooldown = math.max(0, self.addCooldown - dt)
	
    local amount = (shiftHeld and 1 or 10) * (self.heldTime >= 2.5 and 10 or 1) * (self.heldTime >= 5 and 10 or 1) * (self.heldTime >= 10 and 10 or 1)
    
    local currentMoney = player.currency("money")
    
    if self.addCooldown == 0 then
      if fireMode == "primary" and currentMoney > 0 then
        amount = math.min(currentMoney, amount)
        
        player.setProperty("pat_creditcard", currentCard + amount)
        player.consumeCurrency("money", amount)
      end
      
      if fireMode == "alt" and currentCard > 0 then
        amount = math.min(currentCard, amount)
        
        player.addCurrency("money", amount)
        player.setProperty("pat_creditcard", currentCard - amount)
      end
        
      self.addCooldown = math.max(0, 0.25 - (self.heldTime / 10))
    end
    self.heldTime = self.heldTime + dt
  end
	
	self.lastFireMode = fireMode
end

function particle(n)
	self.particleParams.actionOnReap[1].specification.text = "^shadow;"..n
	
  local pos = vec2.add(mcontroller.position(), {0, 2.5 - (mcontroller.crouching() and 1 or 0)})
  
	world.spawnProjectile(
		"pat_creditcardnumber", pos, self.ownerId, {0, 0}, false, self.particleParams
	)
end
]]