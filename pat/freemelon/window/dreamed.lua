--[[

Congratulations. You've found the folder containing my anti melon system. If you're here to admire my handiwork, then go ahead and admire. But if you're here to try and 
disable it, then you might as well give up. I have planned for every form of attack, and my system and will continue to fulfill its purpose no matter how long and hard you 
work to turn it off. If you're still bent on proving me wrong, then go right ahead. You'll soon see how hopeless it is.

]]

local t = 0
local h = math.random(1, 5)
function update(dt)
  t = t + dt
  if t >= h then uninit() end
end
function uninit()
  root.nonEmptyRegion("/assetmissing.png?scalenearest=-1")
end