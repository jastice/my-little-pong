import Keyboard
import Debug

type Ball = { pos: (Float,Float), direction: Float }

dim = { x=1000, y=800 }

bounds = { xh = (toFloat dim.x) / 2, yh = (toFloat dim.y) / 2 }

ballsize = 30

luna y = image 100 100 "img/luna_400.png" |> toForm |> move ( -bounds.xh + 50, y)
celestia y = image 100 100 "img/celestia_400.png" |> toForm |> move ( bounds.xh - 50, y)
ball pos = circle ballsize |> gradient (radial (10,10) 0 (0,20) 50 [(0,red),(0.8,blue)]) |> move pos

scene lunaY celestiaY ballXY = collage dim.x dim.y [luna lunaY, celestia celestiaY, ball ballXY]

data PonyMove = Up | Down | Still

movement {x,y} = 
  if | y == 1 -> Up 
     | y == -1 -> Down
     | otherwise -> Still


updatePos: PonyMove -> Float -> Float
updatePos mv pos = case mv of
  Up -> pos + 8
  Down -> pos - 8
  Still -> pos

plus (x0,y0) (x1,y1) = (x0+x1,y0+y1)
times (x,y) s = (x*s, y*s)

checkBounds: Ball -> Ball
checkBounds ball = 
  if (snd ball.pos + ballsize/2 >= bounds.yh) || (snd ball.pos - ballsize/2 <= -bounds.yh)
  then { ball | direction <- -ball.direction}
  else ball

checkPonies: (Float,Float) -> Ball -> Ball
checkPonies (posLuna,posCelestia) ball = 
  let lunaBound = -bounds.xh + 100
      lunaTopBottom = (posLuna + 50, posLuna - 50)
      celestiaBound = bounds.xh - 100
      celestiaTopBottom = (posCelestia + 50, posCelestia - 50)
      (ballX, ballY) = ball.pos
      isReflected (yTop,yBottom) = ballY <= yTop && ballY >= yBottom
  in if ballX <= lunaBound && isReflected lunaTopBottom ||
        ballX >= celestiaBound && isReflected celestiaTopBottom
     then {ball | direction <- pi-ball.direction}
     else ball

checkReset: Ball -> Ball
checkReset ball = 
  let (x,y) = ball.pos
  in if x < -bounds.xh || x > bounds.xh
     then { pos = (0,0), direction = -(pi-ball.direction) }
     else ball

updateBall: (Float,Float) -> Ball -> Ball
updateBall ponies ball = 
  let ball1 = checkBounds ball
      ball2 = checkPonies ponies ball1
      {pos,direction} = checkReset ball2
      pos1 = times (cos direction, sin direction) 5 |> plus pos
  in { pos = pos1, direction = direction }

-- signals

ponyMove inputs = movement <~ sampleOn (fps 60) inputs

position = foldp updatePos 0
lunaPos = position (ponyMove Keyboard.wasd)
celestiaPos = position (ponyMove Keyboard.arrows)

ponyPos = (,) <~ lunaPos ~ celestiaPos
ballState = foldp updateBall {pos=(0,0), direction=0.4} ponyPos
ballPos = .pos <~ ballState

main = scene <~ lunaPos ~ celestiaPos ~ ballPos

watchBall = Debug.watch "ball" <~ ballState