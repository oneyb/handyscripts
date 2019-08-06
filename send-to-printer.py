#!/usr/bin/env python3

# Improving
"""
function send-to-printer-one-sided ()
{
    printer=$(lpstat -a | sed -r 's/([^ ]+).*/\1/')
    for d in $*; do
    [[ -f $d ]] && /usr/bin/lpr -P $printer -o media=A4 -o \
                       sides=one-sided -o PaperSource=AutomaticallySelect $d
    done
}
"""

import cups
from os.path import isfile
import sys
import argparse


def parse_lpoptions(options, split_char='='):
    return options.split(split_char, 1)


def format_lpoptions(options):
    if options is None:
        return {}
    else:
        res = {x[0]: x[1] for x in options}
        return res


parser = argparse.ArgumentParser(description='Print stuff with cups')
parser.add_argument('--printer', '-p',
                    help='Use this printer, try running: lpstat -a')
# Thanks to Peter Otten:
# https://mail.python.org/pipermail/python-list/2018-June/734722.html
parser.add_argument('--options', '-o', action='append', type=parse_lpoptions,
                    help='Options for this printer, try running: \
                    lpoptions -p PRINTER -l')

args, bastards = parser.parse_known_args()
# args = parser.parse_args(['-o', 'sides=one-sided', '-o', 'test=crap'])


con = cups.Connection()

if args.printer is None:
    print('Looking for printer')
    printers = con.getPrinters()
    if printers is None:
        print('CUPS found no printer.')
        sys.exit(1)
    else:
        if len(printers) == 1:
            printer = list(printers.keys())[0]
        else:
            print("Too many printers, choose from:")
            print('\t' + '\n\t'.join(p for p in printers.keys()))
            print("Like this:")
            print('\n'.join(sys.argv[0] + ' -p ' + p for p in printers.keys()))
            sys.exit(1)

else:
    printer = args.printer

# see: https://wiki.debian.org/DissectingandDebuggingtheCUPSPrintingSystem
lpoptions = format_lpoptions(args.options)

# print(args)
# print(bastards)
# print(lpoptions)
# sys.exit(0)

for bastard in bastards:
    # print(bastard)
    if isfile(bastard):
        res = con.printFile(printer, bastard,
                            'Print %s@%s' % (bastard, printer),
                            lpoptions
                            )
        print('JobId: %i' % res)
    else:
        print('File doesn\'t exist: %s' % bastard)

sys.exit(0)

# implement filter for odd-sized pdf
# ** TODO algorithm for printer script:
#    - get lpoptions
#    - get document characteristics
#    - check to see if printer configured to print this
#    - modify document accordingly
#    - PRINT!

