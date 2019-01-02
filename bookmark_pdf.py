#!/usr/bin/env python3


import subprocess
import sys
import os
import tempfile

# InfoBegin
# InfoKey: ModDate
# InfoValue: D:20181203181048+01'00'
# InfoBegin
# InfoKey: CreationDate
# InfoValue: D:20181203181048+01'00'
# InfoBegin
# InfoKey: Creator
# InfoValue: pdftk 2.02 - www.pdftk.com
# InfoBegin
# InfoKey: Producer
# InfoValue: itext-paulo-155 (itextpdf.sf.net-lowagie.com)
# PdfID0: 3efb3c6136ec31b9f35d41f0a2b9cd41
# PdfID1: 81eba260efd11e4e4a672bbbaf1571ed
# NumberOfPages: 9
# BookmarkBegin
# BookmarkTitle: Motivationsschreiben
# BookmarkLevel: 1
# BookmarkPageNumber: 1

# print(sys.argv[1:-1])
args_concat = ' '.join(sys.argv[1:-2])
to_write = [x for x in args_concat.split(',')]

fd, path = tempfile.mkstemp()
# print(fd)
# print(path)

try:
    with os.fdopen(fd, 'w') as tmp:
        for x in to_write:
            y = x.split(':')
            # print(y)
            if y[0] in ['ModDate', 'CreationDate', 'Creator', 'Producer',
                        'Title', 'Author']:
                tmp.write('InfoBegin\nInfoKey: %s\nInfoValue: %s\n' %
                          (y[0], ':'.join(y[1:])))

            elif y[0] in ['NumberOfPages']:
                tmp.write('NumberOfPages: %s\n' % y[1])

            else:
                tmp.write('BookmarkBegin\nBookmarkTitle: %s\nBookmarkLevel: 1'
                          '\nBookmarkPageNumber: %s\n' %
                          (y[0], y[1]))


    args = ['pdftk', sys.argv[-2], 'update_info', path, 'output', sys.argv[-1]]
    # print(args)
    res = subprocess.Popen(args)
finally:
    pass
    # os.remove(path)
