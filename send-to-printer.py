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

parser = argparse.ArgumentParser(description='Print stuff with cups')
parser.add_argument('--printer', '-p',
                    help='Use this printer, try running: lpstat -a')
parser.add_argument('--options', '-o', 
                    help='Options for this printer, try running: \
                    lpoptions -p PRINTER -l')
# parser.parse_known_args(['-o', 'sides=one-sided', '-o', 'test=crap'])
args, bastards = parser.parse_known_args()

# print(dict(args.options))


def format_options(options):
    if type(options) is str:
        options = [options]
    res = {}
    for o in options:
        split = o.split('=')
        res.update({split[0]: split[1]})
    return res


# print(format_options([args.options, 'ers=res']))

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


lpoptions = format_options(args.options)
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
