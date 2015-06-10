#!/usr/bin/env python
"""
Import a Firefox bookmarks file into a single json list
"""

import json
import pprint


def walk(struct, depth=0):
    children = struct.get('children')
    if children:
        for child in children:
            if child.get('type') == 'text/x-moz-place':
                title = child.get('title')
                uri = child.get('uri')
                tags = child.get('tags')
                if tags:
                    tag_l = [tag for tag in tags.split(',')]
                else:
                    tag_l = []

                my_marks.append({'title': title,
                                 'uri': uri,
                                 'tags': tag_l
                                 })

            walk(child)


with open("bmarks") as f:
    my_marks = []
    j = json.load(f)
    walk(j)
    pprint.pprint(my_marks)
