#!/usr/bin/env python3

# Improving
"""
function send-to-printer-one-sided ()
{
    printer=$(lpstat -a | sed -r 's/([^ ]+).*/\1/')
    for d in $*; do
    [[ -f $d ]] && /usr/bin/lpr -P $printer -o media=A4 -o sides=one-sided -o PaperSource=AutomaticallySelect $d 
    done
}
"""

import cups
import os
import sys
import argparse

parser = argparse.ArgumentParser(description='Print stuff with cups')
parser.add_argument('--printer', '-p',
                    help='Use this printer try running: lpstat -a')
parser.add_argument('--options', '-o',
                    help='Options for this printer try running: \
                    lpoptions -p PRINTER -l')
args, bastards = parser.parse_known_args()

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


lpoptions = {
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
}

for bastard in bastards:
    # print(bastard)
    if os.path.isfile(bastard):
        res = con.printFile(printer, bastard,
                            'Print %s@%s' % (bastard, printer),
                            lpoptions
                            )
        print('JobId: %i' % res)
    else:
        print('File doesn\'t exist: %s' % bastard)

sys.exit(0)
