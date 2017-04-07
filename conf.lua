
function love.conf(t)
	t.identity = "snake"
	t.version = "0.10.1"
	t.window.title = "snake"
	t.window.width = 400
	t.window.height = 600
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.touch = false
	t.modules.video = false 
	t.window.msaa = 0
	t.window.fsaa = 0
	t.window.display = 1
	t.window.resizable = false
	t.window.vsync = true
end
