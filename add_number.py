#!/usr/bin/env python3

#  A handy little program intended to modify numbers in strings
#
#  Copyright (C) 2016  Brian J. Oney, brian.j.oney|at|gmail.com
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys
import os
import re

desc = """
  A handy little program to ...
        Usage: add_number.py regex replacement number string
  Examples:
$ echo "| test | m^{2}  =C$27*C$29 |" | add_number.py 'C\$([0-9]+)' 'C${}' 4
$ add_number.py 'C\$([0-9]+)' 'C${}' 4  "| test | m^{2}  =C$27*C$29 |"
# In vim/spacemacs(evil-mode)
:'<,'>!add_number.py 'C([0-9]+)' 'C{}' 4
"""

def add_number(regex, replacement, number, string):
    cleaned1 = re.sub(r'{', r'__--__', string)
    cleaned2 = re.sub(r'}', r'--__--', cleaned1)
    # print(cleaned)
    s = re.sub(regex, replacement, cleaned2)
    rep = [eval(i + number) for i in re.findall(regex, cleaned2)]
    # rep = [int(i) + intnumber for i in re.findall(regex, cleaned2)]
    unclean = s.format(*rep)
    recleaned1 = re.sub(r'__--__', r'{', unclean)
    recleaned2 = re.sub(r'--__--', r'}', recleaned1)
    return recleaned2

# Simple test
if '-t' in sys.argv or '--test' in sys.argv and __name__ == '__main__':
    string   = "| test | m^{2}  =C27*C29 |"
    expected = '| test | m^{2}  =C31*C33 |'
    test = add_number(r'C([0-9]+)', 'C{}', 4, string)
    if test == expected:
        print('Test passed.')

if '-h' in sys.argv or '--help' in sys.argv or len(sys.argv) == 1 \
   and __name__ == '__main__':
    print(desc)
    sys.exit(0)


def main():
    """
    Do stuff ...
    """
    lines = sys.stdin.readlines()
    if lines is None:
        if os.path.exists(sys.argv[4]):
            with open(sys.argv[4], 'r') as f:
                lines = f.readlines()
        else:
            lines = sys.argv[4:]

    results = [add_number(sys.argv[1], sys.argv[2], sys.argv[3], line)
                   for line in lines]
    # print(results)
    sys.stdout.write(''.join(results))
    return results

if __name__ == '__main__':
    main()
