import Keyboard
import Window
import Debug

-- MODEL
mario = { x=0, y=0, vx=0, vy=0, dir="right" }


-- UPDATE --
jump {y} mario =
    if y > 0 && mario.vy == 0
      then { mario | vy <- 6.0 }
      else mario

gravity t mario =
    { mario | vy <- if mario.y > 0 then mario.vy - 0.5 else 0 }

physics t mario =
    { mario | x <- mario.x + t * mario.vx
            , y <- max 0 (mario.y + t * mario.vy) }

walk {x} mario =
    { mario | vx <- toFloat x
            , dir <- if | x < 0     -> "left"
                        | x > 0     -> "right"
                        | otherwise -> mario.dir }

step (t,dir) mario =
  Debug.watch "Mario" (physics t (walk dir (jump dir (gravity t mario))))


-- DISPLAY
render (w',h') mario =
  let (w,h) = (toFloat w', toFloat h')
      verb = if | mario.y  >  0 -> "jump"
                | mario.vx /= 0 -> "walk"
                | otherwise     -> "stand"
      src  = "/imgs/mario/"++ verb ++ "/" ++ mario.dir ++ ".gif"
      marioImage = image 35 35 src
      groundY = 62 - h/2
  in collage w' h'
      [ rect w h  |> filled (rgb 174 238 238)
      , rect w 50 |> filled (rgb 74 163 41)
                  |> move (0, 24 - h/2)
      , marioImage
          |> Debug.trace "mario"
          |> toForm
          |> move (mario.x, mario.y + groundY)
      ]

-- MARIO
input =
  let delta = lift (\t -> t/20) (fps 25)
      deltaArrows =
        lift2 (,) delta (Debug.watch "Arrows" <~ Keyboard.arrows)
  in sampleOn delta deltaArrows

main  = lift2 render Window.dimensions (foldp step mario input)
