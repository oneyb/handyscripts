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


def get_lpoptions(options, split='='):
    splits = options.split('=', 1)
    return {splits[0]: splits[1]}


def format_lpoptions(options):
    res = dict()
    for x in options:
        res.update(x)
    return res


parser = argparse.ArgumentParser(description='Print stuff with cups')
parser.add_argument('--printer', '-p',
                    help='Use this printer, try running: lpstat -a')
# Thanks to Peter Otten: https://mail.python.org/pipermail/python-list/2018-June/734722.html
parser.add_argument('--options', '-o', action='append', type=get_lpoptions,
                    help='Options for this printer, try running: \
                    lpoptions -p PRINTER -l')

args, bastards = parser.parse_known_args()
# args = parser.parse_args(['-o', 'sides=one-sided', '-o', 'test=crap'])
# print(format_options(args.options))


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
            print(' '.join(p for p in printers.keys()))


lpoptions = format_lpoptions(args.options)
# see: https://wiki.debian.org/DissectingandDebuggingtheCUPSPrintingSystem
# 'media': 'A4,Lower'
# 'attributes-natural-language': 'de-ch',
# 'job-sheets': 'none,none'
# ,'media': 'iso_a4_210x297mm'
# ,'media': 'iso,a4,210x297mm'
# 'media': 'A4'
# ,'sides': 'two-sided-long-edge'
# ,'HPOption_Tray3': 'AutomaticallySelect'
# ,PaperSource='AutomaticallySelect'
# ,o='HPPaperSource=AutomaticallySelect'
# ,'Paper Source': 'Tray2'
# ,o='HPPaperSource/Paper Source=AutomaticallySelect'
# ,o='HPPaperSource=Tray2'
# ,HPPaperSource='Tray2'

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
