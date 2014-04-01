module Home where

import String
import Website.ColorScheme as C
import Website.Skeleton (home)
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

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis rutrum porta orci, sed elementum mauris laoreet tristique. Curabitur vehicula ipsum sed dolor tincidunt, at pharetra velit egestas. Aenean pellentesque at tellus nec placerat. Donec vehicula libero in luctus ornare. Aliquam faucibus, risus sit amet lacinia faucibus, est ante consectetur erat, ullamcorper tristique mi orci nec nibh. Duis dapibus, neque quis blandit mollis, leo felis imperdiet augue, sit amet lacinia sapien tellus sit amet tellus. Mauris consequat posuere quam, id ultrices sapien fermentum ac. Curabitur ante elit, molestie in urna ac, commodo viverra leo. Aliquam blandit, arcu vel consequat fermentum, eros nunc ultricies nisl, mollis sollicitudin velit lacus at odio. Suspendisse potenti.

<video width="640" height="320" preload controls>
  <source src="/videos/stamps.mp4" type="video/mp4">
  <source src="/videos/stamps.webm" type="video/webm">
</video>

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis rutrum porta orci, sed elementum mauris laoreet tristique. Curabitur vehicula ipsum sed dolor tincidunt, at pharetra velit egestas. Aenean pellentesque at tellus nec placerat. Donec vehicula libero in luctus ornare. Aliquam faucibus, risus sit amet lacinia faucibus, est ante consectetur erat, ullamcorper tristique mi orci nec nibh. Duis dapibus, neque quis blandit mollis, leo felis imperdiet augue, sit amet lacinia sapien tellus sit amet tellus. Mauris consequat posuere quam, id ultrices sapien fermentum ac. Curabitur ante elit, molestie in urna ac, commodo viverra leo. Aliquam blandit, arcu vel consequat fermentum, eros nunc ultricies nisl, mollis sollicitudin velit lacus at odio. Suspendisse potenti.

<video width="640" height="300" preload controls>
  <source src="/videos/mario.mp4" type="video/mp4">
  <source src="/videos/mario.webm" type="video/webm">
</video>

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis rutrum porta orci, sed elementum mauris laoreet tristique. Curabitur vehicula ipsum sed dolor tincidunt, at pharetra velit egestas. Aenean pellentesque at tellus nec placerat. Donec vehicula libero in luctus ornare. Aliquam faucibus, risus sit amet lacinia faucibus, est ante consectetur erat, ullamcorper tristique mi orci nec nibh. Duis dapibus, neque quis blandit mollis, leo felis imperdiet augue, sit amet lacinia sapien tellus sit amet tellus. Mauris consequat posuere quam, id ultrices sapien fermentum ac. Curabitur ante elit, molestie in urna ac, commodo viverra leo. Aliquam blandit, arcu vel consequat fermentum, eros nunc ultricies nisl, mollis sollicitudin velit lacus at odio. Suspendisse potenti.

<iframe width="640"
        height="360"
        src="//www.youtube.com/embed/lK0vph1zR8s?list=PLrJ2mLJTxzXcBvJr5iZKetpeqHOJYJ8AW"
        frameborder="0"
        allowfullscreen></iframe>

|]

