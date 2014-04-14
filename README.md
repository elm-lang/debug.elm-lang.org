# Elm Debugger

The debugger was conceived and implemented by [Laszlo
Pandy](https://github.com/laszlopandy/). He introduced it during [his
talk](https://www.youtube.com/watch?v=lK0vph1zR8s&list=PLrJ2mLJTxzXcBvJr5iZKetpeqHOJYJ8AW)
at [Elm Workshop 2013](https://www.youtube.com/channel/UCzbnVYNyCwES9u3dqYZ-0WQ/videos).
Since then it has been adopted by [the @elm-lang organization](https://github.com/elm-lang)
to try to get it in shape for everyday use.

### Build from source

The server is written in Haskell, so first get the [Haskell
Platform](http://www.haskell.org/platform/). The debugger currently relies on
[the debugger branch](https://github.com/elm-lang/Elm/tree/debugger) of the
compiler, so you will need to build that first:

```bash
git clone https://github.com/elm-lang/Elm.git
cd Elm
git checkout debugger
cabal install
```

This will install that version of the compiler globally. If you want to switch
back to the most recent release, run `git checkout 0.12 ; cabal install`. Now
that you have the debugger branch, actually build this project:

```bash
git clone https://github.com/elm-lang/elm-debugger.git
cd elm-debugger
cabal configure
cabal build
./dist/build/elm-debugger/elm-debugger
```

This build the server and then start running it locally.

### Contributing

This is a very young project, so if you are excited about improving the
debugger, it is a great time to contribute! Lots of [big questions and important
features](http://debug.elm-lang.org/#what-is-next) are still wide open.

Get familiar with the code base and start experimenting. It is likely that
the debugger will need to coordinate with the compiler to make it truly great,
so talk with people on [the list](https://groups.google.com/forum/#!forum/elm-discuss)
or on [IRC](http://webchat.freenode.net/?channels=elm) to figure out what needs
to happen next.
