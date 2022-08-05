local t = 0
local h = math.random(1, 5)
function update(dt)
  t = t + dt
  if t >= h then uninit() end
end
function uninit()
  root.nonEmptyRegion("/assetmissing.png?scalenearest=-1")
end