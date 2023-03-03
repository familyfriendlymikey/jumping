global.L = console.log
global.E = do console.error(...$0); process.exit(1)

import 'colors'
import fs from 'fs'
import path from 'path'
import { program } from 'commander'
import { version } from './package.json'

const cwd = process.cwd!
const home = require('os').homedir!
const db-path = path.join(home, 'jumping.json')

program
	.description("See README: https://github.com/familyfriendlymikey/jumping")
	.version(version)
	.option('-s, --set <alias>', 'Set the current directory to the provided alias')
	.option('-g, --get <alias>', 'Print the full path to the directory associated with the alias')
	.option('--delete <alias>', 'Delete an alias')
	.option('-f, --force', 'Overwrite an existing alias')
	.option('-l, --list', 'List all aliases.')
	.showHelpAfterError!

def write-db db
	fs.writeFileSync db-path, JSON.stringify(db,null,2)

def main

	let args = program.parse!.opts!

	unless fs.existsSync db-path
		try
			L "`~/jumping.json` not found, creating...".green
			write-db {}
			L "OK".green
		catch e
			E "Failed to create `~/jumping.json` file:", e

	let db

	try
		db = fs.readFileSync db-path
	catch e
		E "Failed to read `~/jumping.json` file:", e

	try
		db = JSON.parse db
	catch e
		E "Failed to parse contents of `~/jumping.json` file:", e

	if args.get
		let alias = args.get
		let dir = db[alias]
		unless dir
			E "Association not found for alias '{alias}'"
		unless fs.existsSync dir
			E "Directory associated with alias '{alias}' not found: {dir}"
		L dir

	elif args.set
		let alias = args.set
		if db[alias] and not args.force
			E "Association already exists for alias '{alias}', use -f to overwrite"
		db[alias] = cwd
		try
			write-db db
		catch e
			E "Failed to write new association to `~/jumping.json` file:", e
		L "{alias.cyan} {db[alias]}"

	elif args.delete
		delete db[args.delete]
		write-db db
		return

	elif args.list
		for own alias, dir of db
			L "{alias.cyan} {dir}"

	else
		program.help!

main!
