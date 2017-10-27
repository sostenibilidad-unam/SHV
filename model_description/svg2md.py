import xml.etree.ElementTree as etree
from slugify import slugify

tree = etree.parse("diagrams2.svg")
root = tree.getroot()


slugs = list()

for e in root.findall('{http://www.w3.org/2000/svg}text'):
    text = []
    for tspan in e.getchildren():
        if tspan.text is not None:
            text.append(tspan.text.strip())
    if text:
        text = u" ".join(text)
        slug = slugify(text)
        n = slugs.count(slug)
        slugs.append(slug)
        if n:
            slug += unicode(n)

        liga = etree.Element('ns0:a', {'xlink:href': slug + '.md'})
        liga.append(e)
        root.append(liga)
        root.remove(e)


for ch in root.getchildren():
    for e in ch.findall('{http://www.w3.org/2000/svg}text'):
        text = []
        for tspan in e.getchildren():
            if tspan.text is not None:
                text.append(tspan.text.strip())
        if text:
            text = u" ".join(text)
            slug = slugify(text)
            n = slugs.count(slug)
            slugs.append(slug)
            if n:
                slug += unicode(n)

            liga = etree.Element('ns0:a', {'xlink:href': slug + '.md'})
            liga.append(e)
            ch.append(liga)
            ch.remove(e)

from pprint import pprint
pprint( slugs)

tree.write('aguas.svg')
