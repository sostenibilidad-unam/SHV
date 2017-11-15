import xml.etree.ElementTree as etree
from slugify import slugify

tree = etree.parse("diagrams5.svg")
root = tree.getroot()
root.set('id', "svgroot")
root.set('width', "60%")
root.set('height', "60%")

slugs = list()
slugs1 = list()
for ch in root.getchildren():
    text = []
    slug = slugify(u"x")
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
            slugs1.append(slug)
            with open(slug + '.md', "w") as pluma:
                pluma.write(text)
            e.set('id', slug + "-txt")
            # liga = etree.Element('ns0:a', {'href': slug + '.md'})
            # liga.append(e)
            # ch.append(liga)
            # ch.remove(e)
    if text:
        # ch.set('onclick', "load_info('" + text + "');")        
        ch.set('id', slug)
        ch.set('onclick', "window.parent.svgElementClicked('" + slug + "');")  
        ch.set('onmouseover', "document.getElementById('" + slug + "-txt').style.fontWeight = 'bold';")
        ch.set('onmouseout', "if (window.parent.current_selection != '" + slug + "') document.getElementById('" + slug + "-txt').style.fontWeight = 'normal';")
        
        
for e in root.findall('{http://www.w3.org/2000/svg}text'):
    text = []
    slug = slugify(u"x")
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
        slugs1.append(slug)
        with open(slug + '.md', "w") as pluma:
            pluma.write(text)
        e.set('id', slug + "-txt")
        # liga = etree.Element('ns0:a', {'href': slug + '.md'})
        # liga.append(e)
        # root.append(liga)
        # root.remove(e)
        e.set('onclick', "window.parent.svgElementClicked('" + slug + "');")
        e.set('onmouseover', "document.getElementById('" + slug + "-txt').style.fontWeight = 'bold';")
        e.set('onmouseout', "if (window.parent.current_selection != '" + slug + "') document.getElementById('" + slug + "-txt').style.fontWeight = 'normal';")


import json
with open('slugs.json', 'w') as outfile:
    json.dump(slugs1, outfile)
from pprint import pprint
pprint(slugs)

tree.write('aguas2.svg')
