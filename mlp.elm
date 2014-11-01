dim: {x:Int, y:Int}
dim = { x=1000, y=800 }

luna y = fittedImage 100 100 "img/luna_200.png" |> toForm |> move ( -((toFloat dim.x)/2) + 50, y)
celestia y = fittedImage 100 100 "img/celestia_200.png" |> toForm |> move ( ((toFloat dim.x)/2) - 50, y)

scene lunaX celestiaX = collage dim.x dim.y [luna 0, celestia 0]

main = scene 0 0