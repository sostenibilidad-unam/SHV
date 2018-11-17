import numpy as np

years = 20

escala = 'cuenca'

ANP = 'true'


eficiencia_nuevainfra = np.linspace(0.025, 0.1, 3)

eficiencia_mantenimiento = np.linspace( 0.025, 0.1, 3)

Lambda = np.linspace( 1.0 / (100.0 * 365.0), 2.0 / (100.0 * 365.0), 1)

factor_subsidencia = np.linspace( 0.001, 0.05, 1)

recursos_para_distribucion = np.linspace( 750, 2250, 1)

recursos_para_mantenimiento = np.linspace( 100, 250, 2)

recursos_nuevainfrastructura = np.linspace( 100, 250, 2)

requerimiento_deagua = np.linspace( 0.007, 0.1, 1)

n_runs = np.linspace( 1, 20, 20)
