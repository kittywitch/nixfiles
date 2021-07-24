#!/usr/bin/env python3
# SPDX-License-Identifier: BSD-3-Clause

flags = {
	'trans': [
		('091', '206', '250'),
		('254', '169', '184'),
		('255', '255', '255'),
		('254', '169', '184'),
		('091', '206', '250'),
	],
	'lesbian': [
		('213', '045', '000'),
		('255', '154', '086'),
		('255', '255', '255'),
		('211', '098', '164'),
		('163', '002', '098'),
	],
	'bi': [
		('214', '002', '112'),
		('214', '002', '112'),
		('155', '079', '150'),
		('000', '056', '168'),
		('000', '056', '168'),
	],
	'enby': [
		('252', '244', '052'),
		('252', '252', '252'),
		('156', '089', '209'),
		('044', '044', '044'),
	],
	'rainbow': [
		('228', '003', '003'),
		('255', '140', '000'),
		('255', '237', '000'),
		('000', '128', '038'),
		('000', '077', '255'),
		('117', '007', '135'),
	],
	'ace': [
		('044', '044', '044'),
		('163', '163', '163'),
		('255', '255', '255'),
		('128', '000', '128'),
	],
	'pan': [
		('255', '033', '140'),
		('255', '033', '140'),
		('255', '216', '000'),
		('255', '216', '000'),
		('033', '177', '255'),
		('033', '177', '255'),
	]
}




def print_flag(flag, width = 18):
	bar = '█' * width
	flag_data = flags[flag]
	flg_str = ''

	for c in flag_data:
		flg_str += f'\x1b[38;2;{c[0]};{c[1]};{c[2]}m\x1b[48;2;{c[0]};{c[1]};{c[2]}m{bar}\x1b[0m\n'

	print(flg_str, end = '')



if __name__ == '__main__':
	import sys
	from os       import get_terminal_size
	from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter

	parser = ArgumentParser(
		formatter_class = ArgumentDefaultsHelpFormatter,
		description     = '24-bit color terminal pride flags'
	)

	display = parser.add_argument_group('Display Options')

	display.add_argument(
		'--banner', '-b',
		default = False,
		action  = 'store_true',
		help    = 'Print the flag the whole width of the terminal'
	)

	display.add_argument(
		'--width', '-w',
		default = 18,
		type    = int,
		help    = 'Width of the flag'
	)

	display.add_argument(
		'--insert-break', '-B',
		default = False,
		action  = 'store_true',
		help    = 'Insert a line break between flags'
	)

	parser.add_argument(
		'--random', '-r',
		default = False,
		action  = 'store_true',
		help    = 'Show a random pride flag'
	)

	parser.add_argument(
		'--flags', '-f',
		default = [],
		choices = list(flags.keys()),
		nargs   = '+',
		help    = 'The flags which to display'
	)

	args = parser.parse_args()

	width = args.width

	if args.banner:
		width = get_terminal_size().columns

	if not args.random:
		if len(args.flags) == 0:
			print('you must specify at least one flag or --random')
			sys.exit(1)

		for flag in args.flags:
			print_flag(flag, width = width)
			if args.insert_break:
				print('')
	else:
		import random
		print_flag(random.choice(list(flags.keys())), width = width)

	sys.exit(0)
