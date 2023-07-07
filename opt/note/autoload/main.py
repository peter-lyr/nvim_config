import os
import re
import sys
import time


absdir = os.path.dirname(os.path.realpath(__file__))

def time_consuming(f):
    def func(*args, **kwargs):
        start = time.time()
        ret = f(*args, **kwargs)
        print(f'\033[1;32m{f.__name__} #### - 耗时', round(time.time() - start, 2), '秒……\033[0m\n')
        return ret
    return func

try:
    import cssmin
    import base64
    import markdown
    import pymdownx.superfences

    from slugify import slugify
    from selenium import webdriver
    from mdx_math import MathExtension
    from markdown.extensions.toc import TocExtension
    from webdriver_manager.chrome import ChromeDriverManager
except:
    os.system("pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com -r " + os.path.join(absdir, 'requirements.txt'))
    import cssmin
    import base64
    import markdown
    import pymdownx.superfences

    from slugify import slugify
    from selenium import webdriver
    from mdx_math import MathExtension
    from markdown.extensions.toc import TocExtension
    from webdriver_manager.chrome import ChromeDriverManager

CSS_PATH = os.path.join(absdir, 'hl.css')

css_p = ''
css2_p = ''
js_p = ''

css_p = CSS_PATH
css2_p = os.path.join(absdir, 'extra.css')
js_p = os.path.join(absdir, 'rd.js')

use_chrome = False
with_mathjax = False


def get_md_from_file(f):
    with open(f, "rb") as f:
        content = f.read().decode("utf-8")
        content = re.subn(re.compile(r'<!--[\s\S]*?-->'), '', content)[0]
        return content

def get_toc_html(content):
    extensions=[
        'markdown.extensions.tables',
        'markdown.extensions.footnotes',
        'pymdownx.magiclink',
        'pymdownx.betterem',
        'pymdownx.tilde',
        'pymdownx.emoji',
        'pymdownx.tasklist',
        'pymdownx.superfences',
        'pymdownx.saneheaders',
        'pymdownx.highlight',
        'pymdownx.progressbar',
        'pymdownx.mark',
        'pymdownx.pathconverter',
        'pymdownx.caret',
        'pymdownx.arithmatex',
        TocExtension(slugify=slugify),
        MathExtension(enable_dollar_delimiter=True),
    ]
    extension_configs = {
        #  "pymdownx.magiclink": {
        #      "repo_url_shortener": True,
        #      "repo_url_shorthand": True,
        #      "provider": "github",
        #      "user": "facelessuser",
        #      "repo": "pymdown-extensions"
        #  },
        #  "pymdownx.tilde": {
        #      "subscript": False
        #  },
        #  "pymdownx.emoji": {
        #      "emoji_index": emoji.gemoji,
        #      "emoji_generator": emoji.to_png,
        #      "alt": "short",
        #      "options": {
        #          "attributes": {
        #              "align": "absmiddle",
        #              "height": "20px",
        #              "width": "20px"
        #          },
        #          "image_path": "https://assets-cdn.github.com/images/icons/emoji/unicode/",
        #          "non_standard_image_path": "https://assets-cdn.github.com/images/icons/emoji/"
        #      }
        #  },
        #  "pymdownx.superfences":{
        #      "custom_fences": [{
        #          'name': 'mermaid',
        #          'class': 'mermaid',
        #          'format': pymdownx.superfences.fence_div_format,
        #          # 'format': '!!python/name:pymdownx.superfences.fence_div_format'
        #      }]
        #  }
    }
    md = markdown.Markdown(extensions=extensions, extension_configs=extension_configs)
    html = md.convert(content)
    # toc = md.toc if md.toc_tokens else ''
    toc = ''
    return toc, html

def _get_html(toc, html, js):
    global css_p, css2_p, js_p
    head = 'file:///' if css_p != CSS_PATH else ''
    return '''<!DOCTYPE html>\n''' + \
        '''<html lang="zh">\n''' + \
        ''' <head>\n''' + \
        '''  <meta charset="UTF-8">\n''' + \
        f'''  <link rel="stylesheet" href="{head}{css_p}">\n''' + \
        f'''  <link rel="stylesheet" href="{'file:///' if css2_p != 'extra.css' else ''}{css2_p}">\n''' + \
        '''  <title></title>\n''' + \
        ''' </head>\n''' + \
        ''' <body>\n''' + \
        toc + '\n' + \
        html + '\n' + \
        js + \
        ''' </body>\n''' + \
        '''</html>\n'''

def get_html(toc, html):
    global with_mathjax, use_chrome
    if '<script type="math/tex' in html:
        js_mathjax = ''' <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/''' + \
            "libs/mathjax/2.7.5/latest.js?config=TeX-MML-AM_CHTML' async></script>\n" + \
            ' <script type="text/x-mathjax-config">MathJax.Hub.Register.StartupHook(' + \
            '"End",function(){window.status="ready";});</script>\n'
        with_mathjax = True
    else:
        js_mathjax = ''

    if 'div class="mermaid"' in html:
        js_mermaid = ' <script type="text/javascript" src="https://unpkg.com/mermaid@8.11.0/dist/mermaid.js" crossorigin="anonymous"></script>\n' + \
            f''' <script type="text/javascript" src="{'file:///' if js_p != 'rd.js' else ''}{js_p}"></script>\n'''
        use_chrome = True
    else:
        js_mermaid = ''

    js = '\n'
    js += js_mathjax + js_mermaid

    return _get_html(toc, html, js)

def put_html_to_file(html, f):
    html = html.replace('</body>', '<script type="text/javascript">window.onload=function(){window.status="ready";}</script>\n\n </body>')
    with open(f, 'wb') as f:
        f.write(html.encode('utf-8'))

def convert_html_to_pdf(html_f, pdf_f):
    global with_mathjax
    # option = '--window-status ready ' if with_mathjax else ''
    option = '--javascript-delay 1000 ' if with_mathjax else ''
    option = option + '' if use_chrome else '--window-status ready '
    cmd = f'wkhtmltopdf ' + \
        '--encoding UTF-8 ' + \
        '--debug-javascript ' + \
        '--no-stop-slow-scripts ' + \
        '--page-size A4 ' + \
        '--minimum-font-size 14 ' + \
        '--quiet ' + \
        option + \
        '--enable-local-file-access ' + \
        f'"{html_f}" "{pdf_f}"'
    os.system(cmd)

def convert_html_to_docx(html_f, docx_f):
    cmd = f"pandoc -f html \"{html_f}\" -t docx -o {docx_f}"
    os.system(cmd)

def get_other_paths(md_p):
    html_p = '.'.join(md_p.split(".")[:-1]) + '.html'
    pdf_p = '.'.join(md_p.split(".")[:-1]) + '.pdf'
    docx_p = '.'.join(md_p.split(".")[:-1]) + '.docx'
    return html_p, pdf_p, docx_p

def render_html_file(html_p):
    options = webdriver.ChromeOptions()
    options.headless = True
    driver = webdriver.Chrome(ChromeDriverManager(version="87.0.4280.88").install(), options=options)
    # driver = webdriver.Chrome(ChromeDriverManager(version="94.0.4606.81").install(), options=options)
    driver.get(html_p)
    html = driver.page_source
    pattern = re.compile(r'(<script type="text[^>]*?>[\s\S]*?)</script>')
    html, _ = re.subn(pattern, '', html)
    html = html.replace('</body>', '<script type="text/x-mathjax-config">MathJax.Hub.Register.StartupHook(' + \
        '"End",function(){window.status="ready";});</script>\n\n </body>')
    with open(html_p, 'wb') as f:
        f.write(html.encode('utf-8'))
    driver.quit()

def image2base64(html_p):
    with open(html_p, 'rb') as f:
        html = f.read().decode('utf-8')
    patt = re.compile('''<img [^>]*?src=['"]([^'"]+)['"][^'">]*?>''')
    img_srcs = re.findall(patt, html)
    for img_src in img_srcs:
        if 'data:' in img_src and ';base64,/' in img_src:
            continue
        try:
            with open(os.path.normpath(os.path.join(os.path.dirname(html_p), img_src)), 'rb') as f:
                image_bytes = base64.b64encode(f.read())
        except Exception as e:
            print('''os.path.curdir: ''', os.path.curdir)
            print('''os.path.abspath(os.path.curdir): ''', os.path.abspath(os.path.curdir))
            print('''err: ''', e)
            continue
        image_str = str(image_bytes)
        base64_pre = 'data:image/' + img_src.split('.')[-1] + ';base64,'
        real_image_str = base64_pre + image_str[2:len(image_str) - 1]
        html = html.replace(img_src, real_image_str)
    with open(html_p, 'wb') as f:
        f.write(html.encode('utf-8'))

def csslink2style(html_p):
    with open(html_p, 'rb') as f:
        html = f.read().decode('utf-8')
    patt = re.compile('''(<link rel="stylesheet" href="([^"]+)">)''')
    link_hrefs = re.findall(patt, html)
    for link_tag, link_href in link_hrefs:
        try:
            href = link_href.strip('file:///') if 'file:///' in link_href else link_href
            # print('''href: ''', href)
            with open(href) as f:
                content = cssmin.cssmin(f.read())
        except Exception as e:
            print('''ERR: ''', e)
            continue
        html = html.replace(link_tag, f'<style>{content}</style>')
    with open(html_p, 'wb') as f:
        f.write(html.encode('utf-8'))

@time_consuming
def main(md_p):
    global use_chrome
    html_p, pdf_p, docx_p = get_other_paths(md_p)
    toc, html = get_toc_html(get_md_from_file(md_p))
    put_html_to_file(get_html(toc, html), html_p)
    if use_chrome:
        render_html_file(html_p)
    image2base64(html_p)
    csslink2style(html_p)
    print("html done!", html_p)
    convert_html_to_pdf(html_p, pdf_p)
    print("pdf done!", pdf_p)
    convert_html_to_docx(html_p, docx_p)
    print("docx done!", docx_p)


if __name__ == '__main__':
    try:
        md_p = sys.argv[1]
        print(md_p)
    except:
        md_p = os.path.join(absdir, 'a.md')
        print(md_p)
    main(md_p)
