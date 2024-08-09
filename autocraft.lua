local barrel_name = "" --type here your barrel name. For example: "minecraft:barrel_0"
local turtle_name = "" --type here your turtle name. For example: "turtle_0"
local turtle_id =  -- type here your turtle id. For example: 1
local ing = peripheral.wrap("") --type here your access_point name. For example: "extended_drawers:access_point_0"
local mac = peripheral.wrap("") --type here your macerator name. For example: "modern_industrialization:electric_compressor_0"
local com = peripheral.wrap("") --type here your compressor name. For example: modern_industrialization:electric_compressor_0"
local cut = peripheral.wrap("") --type here your cutting_machine name. For example: "modern_industrialization:electric_cutting_machine_0"
local ass = peripheral.wrap("") --type here your assembler name. For example: "modern_industrialization:assembler_0"
local wir = peripheral.wrap("") --type here your wiremill name. For example: "modern_industrialization:electric_wiremill_0"
local pol = peripheral.wrap("") --type here your polarizer name. For example: "modern_industrialization:polarizer_0"
local mix = peripheral.wrap("") --type here your mixer name. For example: "modern_industrialization:electric_mixer_0"
local fur = peripheral.wrap("") --type here your furnace name. For example: "modern_industrialization:electric_furnace_0"
local all = peripheral.wrap("") --type here your alloy smelter name. For example: "modern_industrialization:alloy_smelter_0"
local asg = peripheral.wrap("") --type here your assembler for cabels name. For example: "modern_industrialization:assembler_0
rednet.open("") --type here the side where rednet modem is 
local mon = peripheral.wrap("") --type here the side where mnitor is
local tur = peripheral.wrap(turtle_name)
local bar = peripheral.wrap(barrel_name)
local barrel = {4,5,6,13,14,15,22,23,24}
local turtle = {1,2,3,5,6,7,9,10,11}
local filename = "recipes.lua"
local line_number = 0

function amount_gui(amount)
	mon.setBackgroundColor(colors.black)
	mon.clear()
	mon.setCursorPos(2,height/2)
	mon.write(ask_craft:match(":(.+)"))
	mon.setCursorPos(2,(height/2)-2)
	mon.write("+1")
	mon.setCursorPos(5,(height/2)-2)
	mon.write("+5")
	mon.setCursorPos(8,(height/2)-2)
	mon.write("+10")
	mon.setCursorPos(12,(height/2)-2)
	mon.write("+50")
	mon.setCursorPos(16,(height/2)-2)
	mon.write("+100")
	mon.setCursorPos(2,(height/2)+2)
	mon.write("-1")
	mon.setCursorPos(5,(height/2)+2)
	mon.write("-5")
	mon.setCursorPos(8,(height/2)+2)
	mon.write("-10")
	mon.setCursorPos(12,(height/2)+2)
	mon.write("-50")
	mon.setCursorPos(16,(height/2)+2)
	mon.write("-100")
	for i = 1, width do
		mon.setCursorPos(i,(height/2)+4)
		mon.write("=")
		mon.setCursorPos(i,(height/2)-4)
		mon.write("=")
	end
	if amount < 0 then
		amount = 0
		mon.setCursorPos(string.len (ask_craft:match(":(.+)")) + 4,height/2)
		mon.write("1")
	elseif amount == 0 then
		mon.setCursorPos(string.len (ask_craft:match(":(.+)")) + 4,height/2)
		mon.write("1")
	else
		mon.setCursorPos(string.len (ask_craft:match(":(.+)")) + 4,height/2)
		mon.write(""..amount)
	end
	
	mon.setBackgroundColor(colors.lightGray)
	mon.setCursorPos((width/2)-3,height-1)
	mon.write("craft")
	mon.setCursorPos(width-1,1)
	mon.write(" X ")
	while true do
		local event, side, x, y = os.pullEvent("monitor_touch")
		if 		y <= (height/2)-1 and y > (height/2)-4 then
			if 		x >= 2 and x <= 3 then
				if amount == 0 then
					amount_gui(amount+2)
				else
					amount_gui(amount+1)
				end
			elseif	x >= 5 and x <= 6 then
				amount_gui(amount+5)
			elseif	x >= 8 and x <= 10 then
				amount_gui(amount+10)
			elseif	x >= 12 and x <= 14 then
				amount_gui(amount+50)
			elseif	x >= 16 and x <= 19 then
				amount_gui(amount+100)
			end
		elseif 	y >= (height/2)+1 and y < (height/2)+4 then
			if 		x >= 2 and x <= 3 then
				amount_gui(amount-1)
			elseif	x >= 5 and x <= 6 then
				amount_gui(amount-5)
			elseif	x >= 8 and x <= 10 then
				amount_gui(amount-10)
			elseif	x >= 12 and x <= 14 then
				amount_gui(amount-50)
			elseif	x >= 16 and x <= 19 then
				amount_gui(amount-100)
			end
		elseif y == height-1 then
			if amount == 0 then
				craft(ask_craft,1)
			else
				craft(ask_craft,amount)
			end
			return
		elseif y == 1 and x > width -2 then
			main_gui(0)
		end
	end
end

function save_gui()
	machines = {"crafting_table","macerator","compressor","cutting_machine","assembler","assembler for cabels","wiremill","polarizer","alloy_smelter","furnace","mixer"}
	mon.setBackgroundColor(colors.black)
	mon.clear()
	mon.setBackgroundColor(colors.gray)
	for i = 1, #machines do
		mon.setCursorPos(2,(i+2)+(i-1))
		mon.write(machines[i])
	end
	mon.setCursorPos(width-1,1)
	mon.write(" X ")
	local event, side, x, y = os.pullEvent("monitor_touch")
	if y > 2 then
		mon.setBackgroundColor(colors.black)
		mon.clear()
		mon.setCursorPos((width/2)-3,(height/2)+1)
		mon.write("SAVING...")
		save_craft(machines[(y-1)/2])
	else 
		mon.setBackgroundColor(colors.black)
		main_gui(0)
	end
	return
end

function main_gui(page)

	file = io.open(filename,"r")
	width, height = mon.getSize()
	ask_craft = nil
	done_rec = {}
	write_rec = {}

	mon.setBackgroundColor(colors.black)
	mon.clear()

	for line in file:lines() do
		line_number = line_number + 1
		if (line_number - 1) % 12 == 0 then 
			done_rec[#done_rec+1] = line:match("([^*]+)")
		end
	end

	table.sort(done_rec, function(a, b)
	    local _, _, a_post_colon = string.find(a, ":(.*)")
	    local _, _, b_post_colon = string.find(b, ":(.*)")
	    return a_post_colon < b_post_colon
	end)

	for i = 1, height-4 do
		if done_rec[i+((height-4)*page)] ~= nil then
			mon.setCursorPos(1,i)
			mon.write(done_rec[i+((height-4)*page)]:match(":(.+)"))
			mon.setCursorPos(1,i)
			mon.write("")
		end
	end
	mon.setCursorPos((width/2)-3,height-2)
	mon.write("<<")
	mon.setCursorPos((width/2)+4,height-2)
	mon.write(">>")
	mon.setCursorPos(width/2+1,height-2)
	mon.write(""..page+1)
	mon.setCursorPos((width/2)-3,height)
	mon.write("save craft")
	mon.setCursorPos(0,0)
	while true do
		local event, side, x, y = os.pullEvent("monitor_touch")
		local last_x, last_y = mon.getCursorPos()
		if y <= height - 4 then
			mon.setBackgroundColor(colors.black)
			mon.clearLine()
			mon.setCursorPos(1,last_y)
			if done_rec[last_y+((height-4)*page)] ~= nil then
				mon.write(done_rec[last_y+((height-4)*page)]:match(":(.+)"))
			end
			mon.setCursorPos(1,y)
			mon.clearLine()
			mon.setBackgroundColor(colors.lightGray)
			if done_rec[y+((height-4)*page)] ~= nil then
				mon.write(done_rec[y+((height-4)*page)]:match(":(.+)"))
				ask_craft = done_rec[y+((height-4)*page)]
			end
		end
		if y == height - 2 then
			if 	   x < width/2 then
				if page > 0 then
					main_gui(page - 1)
				end
			elseif x > (width/2) then
				if done_rec[height-3+((height-4)*page)] ~= nil then
					main_gui(page + 1)
				end
			end
		elseif y == height then
			save_gui()
			return
		elseif last_y == y and y <= height - 4 then
			amount_gui(0)
			return
		end
	end
end

function save_craft(ct_block)

	sv_rec = {}
	sv_amo = {}

	file = io.open(filename,"a")

	for i = 1,9 do 
	    if bar.list()[barrel[i]] ~= nil then
	        sv_rec[i] = bar.list()[barrel[i]].name
	        sv_amo[i] = bar.list()[barrel[i]].count
	        if     ct_block == "crafting_table" then
	            bar.pushItems(turtle_name,barrel[i],1,turtle[i])
	        elseif ct_block == "macerator" then
	            mac.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "compressor" then
	            com.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "cutting_machine" then
	            cut.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "assembler" then
	            ass.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "wiremill" then
	            wir.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "polarizer" then
	            pol.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "alloy_smelter" then
	        	all.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "furnace" then
	        	fur.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "mixer" then
	        	mix.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        elseif ct_block == "assembler for cabels" then
	        	asg.pullItem(barrel_name,sv_rec[i],sv_amo[i])
	        end
	    end
	end
	sleep(0.5)
	while mac.isBusy() or com.isBusy() or cut.isBusy() or ass.isBusy() or wir.isBusy() or pol.isBusy() or all.isBusy() or fur.isBusy() or mix.isBusy() or asg.isBusy() do
	end

	if     ct_block == "crafting_table" then
	    rednet.send(turtle_id,"save")
	    s, msg = rednet.receive()
	    while msg ~= "saved" do
	    end
	elseif ct_block == "macerator" then
	    mac.pushItem(turtle_name)
	elseif ct_block == "compressor" then
	    com.pushItem(turtle_name)
	elseif ct_block == "cutting_machine" then
	    cut.pushItem(turtle_name)
	elseif ct_block == "assembler" then
	    ass.pushItem(turtle_name)
	elseif ct_block == "wiremill" then
	    wir.pushItem(turtle_name)
	elseif ct_block == "polarizer" then
	    pol.pushItem(turtle_name)
	elseif ct_block == "alloy_smelter" then
		all.pushItem(turtle_name)
	elseif ct_block == "furnace" then
		fur.pushItem(turtle_name)
	elseif ct_block == "mixer" then
		mix.pushItem(turtle_name)
	elseif ct_block == "assembler for cabels"  then
		asg.pushItem(turtle_name)
	end

	bar.pullItems(turtle_name,1,64,14)

	file:write(bar.list()[14].name,"*",bar.list()[14].count," = {\n")
	file:write(ct_block,"\n")

	for i = 1,9 do
	    if sv_rec[i] ~= nil then
	        file:write(sv_rec[i],"*",sv_amo[i],"\n")
	    else
	        file:write("-\n")
	    end
	end

	file:write("}\n")
	
	file:close()

	main_gui(0)
end

function craft(ask_craft,amount)

	file = io.open(filename,"r")

	mater = {}
	need_to = {ask_craft}
	need_amount = {}
	notenoth = {}
	rec_list = {}

	for line in file:lines() do
		rec_list[#rec_list+1] = line
	end
	file:close()
	for i, item in ipairs(ing.items()) do
		for k,v in pairs(item) do
			if k == "name" then
				mater[#mater+1] = v
			end
			if k == "count" then
				mater[#mater+1] = v
			end
		end
	end
	for i = 1, #rec_list, 12 do
		if need_to[1] == rec_list[i]:match("([^*]+)%*") then
			need_amount[1] = math.ceil(amount/rec_list[i]:match("%*([^%s]+)"))

			break
		end
	end
	i = 1


	while need_to[i] ~= nil do
		for ii = 1, #rec_list, 12 do
			if need_to[i] == rec_list[ii]:match("([^*]+)%*") then
				for iii = 2,10 do
					if rec_list[ii+iii] ~= "-" then
						iV = 1
						while mater[iV] ~= nil do
							if rec_list[ii+iii]:match("([^*]+)%*") == mater[iV] then
								mater[iV+1] = mater[iV+1] - (rec_list[ii+iii]:match("%*([^%s]+)") * need_amount[i])
								if mater[iV+1] < 0 then
									for V = 1, #rec_list, 12 do
										if rec_list[ii+iii]:match("([^*]+)%*") == rec_list[V]:match("([^*]+)%*") then
											need_to[#need_to+1] = rec_list[ii+iii]:match("([^*]+)%*")
											need_amount[#need_amount+1] =  math.ceil( math.abs (mater[iV+1])/rec_list[V]:match("%*([^%s]+)"))
											mater[iV+1] = mater[iV+1] + (math.ceil( math.abs (mater[iV+1])/rec_list[V]:match("%*([^%s]+)"))*rec_list[V]:match("%*([^%s]+)"))
											break
										elseif V == #rec_list-11 then
											Vi = 0
											repeat
												Vi = Vi + 2
												if rec_list[ii+iii]:match("([^*]+)%*") == notenoth[Vi-1] then
													notenoth[Vi] = notenoth[Vi] + (need_amount[i]*rec_list[ii+iii]:match("%*([^%s]+)"))
													break
												elseif Vi == #notenoth or #notenoth == 0 then

													notenoth[#notenoth+1] = rec_list[ii+iii]:match("([^*]+)%*")
													notenoth[#notenoth+1] = need_amount[i]*rec_list[ii+iii]:match("%*([^%s]+)")
													break
												end
											until notenoth[Vi] == nil
										end
									end
								end
								break
							elseif iV == #mater-1 then
								for V = 1, #rec_list, 12 do
									if rec_list[ii+iii]:match("([^*]+)%*") == rec_list[V]:match("([^*]+)%*") then
										need_to[#need_to+1] = rec_list[ii+iii]:match("([^*]+)%*")
										need_amount[#need_amount+1] = math.ceil((rec_list[ii+iii]:match("%*([^%s]+)") * need_amount[i])/rec_list[V]:match("%*([^%s]+)"))
										mater[#mater+1] = rec_list[ii+iii]:match("([^*]+)%*")
										mater[#mater+1] = math.ceil((rec_list[ii+iii]:match("%*([^%s]+)") * need_amount[i])/rec_list[V]:match("%*([^%s]+)"))*rec_list[V]:match("%*([^%s]+)")
										break
									elseif V == #rec_list-11 then
										Vi = 0
										repeat
											Vi = Vi + 2
											if rec_list[ii+iii]:match("([^*]+)%*") == notenoth[Vi-1] then
												notenoth[Vi] = notenoth[Vi] + (need_amount[i]*rec_list[ii+iii]:match("%*([^%s]+)"))
												break
											elseif Vi == #notenoth or #notenoth == 0 then

												notenoth[#notenoth+1] = rec_list[ii+iii]:match("([^*]+)%*")
												notenoth[#notenoth+1] = need_amount[i]*rec_list[ii+iii]:match("%*([^%s]+)")
												break
											end
										until notenoth[Vi] == nil
									end
								end
							end
							iV = iV + 2
						end
					end
				end
				break
			end
		end
		i = i + 1 
	end
	if #notenoth == 0 then
		amount = math.ceil(amount)
		mon.setBackgroundColor(colors.black)
		mon.clear()
		mon.setCursorPos(2,1)
		mon.write("CRAFTING - "..need_to[1]:match(":(.+)").." * "..need_amount[1])
		for i = #need_to, 1, -1 do
			if need_to[i] ~=  "-" then
				amount = 0
				for ii = 1, #need_to do
					if need_to[ii] == need_to[i] and need_to[ii] ~= "-" then
						amount = amount + need_amount[ii]
						need_craft = need_to[i]
						need_to[ii] = "-"
						need_amount[ii] = "-"
					end
				end
				
				for iii = 1, #rec_list, 12 do
					if need_craft == rec_list[iii]:match("([^*]+)%*") then
						max_num = 0
						for iV = 0, 10 do

							if rec_list[iii+iV]:match("%*([^%s]+)") ~= nil and tonumber(rec_list[iii+iV]:match("%*([^%s]+)")) > max_num then
								max_num = tonumber(rec_list[iii+iV]:match("%*([^%s]+)"))
							end
						end
						if	rec_list[iii+1] == "crafting_table" then
							ct_block = turtle_name
						else
							ct_block = "else"
						end
						
						repeat
							left_to_crat = {}
							for i = 1, #need_to do
								left_to_crat[i] = need_to[i]
							end
							mon.setCursorPos(2,3)
							mon.write("left to craft:")
							mon.setCursorPos(2,5)
							mon.clearLine()
							pos = 4
							for i =#left_to_crat, 1,-1 do
								left_amo = 0
								if left_to_crat[i] ~= "-" then
									pos = pos + 1
									for ii =  1,#left_to_crat do
										if left_to_crat[ii] == left_to_crat[i] and left_to_crat[ii] ~=  "-" then
											left_to_do = left_to_crat[i]
											left_amo = left_amo +  tonumber(need_amount[ii])
											left_to_crat[ii] = "-"
										end
									end
									
									mon.setCursorPos(3,pos+1)
									mon.clearLine()
									
									mon.setCursorPos(3,pos)
									mon.clearLine()
									mon.write(left_to_do:match(":(.+)").." * "..left_amo)
								end
							end
							mon.setCursorPos(3,4)
							mon.clearLine()
							mon.setTextColor(colors.green)
							mon.write((rec_list[iii]:match("([^*]+)%*")):match(":(.+)").." * "..amount)
							mon.setTextColor(colors.white)

							if amount - (math.floor(64/max_num)) >= 0 then
								if rec_list[iii+1] == "crafting_table" then
									for iV = 2, 10 do
										if rec_list[iii+iV] ~= "-" then
											ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")*(math.floor(64/max_num))))
											bar.pushItems(turtle_name,4,tonumber(rec_list[iii+iV]:match("%*([^%s]+)")*(math.floor(64/max_num))),turtle[iV-1])
										end
									end
								else
									for j = 1, math.floor(64/max_num) do
										for iV = 2, 10 do
											if  rec_list[iii+1] == "macerator" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												mac.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "compressor" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												com.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "cutting_machine" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												cut.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "assembler" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												ass.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "wiremill" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												wir.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "polarizer" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												pol.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "alloy_smelter" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												all.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "furnace" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												fur.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "mixer" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												mix.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "assembler for cabels" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												asg.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											end
										end
									end
								end
								if ct_block == turtle_name then
									rednet.send(turtle_id,"craft")
								    s, msg = rednet.receive()
								    while msg ~= "crafted" do
								    end
								else
									sleep(0.5)
									while mac.isBusy() or com.isBusy() or cut.isBusy() or ass.isBusy() or wir.isBusy() or pol.isBusy() or all.isBusy() or fur.isBusy() or mix.isBusy() or asg.isBusy() do
									end
									mac.pushItem(turtle_name)
									com.pushItem(turtle_name)
									cut.pushItem(turtle_name)
									ass.pushItem(turtle_name)
									wir.pushItem(turtle_name)
									pol.pushItem(turtle_name)
									all.pushItem(turtle_name)
									fur.pushItem(turtle_name)
									mix.pushItem(turtle_name)
									asg.pushItem(turtle_name)
									ing.pullItem(turtle_name)
								end
							else
								if rec_list[iii+1] == "crafting_table" then
			 						for iV = 2, 10 do
			 							if rec_list[iii+iV] ~= "-" then
											ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")*amount))
											bar.pushItems(turtle_name,4,tonumber(rec_list[iii+iV]:match("%*([^%s]+)")*amount),turtle[iV-1])
										end
									end

								else
									for j  = 1, amount do
										for iV = 2, 10 do
											if  rec_list[iii+1] == "macerator" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												mac.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "compressor" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												com.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "cutting_machine" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												cut.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "assembler" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												ass.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "wiremill" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												wir.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "polarizer" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												pol.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "alloy_smelter" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												all.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "furnace" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												fur.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "mixer" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												mix.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											elseif  rec_list[iii+1] == "assembler for cabels" and rec_list[iii+iV] ~= "-" then
												ing.pushItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
												asg.pullItem(barrel_name,rec_list[iii+iV]:match("([^*]+)%*"),tonumber(rec_list[iii+iV]:match("%*([^%s]+)")))
											end
										end
									end
								end
								if ct_block == turtle_name then
									rednet.send(turtle_id,"craft")
								    s, msg = rednet.receive()
								    while msg ~= "crafted" do
								    end
								else
									sleep(0.5)
									while mac.isBusy() or com.isBusy() or cut.isBusy() or ass.isBusy() or wir.isBusy() or pol.isBusy() or all.isBusy() or fur.isBusy() or mix.isBusy() or asg.isBusy()do
									end
									mac.pushItem(turtle_name)
									com.pushItem(turtle_name)
									cut.pushItem(turtle_name)
									ass.pushItem(turtle_name)
									wir.pushItem(turtle_name)
									pol.pushItem(turtle_name)
									all.pushItem(turtle_name)
									fur.pushItem(turtle_name)
									mix.pushItem(turtle_name)
									asg.pushItem(turtle_name)
									ing.pullItem(turtle_name)
								end
							end
							amount = amount - (math.floor(64/max_num))
						until amount <= 0  
					end
				end
			end
		end
		main_gui(0)
	else
		gau = 2
		mon.setBackgroundColor(colors.black)
		mon.clear()
		mon.setCursorPos((width/2)-4,1)
		mon.setTextColor(colors.red)
		mon.write("not enoth")
		mon.setTextColor(colors.white)
		for i = 1, #notenoth, 2 do
			gau = gau + 1
			mon.setCursorPos(1,gau)
			mon.write(notenoth[i]:match(":(.+)").." - "..notenoth[i+1])
		end
		local event, side, x, y = os.pullEvent("monitor_touch")
		main_gui(0)
	end
end

main_gui(0)