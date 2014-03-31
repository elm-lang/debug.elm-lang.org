module Website.Skeleton (home) where

import Graphics.Input as Input
import Graphics.Input.Field as F
import Website.ColorScheme as C
import Graphics.Input as Input
import Window

headerHeight = 80
footerHeight = 60

home : (Int -> Element) -> Signal Element
home bodyFunc = internalHome bodyFunc <~ Window.dimensions

internalHome : (Int -> Element) -> (Int,Int) -> Element
internalHome bodyFunc (outer,h) =
    let margin = outer `div` 10
        inner = outer - 2 * homeHeaderHeight
        content = bodyFunc inner
    in
    color C.lightGrey <|
    flow down
    [ homeHeader outer inner
    , let contentHeight = max (heightOf content)
                              (h - homeHeaderHeight - footerHeight)
      in  container outer contentHeight (topLeftAt (absolute homeHeaderHeight) (absolute 0)) content
    , footer outer
    ]

clicks : Input.Input ()
clicks = Input.input ()

logoButton : Element
logoButton =
    let box src =
            image 80 80 ("/elm_logo_" ++ src ++ ".svg")
                |> container tileSize tileSize middle
                |> color (rgb 57 59 58)
    in
        Input.customButton clicks.handle () (box "muted") (box "color") (box "color")

browseButton : Element
browseButton = 
    let box c = color c <| container 122 52 middle <|
                color C.accent4 <| container 120 50 middle <|
                leftAligned . Text.height 20 . Text.color C.lightGrey <| toText "Browse"
    in  Input.customButton clicks.handle () (box C.mediumGrey) (box C.lightGrey) (box white)

tileSize = 84
homeHeaderHeight = 3 * (tileSize `div` 2)
homeHeader outer inner =
    color (rgb 60 60 60) <| layers
    [ tiledImage outer homeHeaderHeight "/tile.png"
    , flow right [ container homeHeaderHeight homeHeaderHeight middle <|
                   link "http://elm-lang.org" logoButton
                 , container inner homeHeaderHeight midLeft title
                 ]
    ]

bigWords : Text
bigWords = Text.height 40 <| Text.color C.mediumGrey <| toText "Elm&rsquo;s Reactive Debugger"

title : Element
title =
    flow down
    [ link "/" <| leftAligned <| bigWords
    , spacer 10 4
    , leftAligned . Text.height 16 . Text.color C.mediumGrey <|
          toText "Bret Victor style debugging, implemented in real life."
    ]

footer outer = container outer footerHeight footerPosition <| Text.centered footerWords
footerPosition = midBottomAt (relative 0.5) (absolute 10)
footerWords =
    let href = "https://github.com/elm-lang/elm-debugger"
    in
        Text.color (rgb 145 145 145) <|
            Text.link href (toText "open source") ++ toText " &copy;2014"
