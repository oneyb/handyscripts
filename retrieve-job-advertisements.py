#!/usr/bin/env python3

import sys
from os.path import isfile, isdir, join, expanduser, basename, dirname
from os import mkdir
import time
import re
from itertools import chain
# from shutil import copyfile
import pdb




def get_base_website(url):
    '''Recursive function for base url'''
    cand = dirname(url)
    bad_candidates = {'https:', 'http:', 'ftp:'}
    if cand in bad_candidates:
        return url
    else:
        return get_base_website(cand)


import pdfkit
from jinja2 import Environment, FileSystemLoader, select_autoescape
import jinja2 


# filename = join(expanduser('~'), 'org/personal-development.org')
filename = join(expanduser('~'), 'org/job-search.org')
jobdir = join(expanduser('~'), 'documents/jobsearch/')
template_dir = join(jobdir, '0-application_materials')

materials_templates = [
         'cover_letter_oney.org',
         'bewerbungsschreiben_oney.org',
         'oney_cv_de.org',
         'oney_cv_en.org',
]

env = Environment(
    loader=FileSystemLoader(template_dir, encoding='utf-8', followlinks=True),
    autoescape=select_autoescape(enabled_extensions=['org']),
    auto_reload=True,
    # autoescape=select_autoescape(enabled_extensions=('org',))
    # make sure the org file contents containing macros are surrounded by
    # {% raw %} and {% endraw %} tags
)

with open(filename, 'r') as f:
    content = f.readlines()


patterns_all = [
    '(?:TODO|NEXT|WAIT) +apply to +(.+) +(http[^ ]+)',
    '(?:TODO|NEXT|WAIT) bewerb\w+ +\w+ +(.+) +(http[^ ]+)'
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
    job_title = title.split(',')
    fname = re.sub(pattern_safe, '-', title)
    dname = join(jobdir, '1-' + fname.lower())
    if not isdir(dname):
        mkdir(dname)
    ffname = join(dname, fname.lower() + '.pdf')
    if not isfile(ffname):
        print('Saving %s to %s' % (url, ffname))
        pdf = pdfkit.from_url(url, ffname)
    else:
        print('This exists already: %s' % ffname)

    for template in materials_templates:
        destfile = join(dname, basename(template))
        if not isfile(destfile):
            template = env.get_template(template)
            rendered = template.render(title=job_title[0],
                                       institute=job_title[1:],
                                       url=get_base_website(url),
                                       date=date)
            with open(destfile, 'w') as f:
                f.write(rendered)
            # pdb.set_trace()
            # copyfile(template, destfile)
