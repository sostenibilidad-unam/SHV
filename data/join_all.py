import os
import processing

path = "/Users/abaezaca/Dropbox (ASU)/Layers (1)/final"

#base_layer = QgsVectorLayer(os.path.join(path,"agebs_input.shp"))


#shp=iface.activeLayer()

#layer = QgsVectorLayer(os.path.join(path,"abastecimiento.shp"))


dirs = os.listdir(path)
for file in dirs:
   if "agebs_abm" in file:
        
        print file
        os.remove(os.path.join(path,file))



#baseField='AGEB_ID'
#joinField='AGEB_ID'
#joinObject = QgsVectorJoinInfo()
#joinObject.joinLayerId = layer.id()
#joinObject.joinFieldName = joinField
#joinObject.targetFieldName = baseField
#joinObject.memoryCache = True
#shp.addJoin(joinObject)
#if shp.addJoin(joinObject):
#    print "join succeded"
#else:
#    print "join failed"

#writer = QgsVectorFileWriter.writeAsVectorFormat(shp, os.path.join(path,"agebs_join.shp"), "UTF-8", None, "ESRI Shapefile")
dirs = os.listdir(path)
for file in dirs:
   if "agebs_joined" in file:
        
        print file
        os.remove(os.path.join(path,file))




dirs = os.listdir(path)
numeroDeShapes = 0
for file in dirs:
   if file.endswith(".shp") and not "agebs_input" in file:
        numeroDeShapes += 1



print "numero de shapes " + str(numeroDeShapes)
dirs = os.listdir(path)
contador = 0
for file in dirs:
   if ".shp" in file and not "agebs_input" in file:
        contador += 1
        print file
        if contador == 1:
            targetPath = os.path.join(path,"agebs_input.shp")
        else:
            targetPath = os.path.join(path,"agebs_joined"+str(contador-1)+".shp")
            
            
        if contador == numeroDeShapes:
            outputFile = os.path.join(path,"agebs_abm.shp")
        else:
            outputFile = os.path.join(path,"agebs_joined"+str(contador)+".shp")
            
        res = processing.runalg("qgis:joinattributestable",targetPath,os.path.join(path,file),"AGEB_ID","AGEB_ID",outputFile)
        
        layer = QgsVectorLayer(res['OUTPUT_LAYER'], "joined layer", "ogr")
        
        index = layer.fieldNameIndex('ageb_id_2')
        
        layer.dataProvider().deleteAttributes([index])
        
        layer.updateFields()
        
   
dirs = os.listdir(path)
for file in dirs:
   if "agebs_joined" in file:
        
        print file
        os.remove(os.path.join(path,file))
        
        
