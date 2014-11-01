dim: {x:Int, y:Int}
dim = { x=1000, y=800 }

luna y = fittedImage 100 100 "img/luna_400.png" |> toForm |> move ( -((toFloat dim.x)/2) + 50, y)
celestia y = fittedImage 100 100 "img/celestia_400.png" |> toForm |> move ( ((toFloat dim.x)/2) - 50, y)
ball x y = circle 30 |> gradient (radial (10,10) 0 (0,20) 50 [(0,red),(0.8,blue)])

--scene lunaX celestiaX = collage dim.x dim.y [ball 0 0]
scene lunaX celestiaX = collage dim.x dim.y [luna 0, celestia 0, ball 0 0]



main = scene 0 0