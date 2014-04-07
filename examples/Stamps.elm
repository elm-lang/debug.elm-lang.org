import Debug
import Mouse
import Window

main : Signal Element
main =
  lift2 scene Window.dimensions (Debug.watch "Stamps" <~ clickLocations)

clickLocations : Signal [(Int,Int)]
clickLocations =
  let position = Debug.watch "Mouse" <~ Mouse.position
  in  foldp (::) [] (sampleOn Mouse.clicks position)

scene : (Int,Int) -> [(Int,Int)] -> Element
scene (w,h) locs =
  let drawPentagon (x,y) =
          ngon 5 20
            |> filled (hsva (toFloat x) 1 1 0.7)
            |> move (toFloat x - toFloat w/2, toFloat h/2 - toFloat y)
            |> rotate (toFloat x)
  in
      layers [ collage w h (map drawPentagon locs)
             , plainText "Click to stamp a pentagon."
             ]
