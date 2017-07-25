# coding: utf-8

import re
import os
from IPython.core.display import HTML, display
from nbformat import read, write, NO_CONVERT

def create_html(full_name, file_name) : 
    '''
    引数のNotebookについての目次文章を作る。
    先頭にNotebookへのリンク、
    2行目以降にレベル2までのHeadlineのリストを生成する。
    '''
    ret = []
    
    # 1行目に出すNotebookのリンクを生成する
    file_link = '<a href="{0}" target="_blank"><b>{1}</b></a>'.format(full_name, file_name)
    ret.append(file_link)

    # レベル2までのHeadlineのリストを生成する。
    nb = read(full_name, as_version=NO_CONVERT)
    for cell in filter(lambda cell: cell['cell_type'] == 'markdown', nb.cells):
        # セル情報のうち、sourceタグ部分を抽出する。
        lines = filter(lambda l: len(l) > 0, cell['source'].split('\n'))
        
        # レベル1か2のHeadline部のみ扱いたいので、それ以外の処理は続けない
        if len(lines) == 0 or not lines[0].startswith('#') or lines[0].startswith('###'):
            continue
        
        # レベル1と2の行頭文字を作り分ける
        if lines[0].startswith('##'):
            indent = u'&emsp;・'
        else:
            indent = u''
        
        # 1行目のHeadlineタイトルとその次の行を、行頭文字と合わせて1つのhtmlにする。
        title = '<b>' + lines[0].replace('#' , '').strip()+ '</b>'
        text = ''.join(lines[1:2])
        if(re.match(r".*---.*", text)):
            text = ''.join(lines[2:3])
        desc = ' - ' + text if text <>'' else ''
        ret.append(indent + title + desc)
    
    # 生成した全文字列を改行で連結して返す。
    return '<br/>'.join(ret)


def display_notebook_contents():
    '''
    ディレクトリにある全ipynbファイルについて、目次を生成して表示する。
    '''
    ref_notebooks = filter(lambda m: m, map(lambda n: re.match(r'([0-9][0-9a-z]+_.*)\.ipynb', n), os.listdir('.')))
    ref_notebooks = sorted(ref_notebooks, key=lambda m: m.group(1))

    display(HTML(''.join(map(lambda m: '<div>' + create_html(m.group(0), m.group(1)) + '</div><br/>', ref_notebooks))))
