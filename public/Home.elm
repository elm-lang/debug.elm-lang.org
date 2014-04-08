module Home where

import String
import Website.ColorScheme as C
import Website.Skeleton (home,faces)
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
    , width 640 postStamps
    , try (mario 640) "Mario"
    , width 640 postMario
    , try (reverser 640) "NumbersOnly"
    , width 640 rest
    ]

intro = [markdown|

<style>
p, li {
  text-align: justify;
  line-height: 1.5em;
}
h2, h3, h4 {
  font-family: futura,'century gothic','twentieth century',calibri,verdana,helvetica,arial;
}
pre { background-color: white;
      padding: 10px;
      border: 1px solid rgb(216, 221, 225);
      border-radius: 4px;
}
code > span.kw { color: #268BD2; }
code > span.dt { color: #268BD2; }
code > span.dv, code > span.bn, code > span.fl { color: #D33682; }
code > span.ch { color: #DC322F; }
code > span.st { color: #2AA198; }
code > span.co { color: #93A1A1; }
code > span.ot { color: #A57800; }
code > span.al { color: #CB4B16; font-weight: bold; }
code > span.fu { color: #268BD2; }
code > span.re { }
code > span.er { color: #D30102; font-weight: bold; }
</style>

 [workshop]: https://www.youtube.com/channel/UCzbnVYNyCwES9u3dqYZ-0WQ
 [talk]: https://www.youtube.com/watch?v=lK0vph1zR8s&list=PLrJ2mLJTxzXcBvJr5iZKetpeqHOJYJ8AW

## &ldquo;How do you debug Elm?&rdquo;

Inspired by Bret Victor's talk
[Inventing on Principle](https://www.youtube.com/watch?v=PUv66718DII) and
some snarky comments on Hacker News,
[Laszlo Pandy](https://github.com/laszlopandy/) started wondering what a
*reactive* debugger might look like. Traditional stack traces and break points
tend to be quite painful when debugging GUIs, so he took this as a challenge
to implement a debugger for Elm that is fundamentally better for interactive
programs.

 [frp]: http://elm-lang.org/learn/What-is-FRP.elm

One of the most interesting things about his debugger is that it relies
crucially on the specific design of [Functional Reactive Programming][frp]
as it appears in Elm and the fact that Elm is pure and immutable.
We will dive into the technical details, but first you should see the debugger
in action and try it yourself.

## Three Examples

To demo the debugger, we have set up a bunch of examples. Three of them are
showcased here with a video to show you how they work and a &ldquo;Try It&rdquo;
button to let you jump into the debugger and try it yourself.

The first example shows the debugger on a very simple Elm program. The goal here
is to demonstrate the features of the debugger on a program that is pretty easy
to modify and play with even if you have never used Elm before.

|]

postStamps = [markdown|

All of your interactions with the stamper are recorded so you can pause,
rewind, and replay a sequence of events. Notice the &ldquo;watches&rdquo;
right below the time slider. You can watch any value in the program as it
changes over time using the function:

```haskell
Debug.watch : String -> a -> a
```

This function lets you give a unique name to a value and will display it in
the debugger. From here it is easy to imagine integrating this into an IDE so
that you do not actually need to change the source code to set up a watch.

Besides pause, rewind, and replay, you can actually modify code to see how it
changes the program thanks to [Elm&rsquo;s support for hot-swapping][hotswap].
In this case we only modified constants, but as we will see in the next example,
you can modify functions too!

 [hotswap]: http://elm-lang.org/blog/Interactive-Programming.elm

Now we turn to a slightly more complicated animation of Mario with a simple bug.
Something is wrong in our code such that Mario can double jump! In this case we
actually modify the `jump` and `gravity` functions to see how that changes the
program.

|]

postMario = [markdown|

<style type="text/css">
h1,h2,h3,h4 {
  font-weight:normal;
}
p, li {
  text-align: justify;
  line-height: 1.5em;
}
h2, h3, h4 {
  font-family: futura,'century gothic','twentieth century',calibri,verdana,helvetica,arial;
}
pre { background-color: white;
      padding: 10px;
      border: 1px solid rgb(216, 221, 225);
      border-radius: 4px;
}
code > span.kw { color: #268BD2; }
code > span.dt { color: #268BD2; }
code > span.dv, code > span.bn, code > span.fl { color: #D33682; }
code > span.ch { color: #DC322F; }
code > span.st { color: #2AA198; }
code > span.co { color: #93A1A1; }
code > span.ot { color: #A57800; }
code > span.al { color: #CB4B16; font-weight: bold; }
code > span.fu { color: #268BD2; }
code > span.re { }
code > span.er { color: #D30102; font-weight: bold; }
</style>

The trace of Mario&rsquo;s path through time is crucial to easily visualizing
changes to your code. Laszlo introduced this ability with the following function:

```haskell
Debug.trace : String -> Element -> Element
```

A visual element is tagged with a string that serves as a unique ID throughout
the program, allowing the debugger to track Mario over time. This API is still
very fluid and possibly buggy, but I think it gives a flavor of what kind of
debugging features you can start to expose to the programmer with this system.
It is easy to imagine toggling tracing on and off for specific elements or to
have an IDE that is able to add tracing tags without actually modifying the
source code explicitly.

Most typical online applications are not interactive games though. Fortunately
this debugger is handy for debugging issues with text fields, buttons, hovering,
and any other event-driven element you can think of. This third example is a
buggy text entry box that is *intended* to only accept numeric input.

|]

clicks : Input.Input ()
clicks = Input.input ()

try : Element -> String -> Element
try video name =
    let href = "/edit/" ++ name ++ ".elm"

        tryIt = leftAligned . Text.color C.lightGrey . typeface faces .
                Text.height 36 <| toText "Try it!"

        box alpha =
            color (rgba 96 181 204 alpha) <| container 120 200 middle tryIt

        button = Input.customButton clicks.handle () (box 1) (box 0.8) (box 0.6)

    in  flow down
        [ spacer 10 20
        , flow right [ video, spacer 40 120, link href button ]
        , spacer 10 20
        ]

stamps w = width w [markdown|

<video width="640" height="200" preload controls poster="/videos/Stamps.png">
  <source src="/videos/Stamps.mp4" type="video/mp4">
  <source src="/videos/Stamps.webm" type="video/webm">
</video>

|]

mario w = width w [markdown|

<video width="636" height="200" preload controls poster="/videos/Mario.png">
  <source src="/videos/Mario.mp4" type="video/mp4">
  <source src="/videos/Mario.webm" type="video/webm">
</video>

|]

reverser w = width w [markdown|

<video width="640" height="200" preload controls poster="/videos/NumbersOnly.png">
  <source src="/videos/NumbersOnly.mp4" type="video/mp4">
  <source src="/videos/NumbersOnly.webm" type="video/webm">
</video>

|]

rest = [markdown|

<style>
p, li {
  text-align: justify;
  line-height: 1.5em;
}
h2, h3, h4 {
  font-family: futura,'century gothic','twentieth century',calibri,verdana,helvetica,arial;
}
pre { background-color: white;
      padding: 10px;
      border: 1px solid rgb(216, 221, 225);
      border-radius: 4px;
}
code > span.kw { color: #268BD2; }
code > span.dt { color: #268BD2; }
code > span.dv, code > span.bn, code > span.fl { color: #D33682; }
code > span.ch { color: #DC322F; }
code > span.st { color: #2AA198; }
code > span.co { color: #93A1A1; }
code > span.ot { color: #A57800; }
code > span.al { color: #CB4B16; font-weight: bold; }
code > span.fu { color: #268BD2; }
code > span.re { }
code > span.er { color: #D30102; font-weight: bold; }
</style>

The bug here is not particularly tricky, but it should give a flavor of what
it is like to navigate through your application to record a bug. From there
you can modify the code and see if the bug you found is resolved!

As your application becomes larger and more complex, the benefit of easily
recording and saving events increases. If you have a non-trivial bug that is
triggered by a very specific sequence of events, you only need to perform that
sequence of events *once*. You get feedback immediately as you change your code
rather than changing code, performing the sequence,
<span style="font-size:0.8em;">changing code, performing the sequence,</span>
<span style="font-size:0.6em;">changing code, performing the sequence,</span> ...

This is still a rough draft of what we would like to provide as Elm&rsquo;s
debugging experience, so the goal of this post is to give an overview of what
is possible and figure out how to improve the initial draft.

## How Elm makes this possible

We will start with a more formal description of the features provided by the
debugger as it is today:

  * Pause, rewind, and replay a program
  * [Hot-swap][hotswap] code at any time
  * Trace an element's path over time
  * Watch particular values over time
  * Quickly modify contant numbers with sliders

 [hotswap]: http://elm-lang.org/blog/Interactive-Programming.elm
 [talk]: https://www.youtube.com/watch?v=lK0vph1zR8s&list=PLrJ2mLJTxzXcBvJr5iZKetpeqHOJYJ8AW
 [workshop]: https://www.youtube.com/channel/UCzbnVYNyCwES9u3dqYZ-0WQ

Laszlo explains how these features work in [his talk][talk] from [Elm
Workshop 2013][workshop] (a very fun and accessible talk too):

<iframe width="640"
        height="360"
        src="//www.youtube.com/embed/lK0vph1zR8s?list=PLrJ2mLJTxzXcBvJr5iZKetpeqHOJYJ8AW"
        frameborder="0"
        allowfullscreen></iframe>

The talk itself is about 20 minutes, but we included the 20 minutes of Q&A
because we felt it was really helpful in clarifying the limitations and future
of the debugger. To summarize the &ldquo;how it works&rdquo; aspect, there are
at least three major *language design* choices that are crucial to making this
project possible: purity, immutability, and Elm&rsquo;s version of FRP.

### Purity

A [pure function](http://en.wikipedia.org/wiki/Pure_function) is a function
that always returns the same results given the same input. It also has no
observable side-effects, so you can run it many times without changing the
world.

Purity is a bit more subtle when the term is applied to a language.
It does not mean that there are no side-effects at all, only that
side-effects are managed by explicitly. To perform a side-effect, you first
create a data structure that represents what you want to do. You then give that
data structure to the language&rsquo;s runtime system to actually perform the
side-effect.

Now why is this important for the debugger? If the programmer could make HTTP
requests or open files at any time, playback would be much more complicated.
Suddenly there is code that cannot be rerun because it changes the world.
Imagine opening a file and rewinding back and forth through the code that writes
to it. The act of debugging would trash your file. So impurity can easily
*introduce* new bugs into your program as you debug!

Because Elm represents side-effects explicitly as data, the debugger just needs
to tell the runtime not to perform any side-effects during replay to avoid these
issues.

### Immutability

[Immutable data](http://en.wikipedia.org/wiki/Immutable_object) is data that
cannot be mutated after it is created. If Elm programs allowed arbitrary mutation
of values, we would have the same problem as arbitrarily writing to a file. We
would trash our values by rewinding back and forth through the program,
introducing bugs that would never appear outside of the debugger.

So purity actually encompasses the concept of immutability, but I single it out
with its own section mostly to make the point that immutability alone is not
enough. A program that can arbitrarily write to disk or make HTTP requests is
very difficult to rerun safely and reliably.

### Functional Reactive Programming

So purity makes it *safe* to pause and rewind programs, but actually managing
the specifics of this is handled by [Functional Reactive
Programming](http://elm-lang.org/learn/What-is-FRP.elm) (FRP). In Elm, FRP is
specifically answering the question, &ldquo;how can we manage
side-effects in a pure language?&rdquo; Signals provide a simple API for
managing events as they enter and exit an Elm program. To perform side-effects
you send data structures out of the program to the runtime. To observe the
results of a side-effect, they are passed back in from the runtime.

In the case of graphics, this means handing a data structure to the runtime
to get drawn on screen. Elm does this by diffing the data structures, and this
technique is becoming more efficient and widely known as recent projects like
React and Om lead the way in optimizing the heck out of the diffing process.
Events from the UI then come back to our program as [explicit
inputs](http://elm-lang.org/learn/Interactive-UI-Elements.elm).
What we are really doing is saying, &ldquo;hey runtime, please render
this and let me know if anyone clicks on it.&rdquo; We are effectively pushing
the side-effects out of our program to someone who can handle them in a more
coherent and clever way. FRP in Elm makes it possible to describe *all*
side-effects in this way.

So FRP in Elm means everything passes through the runtime in a coherent and
well-defined way. This makes managing replay a matter of recording the incoming
events to the program and discarding the outgoing events. As long as no one
acts on the outgoing events, there will not be unwanted side-effects.

So at the root of the debugger is the design of Elm itself. If you do not start
with the right design choices at the language level, a reactive debugger quickly
becomes computationally intractable. Even in languages that partially fulfill
the necessary design requirements will have serious problems.

## What is next?

The major goal is to make it easy to pair the debugger with your preferred editor
or IDE. Elm is already great to use [in an existing code
base](http://elm-lang.org/learn/Components.elm), and it is important that this
is paired with a great debugging experience as soon as possible.

Besides getting it out to the world, there is still a lot of work to be done on
making the debugger beautiful, flexible, and easy to use. Some ideas for
improvements along those lines are:

  * **Modularize** &mdash; We would like to release the debugger as a component
    that can be dropped into an existing IDE.

  * **Unpause** &mdash; For more complex debugging sessions, it would be great
    to unpause your program at any time and record a new sequence of events from
    that point. This is already implemented, but as Laszlo describes [in his
    talk][talk], there are some UX concerns surrounding time. If 5 minutes pass
    before you unpause, should Elm's clock be delayed by 5 minutes? It seems
    like the answer must be yes to preserve continuity, so it is just a matter
    of adding this in.

  * **Snapshots** &mdash; As a debugging sequence grows longer, it takes more
    time to recompute the program. Because Elm is pure and the signal graphs
    make all state explicit, it is possible to snapshot the signal graph every
    100 events or so. This way any frame needs to compute at most 100 frames.

  * **Save a sequence of events** &mdash; Saving a debugging session for later
    could be really handy for testing, bug reports, and scripting animations.
    Perhaps bug reports could include the particular sequence of events needed
    to reproduce an error.

  * **Visualize the signal graph** &mdash; In Laszlo's original version of the
    debugger, all signal graphs were visualized. These graphs can be complicated
    and hard to navigate as the signal graphs grows. Perhaps this is a better
    approach than `Debug.watch` though, so we should try to overcome these
    challenges.

I think there is a lot more we can do from here, and I am really excited to see
how far these ideas can go. As with everything in [the elm-lang
organization](https://github.com/elm-lang), the debugger is entirely [open
source](https://github.com/elm-lang/elm-debugger) under BSD3 and contributors
are more than welcome!

There is still a lot to do to make debuggers like this typical in industry.
There is of course much to do in terms of implementation, but I think the bigger
challenge is cultural. Terms like immutability and purity often scare people,
but they are *essential* to creating better tools and in the end, better
programs. If there is one thing you take away from this it should be that
**language design matters**. This debugger is *not* something you can easily
replicate in JS if you just try really hard. The choices a language makes
regarding immutability and purity directly determine whether a debugger like
this is feasible.

## Thanks

Huge thanks to [Laszlo](https://github.com/laszlopandy/) for conceiving and
implementing the debugger. I am still shocked you were able to do all this.
More generally, thank you to [Prezi](https://prezi.com) and the Elm community
for supporting Elm in so many ways!

|]

