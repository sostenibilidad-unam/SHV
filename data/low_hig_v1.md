
# SubWatershets
## Lowlands and Highlands
## 13 noviembre 2017


#### Datos generales del mapa.
###### Cita oficial:

###### Resumen:
En este mapa se muestran las AGEB que se localizan en las cuencas de la periferia o de zonas altas y las que se localizan en cuencas internas o de zonas bajas.
######  Nivel de avance:
Terminado

#### Ubicación geográfica.
###### Área geográfica:
Cuenca del valle de México


###### Coordenadas extremas:

xMín 348621.68    
yMín 2054434.61    
xMáx 644398.35    
yMáx 2344228.00    

#### Calidad de los datos.
###### Metodología:

Se utilizó la capa de Cuencas hidroantopogenizadas de la periferia del Valle de México <sup>1</sup>  para seleccionar a las AGEB que se localizan en las zonas altas, se considera que una AGEB está en zona alta si al menos la mitad de su superficie coincide espacialmente con la capa de cuencas de la periferia.

<sup>1</sup> Juan Ansberto Cruz Gerón, Óscar Arturo Fuentes Mariles, Sergio Armando Flores Peña y Luis Antonio Bojórquez Tapia 2016. CUENCAS HIDROANTROPOGENIZADAS DEL VALLE DE MÉXICO EN LA ESTIMACIÓN DE ÍNDICES DE SOSTENIBILIDAD DE MANEJO DE AGUA A ESCALA METROPOLITANA.)



**Proceso en GRASS**  

Se obtiene el área de cada AGEB dentro de las cuencas de la periferia
`r.stats -an CHAVDMP,AGEB_elev sep=, > /home/marco/CVM_SIG/ageb_chavdmp`

Se obtiene el área de cada AGEB
`r.stats -lan AGEB_edos sep=, > /home/marco/CVM_SIG/superficie_ageb`

Las tablas se copiaron en una hoja de cálculo y se clasificaron como AGEB en zonas altas cuando la superficie en zonas altas era igual o mayor a la mitad de la superficie de la AGEB 

Se usó la tabla para generar un archivo vectorial.

#### Datos espaciales.
###### Estructura del dato:
Vector

###### Tipo de datos:
Polígonos

#### Proyección geográfica.
###### Sistema de coordenadas:
Universal Transversa de Mercator

###### Proyección:
WGS 84 / UTM zone 14N

###### Paralelos estándar:
Greenwich

###### Esferoide:
--

###### Datum:
World Geodetic System 1984

###### Elipsoide:
WGS84

#### Atributos del mapa.

Nombre del campo | FID
------------ | -------------
Tipo | Entero
Unidades | --
Descripción | Identificador numérico para cada subcuenca
Observaciones | Texto

Nombre del campo | low_hig
------------ | -------------
Tipo | Entero
Unidades | --
Descripción | 0=lowlands, 1=highlands
Observaciones | --
