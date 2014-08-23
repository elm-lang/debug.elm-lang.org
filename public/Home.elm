module Home where

import String
import Website.ColorScheme as C
import Website.Skeleton (home,faces)
import Graphics.Input as Input
import Text as Text
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

 [interactive]: http://en.wikipedia.org/wiki/Interactive_programming
 [inventing]: https://www.youtube.com/watch?v=PUv66718DII
 [frp]: http://elm-lang.org/learn/What-is-FRP.elm
 [hotswap]: http://elm-lang.org/blog/Interactive-Programming.elm
 [laszlo]: https://github.com/laszlopandy/
 [src]: https://github.com/elm-lang/debug.elm-lang.org

Our debuggers are limited by our programming languages. In languages like
C++, Java, and JavaScript, we step through stack traces because that is the
most concise way to express the meaning of an imperative program. We step forward,
one command at a time, mutating variables, writing to files, sending requests.
These debuggers typically only go forward because each step may *destroy* past
state. In short, low-level languages lead to low-level debuggers.

So what does a debugger look like for a high-level language like
[Elm](http://elm-lang.org/)? What is
possible when you have purity, [FRP][frp], and [hot-swapping][hotswap]?
At Elm Workshop 2013, Laszlo Pandy presented [the Elm Debugger][src].
Inspired by talks like Bret Victor&rsquo;s [Inventing on Principle][inventing],
Laszlo implemented a debugger that lets you travel backwards and forwards in
time. It lets you change history. On a deeper level, it lets you visualize and
interact with a program&rsquo;s *meaning*. It lets you *see* how a program
changes over time.

## Three Examples

The Elm Debugger is all about visualizing and interacting with meaning, so in
that spirit, the following three examples are paired with a short video demo
and a link to the online debugger. The videos will help even if they are muted,
so watch them!

Our first example demonstrates the basics of the debugger. We use a very simple
stamping program to see the ability to time travel and change history:

|]

postStamps = [markdown|

All of your interactions with the stamper are recorded so you can pause,
rewind, and replay a sequence of events. You can also [modify code at any
time][hotswap] to see how it changes things. This makes it easy to see how our
stamps change over time, but what if we need to be more precise? For example,
where is the fourth stamp *exactly*?

 [hotswap]: http://elm-lang.org/blog/Interactive-Programming.elm

Notice the values below the time slider. You can see the mouse position and the
exact location of each stamp. Showing these values gives us the same kind of
interactive feedback as the UI itself, but much more precisely. We do this with:

```haskell
Debug.watch : String -> a -> a
```

This function lets you give a value a unique name so it can be watched over
time. This means we can look at the exact value of *anything*, even if it never
appears in the UI. From here it is easy to imagine integrating this into an IDE
so that you do not actually need to change the source code to watch a particular
value.

Now that we know the basic tools of the debugger, we turn to a slightly more
complicated animation of Mario with a simple bug. Something is wrong in our
code such that Mario can double jump! In this case we actually modify the
`jump` and `gravity` functions to see how that changes the program.

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

At about 30 seconds in, we begin tracing Mario&rsquo;s path through time. This
trace is crucial to visualizing the meaning of our program. To explore the
double jump bug, we need to see how changing our code changes Mario&rsquo;s
path. Laszlo introduced this ability with the following function:

```haskell
Debug.trace : String -> Element -> Element
```

A visual element is tagged with a string that serves as a unique ID throughout
the program, allowing the debugger to track Mario over time. It is easy to
imagine toggling tracing on and off for specific elements or to have an IDE
that is able to add tracing tags without actually modifying the source code
explicitly.

Most typical online applications are not interactive games though. Fortunately
this debugger is handy for debugging issues with text fields, buttons, hovering,
and any other event-driven element you can think of. This third example is a
buggy text entry box that is *intended* to only accept numeric input. As you
will see in the watched values, it is able to filter the initial letters but
breaks down after that:

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

<iframe width="640"
        height="200"
        src="//www.youtube.com/embed/zybahE0aQqA?rel=0&showinfo=0"
        frameborder="0"
        allowfullscreen></iframe>

|]

mario w = width w [markdown|

<iframe width="640"
        height="200"
        src="//www.youtube.com/embed/RUeLd7T7Xi4?rel=0&showinfo=0"
        frameborder="0"
        allowfullscreen></iframe>

|]

reverser w = width w [markdown|

<iframe width="640"
        height="200"
        src="//www.youtube.com/embed/Z9IRkGwlLlM?rel=0&showinfo=0"
        frameborder="0"
        allowfullscreen></iframe>

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

## How Elm makes this possible

As stated in the intro, **language design is vital to making this debugger
practical.** This section dives into how purity and FRP are key to making time
travel relatively easy to implement.

### Purity

A [pure function](http://en.wikipedia.org/wiki/Pure_function) is a function
that always returns the same results given the same input. It also has no
observable side-effects, so you can run it many times without changing the
world.

Purity is a bit more subtle when the term is applied to a language.
It does not mean that there are no side-effects at all, only that
side-effects are modelled explicitly. To perform a side-effect, you first
create a data structure that represents what you want to do. You then give that
data structure to the language&rsquo;s runtime system to actually perform the
side-effect. (A [runtime system][runtime] does the dirty work of the language,
like garbage collection and scheduling.)

  [runtime]: http://en.wikipedia.org/wiki/Run-time_system

Now why is this important for the debugger? If the programmer could make HTTP
requests or open files at any time, playback would be much more complicated.
Suddenly there is code that cannot be rerun because it changes the world.
Imagine opening a file and rewinding back and forth through the code that writes
to it. The act of debugging would trash your file. So impurity can easily
*introduce* new bugs into your program as you debug!

Because Elm represents side-effects explicitly as values, the debugger just
needs to tell the runtime not to perform any side-effects during replay to
avoid these issues.

### Immutability

[Immutable data](http://en.wikipedia.org/wiki/Immutable_object) is data that
cannot be mutated after it is created. If Elm programs allowed arbitrary mutation
of values, we would have the same problem as arbitrarily writing to a file. We
would trash our values by rewinding back and forth through the program,
introducing bugs that would never appear outside of the debugger.

Mutating a value is a side-effect, so purity actually encompasses the concept
of immutability. I single immutability out with its own section mostly to make
the point that immutability alone is not enough. A program that can arbitrarily
write to disk or make HTTP requests is still very difficult to rerun safely and
reliably.

### Functional Reactive Programming

Purity makes it *safe* to pause and rewind programs, but it does not actually
tell us *how* to do it. We need to somehow model incoming and outgoing events to
track how our program interacts with the world over time. [Functional Reactive
Programming][frp] (FRP) exists to do exactly that. Elm&rsquo;s [signals][]
are an API for managing events as they enter and exit an Elm program. To perform
side-effects you send data structures out of the program to the runtime. To
observe the results of a side-effect, they are passed back in from the runtime.
This makes managing replay a matter of recording the incoming
events to the program and discarding the outgoing events. As long as no one
acts on the outgoing events, there will not be unwanted side-effects.

 [frp]: http://elm-lang.org/learn/What-is-FRP.elm
 [signals]: http://library.elm-lang.org/catalog/evancz-Elm/0.12/Signal

So at the root of the debugger is the design of Elm itself. If you do not start
with the right design choices at the language level, creating a time-travelling
debugger quickly becomes extremely complex. Even languages that partially fulfill
the necessary design requirements will have serious challenges.

## What&rsquo;s next?

Like Elm itself, this debugger is intended to be a practical tool. Recent
releases of Elm have all been focused on improving practical matters, like
[JS interop](http://elm-lang.org/blog/announce/0.11.elm) and
[web forms](http://elm-lang.org/blog/announce/0.12.elm). The debugger
starts to fill in the tooling story for Elm.

That said, I think there is a lot more we can do with the debugger. As with
everything in [the elm-lang organization](https://github.com/elm-lang), the
debugger is [open source](https://github.com/elm-lang/debug.elm-lang.org) under BSD3
and contributors are more than welcome! Some ideas for improvements are:

  * **Modularize** &mdash; We would like to release the debugger as a component
    that can integrate with existing IDEs.

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

  * **Graph watched values** &mdash; Seeing Mario&rsquo;s vertical velocity
    plotted over time could be really helpful. Perhaps the debugger could have
    an option to plot any watched number as a function of time.

  * **Visualize the signal graph** &mdash; In Laszlo's original version of the
    debugger, all signal graphs were visualized (FRP in pictures). These graphs
    can be complicated and hard to navigate as the signal graphs grows. Perhaps
    this will ultimately be a better approach than `Debug.watch` though, so we
    should try to overcome these challenges.

There are tons of interesting things to do with a time-travelling debugger, so
I am very excited to see how far we can take these ideas!

## Thanks

Huge thanks to [Laszlo](https://github.com/laszlopandy/) for conceiving and
implementing the debugger. I am still shocked you were able to do all this.
More generally, thank you to [Prezi](https://prezi.com) and the Elm community
for supporting Elm in so many ways!

## Additional Resources

[Laszlo&rsquo;s talk][talk] from [Elm Workshop 2013][workshop] is what started
this project. Laszlo is a really good presenter and covers many things more
gracefully than this post. He also took a much more ambitious approach to
visualizing a running program. This post used `Debug.watch` where Laszlo instead
visualized the entire signal graph, fully exposing the details of FRP.

 [talk]: https://www.youtube.com/watch?v=lK0vph1zR8s&list=PLrJ2mLJTxzXcBvJr5iZKetpeqHOJYJ8AW
 [workshop]: https://www.youtube.com/channel/UCzbnVYNyCwES9u3dqYZ-0WQ

<iframe width="640"
        height="360"
        src="//www.youtube.com/embed/lK0vph1zR8s"
        frameborder="0"
        allowfullscreen></iframe>

The talk itself is about 20 minutes, but we included the 20 minutes of Q&A
because we felt it was really helpful in clarifying the limitations and future
of the debugger.

|]

