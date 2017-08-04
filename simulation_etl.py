from pony.orm import db_session, Database, Required
import csv
from pprint import pprint

db = Database()

class Vulnerability(db.Entity):
    eficiencia_nuevainfra = Required(float)
    eficiencia_mantenimiento = Required(float)
    lmbda = Required(float)
    factor_subsidencia = Required(float)
    recursos_para_distribucion = Required(float)
    recursos_para_mantenimiento = Required(float)
    recursos_nuevainfrastructura = Required(float)
    requerimiento_agua = Required(float)

    municipio = Required(str)

    edad_infra = Required(float)
    scarcity = Required(float)

db.bind('sqlite', 'aguas.sqlite', create_db=True)
db.generate_mapping(create_tables=True)

edad_mask = 'mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "%03d"]'
scarc_mask = 'mean [scarcity_index] of agebs with [CV_municipio = "%03d"]'
mun = [None, None, "Azcapotzalco","Coyoacan","Cuajimalpa","Gustavo A. Madero","Iztacalco","Iztapalapa","Magdalena Contreras",
       "Milpa Alta","Alvaro Obregon","Tlahuac","Tlalpan","Xochimilco","Benito Juarez","Cuauhtemoc","Miguel Hidalgo","Venustiano Carranza"]

with open('/srv/home/fidel/empirical_abm_runs/ex2/gran_output.csv') as f, db_session:
    r = csv.DictReader(f)
    for row in r:
        v = { 'eficiencia_nuevainfra': row['Eficiencia_NuevaInfra'],
              'eficiencia_mantenimiento': row['Eficiencia_Mantenimiento'],
              'lmbda': row['lambda'],
              'factor_subsidencia': row['factor_subsidencia'],
              'recursos_para_distribucion': row['Recursos_para_distribucion'],
              'recursos_para_mantenimiento': row['recursos_para_mantenimiento'],
              'recursos_nuevainfrastructura': row['recursos_nuevaInfrastructura'],
              'requerimiento_agua': row['Requerimiento_deAgua'] }

        for municipio in range(2, 18):
            v['municipio'] = mun[int(municipio)]
            v['edad_infra'] = row[edad_mask % municipio]
            v['scarcity'] = row[scarc_mask % municipio]
            Vulnerability(**v)
            
            
