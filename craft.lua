local bar = peripheral.wrap("") --type here your barrel name. For example: "minecraft:barrel_0"
local ing = peripheral.wrap("") --type here your access_point name. For example: "extended_drawers:access_point_0"
local turtle_name = "" --type here your turtle name. For example: "turtle_0"
local computer_id = 0 --type here your computer id. For example: 1
rednet.open("") --type here the side where rednet modem is 
while true do
   local s , msg = rednet.receive()
   if msg == "save" then
   turtle.craft()
   bar.pullItems(turtle_name,1,64,14) 
   rednet.send(computer_id,"saved")
   elseif msg == "craft" then
   turtle.craft()
   ing.pullItem(turtle_name)
   rednet.send(computer_id,"crafted")
   end
end
   
