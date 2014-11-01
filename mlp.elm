import Keyboard
import Debug

dim: {x:Int, y:Int}
dim = { x=1000, y=800 }

luna y = fittedImage 100 100 "img/luna_400.png" |> toForm |> move ( -((toFloat dim.x)/2) + 50, y)
celestia y = fittedImage 100 100 "img/celestia_400.png" |> toForm |> move ( ((toFloat dim.x)/2) - 50, y)
ball pos = circle 30 |> gradient (radial (10,10) 0 (0,20) 50 [(0,red),(0.8,blue)]) |> move pos

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

updateBall: Float -> (Float,Float) -> (Float, Float)
updateBall direction pos = times (cos direction, sin direction) 5 |> plus pos


-- signals

ponyMove inputs = movement <~ sampleOn (fps 60) inputs

lunaMove = ponyMove Keyboard.wasd
celestiaMove = ponyMove Keyboard.arrows

position = foldp updatePos 0
lunaPos = position lunaMove
celestiaPos = position celestiaMove

ballPos = foldp updateBall (0,0) (constant 0.3 |> sampleOn (fps 60) )


main = scene <~ lunaPos ~ celestiaPos ~ ballPos

--watchLuna = Debug.watch "luna" <~ lunaPos
--watchWasd = Debug.watch "wasd" <~ Keyboard.wasd
watchBall = Debug.watch "ball" <~ ballPos