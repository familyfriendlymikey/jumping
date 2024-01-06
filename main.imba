import 'colors'
import fs from 'fs'
import path from 'path'
import { program } from 'commander'
import { version } from './package.json'

let log = console.log
let quit = do(msg='quit') console.error(msg.red); process.exit(1)

const cwd = process.cwd!
const home = require('os').homedir!
const db-path = path.join(home,'jumping.json')

program
	.description("See README: https://github.com/familyfriendlymikey/jumping")
	.version(version)
	.option('-s, --set <alias>', 'Set the current directory to the provided alias')
	.option('-p, --path <path>', 'Specify which path to set instead of current path')
	.option('-g, --get <alias>', 'Print the full path to the directory associated with the alias')
	.option('--delete <alias>', 'Delete an alias')
	.option('-f, --force', 'Overwrite an existing alias')
	.option('-l, --list', 'List all aliases')
	.option('-c, --current', 'Show alias for current path')
	.showHelpAfterError!

def write-db db
	fs.writeFileSync db-path, JSON.stringify(db,null,2)

def main

	let args = program.parse!.opts!

	unless fs.existsSync db-path
		try
			log "`~/jumping.json` not found, creating...".green
			write-db {}
			log "OK".green
		catch e
			quit "Failed to create `~/jumping.json` file:", e

	let db

	try
		db = fs.readFileSync db-path
	catch e
		quit "Failed to read `~/jumping.json` file:", e

	try
		db = JSON.parse db
	catch e
		quit "Failed to parse contents of `~/jumping.json` file:", e

	if args.current
		for own k,v of db
			if v == cwd
				log k
				return
		quit "Current directory does not have an alias"

	elif args.get
		let alias = args.get
		let dir = db[alias]
		unless dir
			quit "Association not found for alias '{alias}'"
		unless fs.existsSync dir
			quit "Directory associated with alias '{alias}' not found: {dir}"
		log dir

	elif args.set
		let alias = args.set
		if db[alias] and not args.force
			quit "Association already exists for alias '{alias}', use -f to overwrite"
		db[alias] = args.path or cwd
		try
			write-db db
		catch e
			quit "Failed to write new association to `~/jumping.json` file:", e
		log "{alias.cyan} {db[alias]}"

	elif args.delete
		delete db[args.delete]
		write-db db
		return

	elif args.list
		for own alias, dir of db
			log "{alias.cyan} {dir}"

	else
		program.help!

main!
