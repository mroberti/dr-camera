$gtk.reset()
require 'lib/Camera.rb'
$selectedShip = nil

$path = "sprites/1.jpg"

def setup(args)
    # Create 500 test sprites
  # scroll the camera to the 
  # upper right and see them!
  $numSprites = 300

  # Initialize our camera
  args.state.myCamera = Camera.new(0,0,$path,1024,1024)
    # If not already created, make an array to 
  # store our ship objects, using the Ship object
  args.state.ships ||= $numSprites.map_with_index do |i|
    puts "Creating ship# " +i.to_s
    args.state.ships[i] = [rand(2000),rand(2000),20,20,"sprites/hexagon-green.png"]
  end
  args.state.myCamera.addSprites args.state.ships
  args.state.setup_done = true
end

def moveShips args
  $turnTime = 0
  if(args.state.tick_count%(($turnTime)+1)==0)then
    puts 'Moving'
    # puts 'Tick'
    puts "$selectedShip: " + $selectedShip.to_s
    $selectedShip = $selectedShip + 1
    if($selectedShip>$numSprites-1)then
      $selectedShip=0
    end
    # puts args.state.tick_count
    myVal = rand(4)
    # puts "myVal: " + myVal.to_s
    if myVal==0
      puts "up!"
      args.state.ships[$selectedShip].y += 10
    end
    if myVal==1
      puts "down!"
      args.state.ships[$selectedShip].y -= 10
    end
    if myVal==2
      puts "left!"
      args.state.ships[$selectedShip].x -= 10
    end
    if myVal==3
      puts "right!"
      args.state.ships[$selectedShip].x += 10
    end
  end
end

def render args
  args.state.myCamera.render args

    # Debug data
  args.outputs.labels << [25, row_to_px(args, 0), "Camera X:" + (args.state.myCamera.x.to_s+" Y:"+args.state.myCamera.y.to_s),0, 0, 255, 255, 0, 255, 1]
  args.outputs.labels << [25, row_to_px(args, 1), "Size of layers "+args.state.myCamera.sprites.length().to_s,0, 0, 255, 255, 0, 255, 1]
  args.outputs.labels << [25, row_to_px(args, 2), "FPS "+args.gtk.current_framerate.to_i.to_s,0, 0, 255, 255, 0, 255, 1]
  args.outputs.labels << [25, row_to_px(args, 3), "args.sprites.length "+args.sprites.length.to_s,0, 0, 255, 255, 0, 255, 1]
  args.outputs.labels << [25, row_to_px(args, 4), "Arrays in array camera.sprites "+args.state.myCamera.sprites.length().to_s,0, 0, 255, 255, 0, 255, 1]

  # Get the total count of sprites in the
  # camera's sprites array
  totalSprites = 0
  for layer in args.state.myCamera.sprites do
    totalSprites = totalSprites + layer.length
  end
  args.outputs.labels << [25, row_to_px(args, 5), "Totalsprites in args.state.myCamera.sprites "+totalSprites.to_s,0, 0, 255, 255, 0, 255, 1]
  args.outputs.labels << [25, row_to_px(args, 6), "Totalsprites in args.state.myCamera.visible_sprites "+args.state.myCamera.visible_sprites.length().to_s,0, 0, 255, 255, 0, 255, 1]

end

def checkInput args
  # Input on a specifc key can be found through args.inputs.keyboard.key_up followed by the key
  # I did it for WASD and the arrow keys.
  if args.inputs.keyboard.key_held.a || args.inputs.keyboard.key_held.left
    args.state.myCamera.moveLeft
  elsif args.inputs.keyboard.key_held.right || args.inputs.keyboard.key_held.d
    args.state.myCamera.moveRight
  elsif args.inputs.keyboard.key_held.down || args.inputs.keyboard.key_held.s
    args.state.myCamera.moveDown
  elsif args.inputs.keyboard.key_held.up || args.inputs.keyboard.key_held.w
    args.state.myCamera.moveUp
  end
end

def tick args
  setup(args) unless args.state.setup_done
  checkInput args
  moveShips args
  render args
end

def row_to_px args, row_number
  # This takes a row_number and converts it to pixels DragonRuby understands.
  # Row 0 starts 5 units below the top of the grid
  # Each row afterward is 20 units lower
  args.grid.top.shift_down(5).shift_down(20 * row_number)
end