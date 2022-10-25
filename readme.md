# Jumping

Assign custom aliases to directories and quickly jump to them
from anywhere.

## Installation

```sh
npm i jumping
```

Put the following in your `~/.bashrc` or `~/.zshrc` file:

```sh
j(){
  cd "$(jumping --get "$1")"
}

alias d='jumping --set'
```

## Usage

```sh
d <alias> # defines an alias at the current working directory
j <alias> # jumps to the directory associated with an alias
```

## Guide

When you're in a directory and you realize you might want to
access it later, just run `d <alias>`. For example, if I'm in
`~/Desktop/repositories/fuzzyhome`, I might make an alias `rf`:

```sh
d rf
```

Later, when I want to change to the
`~/Desktop/repositories/jumping` directory, I can jump to it from
anywhere with

```sh
j rf
```

## FAQ

#### Why do I have to edit my `~/.bashrc` or `~/.zshrc`?

Programs cannot change the directory of the underlying shell. I'd
love to be wrong about that, but as far as I know if you want
this functionality you *have* to use a bash/zsh function in your
`rc` file. So we just use `jumping` to set and get our aliases,
while our bash function does the actual directory changing.
