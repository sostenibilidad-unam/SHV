import numpy as np

years = 20

escala = 'cuenca'

ANP = 'true'


eficiencia_nuevainfra = np.linspace(0.005, 0.01, 1)

eficiencia_mantenimiento = np.linspace( 0.005, 0.01, 1)

Lambda = np.linspace( 1.0 / (100.0 * 365.0), 2.0 / (100.0 * 365.0), 1)

factor_subsidencia = np.linspace( 0.001, 0.05, 1)

recursos_para_distribucion = np.linspace( 750, 2250, 4)

recursos_para_mantenimiento = np.linspace( 500, 2000, 1)

recursos_nuevainfrastructura = np.linspace( 500, 2000, 1)

requerimiento_deagua = np.linspace( 0.007, 0.1, 1)
