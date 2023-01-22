# Jumping

Assign custom aliases to directories and quickly jump to them
from anywhere.

## Installation

```sh
npm i -g jumping
```

Put the following in your `~/.bashrc` or `~/.zshrc` file:

```sh
j(){
	local dir
	dir="$(ji --get "$1")"
	[[ -d "$dir" ]] && cd "$dir"
}

alias d='ji --set'
```

You can choose names other than `j` and `d`, but this document
will assume you're using the same names.

## Usage

```sh
d <alias> # defines an alias at the current working directory
j <alias> # jumps to the directory associated with an alias
ji # lists all aliases
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

## Extras

I prefer to use this mapping instead of the one above:

```sh
j(){
	if [ $# -eq 0 ]; then
		c
		local item=$(\fd -I | fzy -l max)
		if [[ -f "$item" ]]; then cd "$(dirname "$item")"
		elif [[ -d "$item" ]]; then cd "$item"
		fi
	else
		local dir
		dir="$(ji --get "$1")"
		[[ -d "$dir" ]] && cd "$dir"
	fi
}
alias d='ji --set'
```

## FAQ

#### Why do I have to edit my `~/.bashrc` or `~/.zshrc`?

Programs cannot change the directory of the underlying shell. I'd
love to be wrong about that, but as far as I know if you want
this functionality you *have* to use a bash/zsh function in your
`rc` file. So we just use `jumping` to set and get our aliases,
while our bash function does the actual directory changing.
