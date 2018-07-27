#!/usr/bin/env python3

import sys
from os.path import isfile, isdir, join, expanduser, basename
from os import mkdir
import time
import re
from itertools import chain
# from shutil import copyfile
import pdb

import pdfkit
from jinja2 import Environment, FileSystemLoader, select_autoescape
import jinja2 


filename = join(expanduser('~'), 'org/personal-development.org')
jobdir = join(expanduser('~'), 'documents/jobsearch/')
template_dir = join(jobdir, '0-application_materials')

materials_templates = [
         'cover_letter_oney.org',
         'bewerbungsschreiben_oney.org',
]

env = Environment(
    loader=FileSystemLoader(template_dir, encoding='utf-8', followlinks=True),
    autoescape=select_autoescape(enabled_extensions=['org']),
    auto_reload=True,
    # autoescape=select_autoescape(enabled_extensions=('org',))
)

with open(filename, 'r') as f:
    content = f.readlines()


patterns_all = [
    '(?:TODO|NEXT|WAIT) +apply to (.+) (http[^ ]+)',
    '(?:TODO|NEXT|WAIT) bewerb\w+ \w+ (.+) (http[^ ]+)'
]

urls = []
for patterns in patterns_all:
    pattern = re.compile(patterns)
    url = [re.findall(pattern, x) for x in content]
    url = [x for x in url if x]
    urls.extend(chain(*url))

# for url in urls:
#     print(url)
# print(urls)
# sys.exit(0)


# not a word character
pattern_safe = re.compile('\W')

date = time.strftime("%d.%m.%Y")

for title, url in urls:
    fname = re.sub(pattern_safe, '-', title)
    dirname = join(jobdir, '1-' + fname)
    if not isdir(dirname):
        mkdir(dirname)
    ffname = join(dirname, fname + '.pdf')
    if not isfile(ffname):
        print('Saving %s to %s' % (url, ffname))
        pdf = pdfkit.from_url(url, ffname)
    else:
        print('This exists already: %s' % ffname)

    for template in materials_templates:
        destfile = join(dirname, basename(template))
        if not isfile(destfile):
            template = env.get_template(template)
            rendered = template.render(title=title, date=date)
            with open(destfile, 'w') as f:
                 f.write(rendered)
            # pdb.set_trace()
            # copyfile(template, destfile)
