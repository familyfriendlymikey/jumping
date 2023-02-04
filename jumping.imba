global.L = console.log

require 'colors'
const fs = require 'fs'
const path = require 'path'
const { program } = require 'commander'
const { version } = require './package.json'

const cwd = process.cwd!
const home = require('os').homedir!
const db-path = path.join(home, 'jumping.json')

program
	.description("v{version}\n\nSee README: https://github.com/familyfriendlymikey/jumping")
	.version(version)
	.option('-s, --set <alias>', 'Set the current directory to the provided alias')
	.option('-g, --get <alias>', 'Print the full path to the directory associated with the alias')
	.option('--delete <alias>', 'Delete an alias')
	.option('-f, --force', 'Overwrite an existing alias')
	.option('-l, --list', 'List all aliases.')

def quit msg='Quit', e
	if e
		console.error "{msg}:\n\n{e}".red
	else
		console.error msg.red
	process.exit(1)

def print-ass alias, dir
	L "{alias.cyan} {dir}"

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
			quit "Failed to create `~/jumping.json` file", e

	let db
	try
		db = fs.readFileSync db-path
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
		L dir
		return

	if args.set
		let alias = args.set
		if db[alias] and not args.force
			quit "Association already exists for alias '{alias}', use -f to overwrite"
		db[alias] = cwd
		try
			write-db db
		catch e
			quit "Failed to write new association to `~/jumping.json` file", e
		print-ass alias, db[alias]
		return

	if args.delete
		delete db[args.delete]
		write-db db
		return

	if args.list
		for own alias, dir of db
			print-ass alias, dir
		return

	program.help!

main!
