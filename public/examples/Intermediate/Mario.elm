import Keyboard
import Window
import Debug

-- MODEL
mario = { x=0, y=0, vx=0, vy=0, dir="right" }


-- UPDATE -- ("m" is for Mario)
jump {y} m = if y > 0 && m.vy == 0
             then { m | vy <- 6 }
             else m
gravity t m = if m.y > 0
              then { m | vy <- m.vy - 0.5 }
              else { m | vy <- 0 }
physics t m =
  { m | x <- m.x + t*m.vx
      , y <- max 0 (m.y + t*m.vy) }
walk {x} m =
  { m | vx <- toFloat x
      , dir <- if | x < 0     -> "left"
                  | x > 0     -> "right"
                  | otherwise -> m.dir }

step (t,dir) =
  physics t . walk dir . jump dir . gravity t


-- DISPLAY
render (w',h') mario =
  let (w,h) = (toFloat w', toFloat h')
      verb = if | mario.y  >  0 -> "jump"
                | mario.vx /= 0 -> "walk"
                | otherwise     -> "stand"
      src  = "/imgs/mario/"++ verb ++ "/"
             ++ mario.dir ++ ".gif"
      marioImage = image 35 35 src
      groundY = 62 - h/2
  in collage w' h'
      [ rect w h  |> filled (rgb 174 238 238)
      , rect w 50 |> filled (rgb 74 163 41)
                  |> move (0, 24 - h/2)
      , marioImage
          |> toForm
          |> move (mario.x, mario.y + groundY)
      ]

-- MARIO
input =
  let delta = lift (\t -> t/20) (fps 25)
      deltaArrows =
        lift2 (,) delta Keyboard.arrows
  in deltaArrows |> sampleOn delta

main  = lift2 render
              Window.dimensions
              (foldp step mario input)
