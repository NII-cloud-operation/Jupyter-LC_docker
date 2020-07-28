# -*- coding: utf-8 -*-

import os
from lxml import etree
from nbformat import read, write, NO_CONVERT

title_font_size = 11
item_font_size = 9
head_margin = 3
text_margin = 2

def parse_headers(filename):
    nb = read(filename, as_version=NO_CONVERT)
    headers = []
    form = False
    for cell in filter(lambda cell: cell['cell_type'] == 'markdown', nb.cells):
        lines = filter(lambda l: len(l) > 0, cell['source'].split('\n'))
        if len(lines) > 0 and lines[0].startswith('#') and not lines[0].startswith('###'):
            if len(lines) > 2 and lines[1].strip() == '----':
                summary = lines[2]
            elif len(lines) > 1:
                summary = lines[1]
            else:
                summary = ''
            if len(headers) == 0 and not lines[0].startswith('##') and lines[0][1:].strip().startswith('About:'):
                form = True
                headers.append((lines[0][1:].strip()[6:], summary))
            elif lines[0].startswith('##'):
                if not form:
                    headers.append(('- ' + lines[0][2:].strip(), summary))
            else:
                if form:
                    headers.append(('- ' + lines[0][1:].strip(), summary))
                else:
                    headers.append((lines[0][1:].strip(), summary))
    return headers

def create_text(rect, font_size, font_weight='normal', font_style='normal'):
    text_elem = etree.Element('{http://www.w3.org/2000/svg}text')
    text_elem.attrib['fill'] = 'rgb(0,0,0)'
    text_elem.attrib['font-family'] = 'sans-serif'
    text_elem.attrib['font-size'] = str(font_size)
    text_elem.attrib['font-style'] = font_style
    text_elem.attrib['font-weight'] = font_weight
    text_elem.attrib['font-anchor'] = 'middle'
    text_elem.attrib['x'] = str(rect[0][0] + text_margin)
    text_elem.attrib['width'] = str(rect[1][0] - text_margin * 2)
    return text_elem

def create_anchor(elems, link):
    a_elem = etree.Element('a')
    a_elem.attrib['{http://www.w3.org/1999/xlink}href'] = link
    for elem in elems:
        a_elem.append(elem)
    return a_elem

def split_title(title):
    if u'：' in title:
        return [title[:title.index(u'：') + 1], title[title.index(u'：') + 1:]]
    elif u'の' in title:
        return [title[:title.index(u'の') + 1], title[title.index(u'の') + 1:]]
    elif ' ' in title and len(title) >= 20:
        words = title.split()
        center = int(len(words) / 2)
        return [' '.join(words[:center]), ' '.join(words[center:])]
    else:
        return [title]

def split_summary(summary):
    summary = summary.strip()
    if ' ' not in summary:
        return [summary]
    else:
        index = summary.rindex(' ')
        return [summary[:index], summary[index:]]

def insert_title(parent_elem, childpos, rect, title, link=None):
    height_title = text_margin + (title_font_size + text_margin) * 2 + head_margin * 2
    lines = split_title(title)
    if len(lines) == 2:
        text_elem = create_text(rect, title_font_size, font_weight='bold')
        text_elem.text = lines[0]
        text_elem.attrib['y'] = str(rect[0][1] + head_margin + text_margin + title_font_size)
        text_elems = [text_elem]

        text_elem = create_text(rect, title_font_size, font_weight='bold')
        text_elem.text = lines[1]
        text_elem.attrib['y'] = str(rect[0][1] + height_title - text_margin - head_margin)
        text_elems.append(text_elem)
    else:
        text_elem = create_text(rect, title_font_size, font_weight='bold')
        text_elem.text = title
        text_elem.attrib['y'] = str(rect[0][1] + height_title / 2 + title_font_size / 2)
        text_elems = [text_elem]
    if link is not None:
        parent_elem.insert(childpos, create_anchor(text_elems, link))
    else:
        for elem in text_elems:
            parent_elem.insert(childpos, elem)

def insert_summary(parent_elem, childpos, rect, summary):
    offset_y = text_margin + (title_font_size + text_margin) * 2 + head_margin * 2 + text_margin
    summaries = split_summary(summary)
    for i, s in enumerate(summaries):
        text_elem = create_text(rect, item_font_size, font_style='italic')
        text_elem.text = s.replace('&nbsp;', ' ')
        text_elem.attrib['y'] = str(rect[0][1] + offset_y + (item_font_size + text_margin) * i + item_font_size)
        parent_elem.insert(childpos, text_elem)

def insert_headers(parent_elem, childpos, rect, headers):
    offset_y = text_margin + (title_font_size + text_margin) * 2 + head_margin * 2 + text_margin
    offset_y += (item_font_size + text_margin) * 2 + text_margin
    for i, (header, summary) in enumerate(headers):
        text_elem = create_text(rect, item_font_size)
        text_elem.text = header
        text_elem.attrib['y'] = str(rect[0][1] + offset_y + (item_font_size + text_margin) * i + item_font_size)
        parent_elem.insert(childpos, text_elem)

def remove_texts(elem):
    old_text = elem
    while old_text is not None:
        if old_text.getnext() is not None and old_text.getnext().tag == '{http://www.w3.org/2000/svg}text':
            next_text = old_text.getnext()
        else:
            next_text = None
        old_text.getparent().remove(old_text)
        old_text = next_text
