# vim plugin for seeker

seeker is a cli tool for jumping to the definition of a symbol in an elm project.

additionally, you can jump to the definitions of symbols defined in a project's dependencies
for the purposes of looking up documentation and how that code works.

based heavily on https://github.com/racer-rust/vim-racer

## Installation

You need [seeker](https://github.com/cpdean/seeker) installed on your path.  I currently clone the repo locally and `pip install -e .` it.

## Troubleshooting `seeker` bugs

vim-seeker should display error message from the `seeker` cli tool:
![an error message](gh_seeker_docs/error.png)

Enable debug mode to display more useful information for figuring out what's wrong with `seeker`:

    :call SeekerToggleDebugMode()

And when you call it again you'll get much more information:
![debug logging turned in for seeker](gh_seeker_docs/debug_mode.png)

In the above example, I have a file that looks like:
```
module RandomGifList (..) where

import Effects exposing (Effects, map, batch, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import RandomGif
-- ...
```

So the fact that `seeker` only thinks it needs to search the `Html` module is a bit of a red flag -- there are two other modules which do wildcard imports.
