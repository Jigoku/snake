function love.load(args)
	mode = 0
end

function start()
	math.randomseed(os.time())
	mode = 1
	wrap = 1
	player = {}
	player.segments = {}
	player.size = 10
	player.score = 0
	player.cycle = 0
	player.dir = 0
	player.speed = 0.04
	
	for i=1,5 do
		table.insert(player.segments, {x=love.graphics.getWidth()/2,y=love.graphics.getHeight()-player.size})
	end
	
	fruit = {}
	fruit.items = {}
	fruit.max = 1
	
	love.graphics.setBackgroundColor(0,100,0,255)
end

function love.draw()

	if mode == 0 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("SNAKE!",10,10)
		love.graphics.print("PRESS SPACE TO START",10,30)
		if player then
			love.graphics.print("YOU SCORED: " .. player.score,10,50)
		end
		return
	end


	for i=0,love.graphics.getWidth(),player.size do
		love.graphics.setColor(0,75,0,255)
		love.graphics.line(i,0,i,love.graphics.getHeight())
	end
	for i=0,love.graphics.getHeight(),player.size do
		love.graphics.setColor(0,75,0,255)
		love.graphics.line(0,i,love.graphics.getWidth(),i)
	end
	
	for i,segment in ipairs(player.segments) do
		love.graphics.setColor(0,200,0,255)
		love.graphics.rectangle("fill",segment.x,segment.y,player.size,player.size)
		love.graphics.setColor(0,100,0,255)
		love.graphics.rectangle("line",segment.x,segment.y,player.size,player.size)
	end
	
	
	for i,item in ipairs(fruit.items) do
		love.graphics.setColor(0,200,0,255)
		love.graphics.rectangle("fill",item.x,item.y,player.size,player.size)
		love.graphics.setColor(0,100,0,255)
		love.graphics.rectangle("line",item.x,item.y,player.size,player.size)
	end
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("SCORE: "..player.score,10,10)
end

function love.update(dt)
	if mode == 0 then return end

	if #fruit.items < fruit.max then
		table.insert(fruit.items, {
			x=math.round(math.random(0,love.graphics.getWidth()-player.size),-1),
			y=math.round(math.random(0,love.graphics.getHeight()-player.size),-1)
		})
	end
	
	if love.keyboard.isDown("up") then 
		if player.dir ~= 2 then
			player.dir = 0 
		end
	elseif love.keyboard.isDown("right") then 
		if player.dir ~= 3 then
			player.dir = 1 
		end
	elseif love.keyboard.isDown("down") then 
		if player.dir ~= 0 then
			player.dir = 2 
		end
	elseif love.keyboard.isDown("left") then 
		if player.dir ~= 1 then
			player.dir = 3
		end
	end
	
	
	player.cycle = math.max(0, player.cycle - dt)

	if player.cycle <= 0 then
		

		table.remove(player.segments,#player.segments)
		
		if player.dir == 0 then 
			table.insert(player.segments,1,{x=player.segments[1].x, y=player.segments[1].y-player.size })
		end
		if player.dir == 1 then 
			table.insert(player.segments,1,{x=player.segments[1].x+player.size, y=player.segments[1].y })
		end
		if player.dir == 2 then 
			table.insert(player.segments,1,{x=player.segments[1].x, y=player.segments[1].y+player.size })
		end
		if player.dir == 3 then 
			table.insert(player.segments,1,{x=player.segments[1].x-player.size, y=player.segments[1].y })
		end
		
		
		
		
		player.cycle = player.speed
	end
	
	for i,segment in ipairs(player.segments) do
		if i ~=1 and collision(player.segments[1].x,player.segments[1].y,player.size,player.size,
			segment.x,segment.y,player.size,player.size) then
			mode = 0
		end
	end
	
	if player.segments[1].x < 0 then 
		if wrap then
			player.segments[1].x = love.graphics.getWidth() - player.size 
		else 
			mode = 0
		end
	end
	
	if player.segments[1].y < 0 then 
		if wrap then
			player.segments[1].y = love.graphics.getHeight() - player.size
		else
			mode = 0
		end
	end
	
	if player.segments[1].x >= love.graphics.getWidth() then 
		if wrap then
			player.segments[1].x = 0
		else
			mode = 0
		end
	end
	
	if player.segments[1].y >= love.graphics.getHeight() then 
		if wrap then 
			player.segments[1].y = 0
		else
			mode = 0
		end
	end
	
	if collision(player.segments[1].x,player.segments[1].y,player.size,player.size,
		fruit.items[1].x,fruit.items[1].y,player.size,player.size) then
			fruit.items = {}
			player.score = player.score + 1
			table.insert(player.segments,{x=player.segments[#player.segments].x,y=player.segments[#player.segments].y})
	end
end


function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "space" and mode == 0 then start() end
end


function collision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end


function math.round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
