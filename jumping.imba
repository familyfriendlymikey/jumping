const p = console.log
const cwd = process.cwd!

require 'colors'
const fs = require 'fs'
const path = require 'path'
const { program } = require 'commander'

const home = require('os').homedir!
const dbPath = path.join(home, 'jumping.json')

program
	.description('See README: https://github.com/familyfriendlymikey/jumping')
	.option('-s, --set <alias>', 'Set the current directory to the provided alias')
	.option('-g, --get <alias>', 'Print the full path to the directory associated with the alias')
	.option('--delete <alias>', 'Delete an alias')
	.option('-f, --force', 'Overwrite an existing alias')

def quit msg='Quit', e
	if e
		console.error "{msg}:\n\n{e}".red
	else
		console.error msg.red
	process.exit!

def printAss alias, dir
	p "{alias.cyan} {dir}"

def writeDb db
	fs.writeFileSync dbPath, JSON.stringify(db,null,2)

def main

	let args = program.parse!.opts!

	unless fs.existsSync dbPath
		try
			p "`~/jumping.json` not found, creating...".green
			writeDb {}
			p "OK".green
		catch e
			quit "Failed to create `~/jumping.json` file", e

	let db
	try
		db = fs.readFileSync dbPath
	catch e
		quit "Failed to read `~/jumping.json` file", e

	try
		db = JSON.parse db
	catch e
		quit "Failed to parse contents of `~/jumping.json` file", e

	if args.get
		let alias = args.get
		let dir = db[alias]
		unless dir
			quit "Association not found for alias '{alias}'"
		unless fs.existsSync dir
			quit "Directory associated with alias '{alias}' not found: {dir}"
		p dir
		return

	if args.set
		let alias = args.set
		if db[alias] and not args.force
			quit "Association already exists for alias '{alias}', use -f to overwrite"
		db[alias] = cwd
		try
			writeDb db
		catch e
			quit "Failed to write new association to `~/jumping.json` file", e
		printAss alias, db[alias]
		return

	if args.delete
		delete db[args.delete]
		writeDb db
		return

	p "No arguments provided, listing all associations:".blue
	for own alias, dir of db
		printAss alias, dir

main!
