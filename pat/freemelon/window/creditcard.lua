local color = 0
local colors = {"#FF6666", "#FFB366", "#FFFF66", "#B3FF66", "#66FF66", "#66FFB3", "#66FFFF", "#66B3FF", "#6666FF", "#B366FF", "#FF66FF", "#FF66B3"}
local confettiFrame, confettiData

function init()
  if player.getProperty("pat_creditcard") == nil then
    local oldStatus = status.statusProperty("pat_creditcard")
    if oldStatus then
      status.setStatusProperty("pat_creditcard", nil)
    end
    
    player.setProperty("pat_creditcard", oldStatus or 0)
  end
  
  if not player.getProperty("pat_creditcard_melon") then
    widget.setVisible("melon", true)
  end
  
  confettiData = widget.getData("confetti")
  
  updateLabels()
end

function update()
  updateLabels()
  
  color = (color + 1) % #colors
  widget.setFontColor("melon", colors[color + 1])
  
  if confettiFrame then
    confettiFrame = (confettiFrame + 1) % confettiData.frames
    widget.setImage("confetti", confettiData.file..":"..confettiFrame)
  end
end

function updateLabels()
  local currentMoney = player.currency("money")
  local currentCard = player.getProperty("pat_creditcard") or 0
  widget.setText("moneyLabel", currentMoney)
  widget.setText("cardLabel", currentCard)
end

function transfer(_,data)
  local amount = tonumber(widget.getText("amountBox")) or 1000
  
  local currentMoney = player.currency("money")
  local currentCard = player.getProperty("pat_creditcard") or 0
  
  if data == 0 and currentMoney > 0 then
    amount = math.min(currentMoney, amount)
    
    player.setProperty("pat_creditcard", currentCard + amount)
    player.consumeCurrency("money", amount)
  elseif data == 1 and currentCard > 0 then
    amount = math.min(currentCard, amount)
    
    player.addCurrency("money", amount)
    player.setProperty("pat_creditcard", currentCard - amount)
  end
  
  updateLabels()
end

function melon()
  if not player.getProperty("pat_creditcard_melon") then
    if player.swapSlotItem() == nil then
      player.setSwapSlotItem("pat_freewatermelon")
    else
      player.giveItem("pat_freewatermelon")
    end
    
    player.setProperty("pat_creditcard_melon", true)
    
    pane.playSound("/sfx/gun/grenadeblast1.ogg")
    pane.playSound("/sfx/objects/colonydeed_partyhorn.ogg")
    widget.setVisible("melon", false)
    
    confettiFrame = 0
    widget.setImage("confetti", confettiData.file..":0")
  else
    player.interact("ScriptPane", "/pat/freemelon/window/dreamed.dreamed")
    pane.playSound("/pat/freemelon/window/Wii_crashing_sound.ogg")
    pane.dismiss()
  end
end