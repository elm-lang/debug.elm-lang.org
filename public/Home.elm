module Home where

import String
import Website.ColorScheme as C
import Website.Skeleton (home)
import Graphics.Input as Input
import Window

port title : String
port title = "Elm Debugger"

main = home scene

padCol w col =
    let col' = col (w-40) in
    container (w-40) (heightOf col') middle col'

scene w =
    flow down 
    [ spacer w 20
    , width 640 intro
    , try (stamps 640) "Stamps"
    , width 640 intro
    , try (mario 640) "Mario"
    , width 640 intro
    , try (reverser 640) "TextReverse"
    , width 640 rest
    ]

intro = [markdown|

<style>
h1,h2,h3,h4 {
  font-weight:normal;
}
p, li {
  text-align: justify;
  line-height: 1.5em;
}
</style>

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis rutrum porta orci, sed elementum mauris laoreet tristique. Curabitur vehicula ipsum sed dolor tincidunt, at pharetra velit egestas. Aenean pellentesque at tellus nec placerat. Donec vehicula libero in luctus ornare. Aliquam faucibus, risus sit amet lacinia faucibus, est ante consectetur erat, ullamcorper tristique mi orci nec nibh.

Duis dapibus, neque quis blandit mollis, leo felis imperdiet augue, sit amet lacinia sapien tellus sit amet tellus. Mauris consequat posuere quam, id ultrices sapien fermentum ac. Curabitur ante elit, molestie in urna ac, commodo viverra leo. Aliquam blandit, arcu vel consequat fermentum, eros nunc ultricies nisl, mollis sollicitudin velit lacus at odio. Suspendisse potenti.

|]

clicks : Input.Input ()
clicks = Input.input ()

faces : [String]
faces = [ "Lucida Grande", "Trebuchet MS", "Bitstream Vera Sans"
        , "Verdana", "Helvetica", "sans-serif" ]

try : Element -> String -> Element
try video name =
    let href = "/edit/Intermediate/" ++ name ++ ".elm"
        img = "/screenshot/" ++ name ++ ".jpg"

        tryIt = leftAligned . Text.color C.lightGrey . typeface faces .
                Text.height 36 <| toText "Try it!"

        box alpha =
            layers [ image 120 120 img
                   , color (rgba 57 59 58 alpha) <| container 120 120 middle tryIt
                   ]

        button = Input.customButton clicks.handle () (box 1) (box 0.8) (box 0.6)

    in  flow down
        [ spacer 10 20
        , flow right [ video, spacer 40 120, link href button ]
        , spacer 10 20
        ]

stamps w = width w [markdown|

<video width="640" height="320" preload controls>
  <source src="/videos/stamps.mp4" type="video/mp4">
  <source src="/videos/stamps.webm" type="video/webm">
</video>

|]

mario w = width w [markdown|

<video width="640" height="300" preload controls>
  <source src="/videos/mario.mp4" type="video/mp4">
  <source src="/videos/mario.webm" type="video/webm">
</video>

|]

reverser w = width w [markdown|

<video width="640" height="300" preload controls>
  This example is broken.
</video>

|]

rest = [markdown|

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis rutrum porta orci, sed elementum mauris laoreet tristique. Curabitur vehicula ipsum sed dolor tincidunt, at pharetra velit egestas. Aenean pellentesque at tellus nec placerat. Donec vehicula libero in luctus ornare. Aliquam faucibus, risus sit amet lacinia faucibus, est ante consectetur erat, ullamcorper tristique mi orci nec nibh. Duis dapibus, neque quis blandit mollis, leo felis imperdiet augue, sit amet lacinia sapien tellus sit amet tellus. Mauris consequat posuere quam, id ultrices sapien fermentum ac. Curabitur ante elit, molestie in urna ac, commodo viverra leo. Aliquam blandit, arcu vel consequat fermentum, eros nunc ultricies nisl, mollis sollicitudin velit lacus at odio. Suspendisse potenti.

<iframe width="640"
        height="360"
        src="//www.youtube.com/embed/lK0vph1zR8s?list=PLrJ2mLJTxzXcBvJr5iZKetpeqHOJYJ8AW"
        frameborder="0"
        allowfullscreen></iframe>

|]

