import numpy as np

years = 40

escala = 'ciudad'

ANP = 'true'


eficiencia_nuevainfra = np.linspace(0.005, 0.01, 2)

eficiencia_mantenimiento = np.linspace( 0.005, 0.01, 2)

Lambda = np.linspace( 0, 1.0 / (100.0 * 365.0), 2)

factor_subsidencia = np.linspace( 0.001, 0.05, 2)

recursos_para_distribucion = np.linspace( 500, 2000, 2)

recursos_para_mantenimiento = np.linspace( 500, 2000, 2)

recursos_nuevainfrastructura = np.linspace( 500, 2000, 2)

requerimiento_deagua = np.linspace( 0.007, 0.1, 2)


