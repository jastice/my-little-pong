import Keyboard
import Graphics.Element exposing (image)
import Graphics.Collage exposing (toForm,move,circle,gradient,collage)
import Color exposing (radial,red,blue)
import Signal exposing ((<~),(~),sampleOn,foldp)
import Time exposing (fps)

-- game settings
dim = { x=1000, y=800 }
ponySize = 100
ballSize = 30

ballSpeed = 5
gameFps = 60

-- derived settings
type alias Ball = { pos: (Float,Float), direction: Float }

ponySizeHalf = ponySize / 2
bounds = { xh = (toFloat dim.x) / 2, yh = (toFloat dim.y) / 2 }
lunaBound = -bounds.xh + ponySize
lunaBoundLimit = lunaBound - 5
celestiaBound = bounds.xh - ponySize
celestiaBoundLimit = celestiaBound + 5

luna y = image ponySize ponySize "img/luna_400.png" |> toForm |> move ( -bounds.xh + 50, y)
celestia y = image ponySize ponySize "img/celestia_400.png" |> toForm |> move ( bounds.xh - 50, y)
ball pos = circle ballSize |> gradient (radial (10,10) 0 (0,20) 50 [(0,red),(0.8,blue)]) |> move pos

scene lunaY celestiaY ballXY = collage dim.x dim.y [luna lunaY, celestia celestiaY, ball ballXY]

-- game logic
stopAt = ponySizeHalf

updatePos: Int -> Float -> Float
updatePos y pos = clamp (-bounds.yh + stopAt) (bounds.yh - stopAt) <| pos + (toFloat y) * 8

plus (x0,y0) (x1,y1) = (x0+x1,y0+y1)
times (x,y) s = (x*s, y*s)

checkBounds: Ball -> Ball
checkBounds ball = 
  if (snd ball.pos + ballSize/2 >= bounds.yh) || (snd ball.pos - ballSize/2 <= -bounds.yh)
  then { ball | direction <- -ball.direction}
  else ball

checkPonies: (Float,Float) -> Ball -> Ball
checkPonies (posLuna,posCelestia) ball = 
  let lunaTopBottom = (posLuna + ponySizeHalf, posLuna - ponySizeHalf)
      celestiaTopBottom = (posCelestia + ponySizeHalf, posCelestia - ponySizeHalf)
      (ballX, ballY) = ball.pos
      isReflected (yTop,yBottom) = ballY <= yTop && ballY >= yBottom
  in if ballX <= lunaBound && ballX > lunaBoundLimit && isReflected lunaTopBottom ||
        ballX >= celestiaBound && ballX < celestiaBoundLimit && isReflected celestiaTopBottom
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
      pos1 = times (cos direction, sin direction) ballSpeed |> plus pos
  in { pos = pos1, direction = direction }


-- signals

ponyMove inputs = .y <~ sampleOn (fps gameFps) inputs

position = foldp updatePos 0
lunaPos = position (ponyMove Keyboard.wasd)
celestiaPos = position (ponyMove Keyboard.arrows)

ponyPos = (,) <~ lunaPos ~ celestiaPos
ballState = foldp updateBall {pos=(0,0), direction=0.4} ponyPos
ballPos = .pos <~ ballState

main = scene <~ lunaPos ~ celestiaPos ~ ballPos