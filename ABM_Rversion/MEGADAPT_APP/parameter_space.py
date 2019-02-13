import numpy as np

time_simulation = 60


print """
executable = run_MEGADAPT_Cluster.R


log = log/scenarios_$(process).log
output = log/scenarios_$(process).out
error = log/scenarios_$(process).err

Requirements = (Machine != "tawa.lancis.ecologia.unam.mx")

queue arguments from ("""

# for effectivity_newInfra in np.linspace(0, 1, 5):
#     for effectivity_mantenimiento in np.linspace(0, 1, 5):
#         for decay_infra in np.linspace(0, 1, 5):
#             for budget in np.linspace(24, 2429, 5):
#                 for scenario in range(1,13):
#                     for repetition in range(100):
#                         print "%.2f %.2f %.2f %s %.0f %s %s" % (effectivity_newInfra,
#                                                               effectivity_mantenimiento,
#                                                               decay_infra,
#                                                               time_simulation,
#                                                               budget,
#                                                               scenario,
#                                                               repetition)

effectivity_newInfra = 0.23
effectivity_mantenimiento = 0.23
decay_infra = 0.23
budget = 1000
scenario = 1
for repetition in range(100):
    print "\t%.2f %.2f %.2f %s %.0f %s %s" % (effectivity_newInfra,
                                          effectivity_mantenimiento,
                                          decay_infra,
                                          time_simulation,
                                          budget,
                                          scenario,
                                          repetition)


print ")"
