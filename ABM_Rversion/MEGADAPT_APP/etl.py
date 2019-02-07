import rpy2
from rpy2.robjects.packages import importr
base = importr('base')
from pony import orm
from pony.orm import db_session
from pony.orm import Required, Optional


db = orm.Database()

class Status(db.Entity):
    ageb_id = Required(int)
    municipio = Required(int)
    antiguedad_d = Required(float)
    antiguedad_ab = Required(float)
    f_en = Required(int)
    encharca = Required(float)
    falta_in = Required(float)
    capac_w = Optional(float)
    falta_dren = Required(float)
    lambdas = Required(int)
    nowater_week_pois = Required(float)
    nowater_twoweeks = Required(float)
    days_wn_water_month = Required(float)
    days_wn_water_year = Required(float)
    social_pressure = Required(float)
    sensitivity_ab = Required(float)
    sensitivity_d = Required(float)
    vulnerability_ab = Optional(float)
    vulnerability_d = Optional(float)
    interventions_ab = Required(float)
    interventions_d = Required(float)
    time_sim = Required(float)
    year_sim = Required(int)
    month_sim = Required(int)

rds = base.readRDS('../../outputs/effectivity_newInfra=0.25-effectivity_mantenimiento=0.25-decay_infra=0.25-Budget=24')

db.bind(provider='sqlite', filename='database.sqlite', create_db=True)
db.generate_mapping(create_tables=True)

n = 0
with db_session:
    for r in rds.iter_row():
        row = [c[0]
               for c in r.iter_column()]

        row[-2] = int(row[-2])
        row[-1] = int(row[-1])

        s = Status(
            ageb_id=row[0],
            municipio=row[1],
            antiguedad_d=row[2],
            antiguedad_ab=row[3],
            f_en=row[4],
            encharca=row[5],
            falta_in=row[6],
            capac_w=row[7],
            falta_dren=row[8],
            lambdas=row[9],
            nowater_week_pois=row[10],
            nowater_twoweeks=row[11],
            days_wn_water_month=row[12],
            days_wn_water_year=row[13],
            social_pressure=row[14],
            sensitivity_ab=row[15],
            sensitivity_d=row[16],
            vulnerability_ab=row[17],
            vulnerability_d=row[18],
            interventions_ab=row[19],
            interventions_d=row[20],
            time_sim=row[21],
            year_sim=row[22],
            month_sim=row[23])

        orm.commit()
        print(n)
        n += 1
