const p = console.log
const cwd = process.cwd!

require 'colors'
const fs = require 'fs'
const path = require 'path'
const home = require('os').homedir!
const { program } = require 'commander'

program
	.option('-s, --set <alias>', 'Sets the current directory to the provided alias')
	.option('-g, --get <alias>', 'Prints the full path to the directory associated with the alias')
	.option('-f, --force', 'Overwrite an existing association')
	.option('-l, --list', 'Lists all directory-alias associations')

def quit msg='Quit'
	p msg.red
	process.exit!

def printAss alias, dir
	p "\n{alias.cyan} {dir}"

def main

	let args = program.parse!.opts!

	let dbPath = path.join(home, 'jumping.json')

	unless fs.existsSync dbPath
		try
			p "`~/jumping.json` not found, creating...".green
			fs.writeFileSync dbPath, '{}'
			p "OK".green
		catch e
			quit "Failed to create `~/jumping.json` file:\n\n{e}"

	let db
	try
		db = fs.readFileSync(dbPath)
	catch e
		quit "Failed to read `~/jumping.json` file:\n\n{e}"

	try
		db = JSON.parse db
	catch e
		quit "Failed to parse contents of `~/jumping.json` file:\n\n{e}"

	if args.list
		for own alias, dir of db
			printAss alias, dir
		p!
		return

	if args.get
		let alias = args.get
		let dir = db[alias]
		if dir
			p dir
		else
			quit "Association not found for alias '{alias}'."
		return

	if args.set
		let alias = args.set
		if db[alias] and not args.force
			quit "Association already exists for alias '{alias}'. Use -f to overwrite."
		db[alias] = cwd
		try
			fs.writeFileSync dbPath, JSON.stringify(db)
		catch e
			quit "Failed to write new association to `~/jumping.json` file:\n\n{e}"
		printAss alias, db[alias]
		p!
		return

main!
