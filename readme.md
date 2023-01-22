# Jumping

Assign custom aliases to directories and quickly jump to them
from anywhere.

## Installation

```sh
npm i -g jumping
```

Requires bun:

```sh
curl -fsSL https://bun.sh/install | bash
```

Put the following in your `~/.bashrc` or `~/.zshrc` file:

```sh
j(){
	local dir
	dir="$(jumping --get "$1")"
	[[ -d "$dir" ]] && cd "$dir"
}

d(){
	jumping --set "$@"
}
```

You can choose names other than `j` and `d`, but this document
will assume you're using the same names.

## Usage

```sh
d <alias> # defines an alias at the current working directory
j <alias> # jumps to the directory associated with an alias
jumping # lists all aliases
```

## Guide

When you're in a directory and you realize you might want to
access it later, just run `d <alias>`. For example, if I'm in
`~/Desktop/repositories/fuzzyhome`, I might make an alias `rf`:

```sh
d rf
```

Later, when I want to change to the
`~/Desktop/repositories/fuzzyhome` directory, I can jump to it from
anywhere with:

```sh
j rf
```

## Extras

I prefer `j` with no arguments to fuzzy find files recursively.

To do this, install:

```sh
brew install fd fzy
```

And add the following to your `~/.zshrc`:

```sh
j(){
	if [ $# -eq 0 ]; then
		c
		local item=$(\fd | fzy -l max)
		if [[ -f "$item" ]]; then cd "$(dirname "$item")"
		elif [[ -d "$item" ]]; then cd "$item"
		fi
	else
		local dir
		dir="$(jumping --get "$1")"
		[[ -d "$dir" ]] && cd "$dir"
	fi
}

d(){
	jumping --set "$@"
}
```

## FAQ

#### Why do I have to edit my `~/.bashrc` or `~/.zshrc`?

Programs cannot change the directory of the underlying shell. So we
just use `jumping` to set and get our aliases, while our shell
function does the actual directory changing.
