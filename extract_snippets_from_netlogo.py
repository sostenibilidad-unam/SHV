import json
import io
#para usar este script se necesitan dos archivos html, para hacerlos hay que exportar desde netlogo 
#y luego se editan en atom por ejemplo para agregar los saltos de linea despues de cada <br/ > 
slugs = []
with open('./model_description/slugs.json') as json_data:
    slugs = json.load(json_data)
    
for slug in slugs:
    print(slug)
    with io.open("./model_description/"+slug+".html", mode="w", encoding="utf-8") as pluma:
        pluma.write(u"<style>body {background-color: lightblue;}</style><body>")
        pluma.write(u"<h1><center><b>"+slug+u"</b></center></h1><br/ >")
        with io.open("ABM-Empirical-MexicoCity_6.html", mode="r", encoding="utf-8") as f:
            escribo = False
            for line in f:
               if ";"+slug+";" in line:
                   escribo = True
                   pluma.write(u"<pre><b>file: ABM-Empirical-MexicoCity_6.nlogo</b><br/ >")
                   pluma.write(u"     .<br/ >     .<br/ >     .<br/ ><br/ >")
               if ";/"+slug+";" in line:
                   escribo = False
                   pluma.write(u"<br/ >     .<br/ >     .<br/ >     .<br/ >")
                   pluma.write(u"</pre>")
               if escribo:
                   pluma.write(line)
        with io.open("value_funtions.html", mode="r", encoding="utf-8") as f:
            escribo = False
            for line in f:
               if ";"+slug+";" in line:
                   escribo = True
                   pluma.write(u"<pre><b>file: value_funtions.nls</b><br/ >")
                   pluma.write(u"     .<br/ >     .<br/ >     .<br/ ><br/ >")
               if ";/"+slug+";" in line:
                   escribo = False
                   pluma.write(u"<br/ >     .<br/ >     .<br/ >     .<br/ >")
                   pluma.write(u"</pre>")
               if escribo:
                   pluma.write(line)
        pluma.write(u"</body>")