import argparse
import random
import os
import setup
import numpy as np

parser = argparse.ArgumentParser(description='Create meta-simulation package at workdir')
parser.add_argument('--netlogo', required=True, help='absolute path to netlogo directory')
parser.add_argument('--workdir', required=True, help='absolute path to working directory where meta-simulation will be setup.')
parser.add_argument('--threads', type=int, default=12)
args = parser.parse_args()


# create working directory
if not os.path.isdir(args.workdir):
    os.makedirs(args.workdir)

# create symlink to netlogo
netlogo_jar = os.path.join( args.netlogo, "app/NetLogo.jar")
assert os.path.exists(netlogo_jar)
os.symlink(netlogo_jar, os.path.join(args.workdir, "NetLogo.jar"))

# symlink extensions    
extensions = ['csv', 'matrix', 'gis', 'bitmap', 'profiler']
for extension in extensions:
    ext_path = os.path.join( args.netlogo, "app/extensions/%s" % extension)
    assert os.path.exists(ext_path)
    os.symlink(ext_path, os.path.join(args.workdir, extension))

# create symlinks to model, argumentspace and run script
this_dir = os.path.dirname(os.path.realpath(__file__))
os.symlink(os.path.join(this_dir, "ABM-Empirical-MexicoCity.nlogo"),
           os.path.join(args.workdir, "ABM-Empirical-MexicoCity.nlogo"))
#os.symlink(os.path.join(this_dir, args.argumentspace.name), os.path.join(args.workdir, args.argumentspace.name))
os.symlink(os.path.join(this_dir, "run.sh"), os.path.join(args.workdir, "run.sh"))
os.symlink(os.path.join(this_dir, "data"), os.path.join(args.workdir, "data"))

# read setup and submit templates
setup_template = open('setup_template_empirical.xml').read()
condor_template= open('submit_template.condor').read()


# create setup XML files and condor files
with open('%s/submit_all.condor' % args.workdir, 'w') as condorfile:
    for eficiencia_nuevainfra in setup.eficiencia_nuevainfra:
        for eficiencia_mantenimiento in setup.eficiencia_mantenimiento:
            for Lambda in setup.Lambda:
                for factor_subsidencia in setup.factor_subsidencia:
                    for recursos_para_distribucion in setup.recursos_para_distribucion:
                        for recursos_para_mantenimiento in setup.recursos_para_mantenimiento:
                            for recursos_nuevainfrastructura in setup.recursos_nuevainfrastructura:
                                for requerimiento_deagua in setup.requerimiento_deagua:
                                    run_id = "r_%s_%s_%s_%s_%s_%s_%s_%s" % (eficiencia_nuevainfra,
                                                                            eficiencia_mantenimiento,
                                                                            Lambda,
                                                                            factor_subsidencia,
                                                                            recursos_para_distribucion,
                                                                            recursos_para_mantenimiento,
                                                                            recursos_nuevainfrastructura,
                                                                            requerimiento_deagua)

                                    condorfile.write(condor_template.format(run_id=run_id,
                                                                            threads=args.threads))

                                    with open('%s/setup_%s.xml' % (args.workdir, run_id), 'w') as setupfile:
                                        e = {"time_limit" : setup.years * 365,
                                             "eficiencia_nuevainfra": eficiencia_nuevainfra,
                                             "eficiencia_mantenimiento": eficiencia_mantenimiento,
                                             "lambda": Lambda,
                                             "escala": setup.escala,
                                             "factor_subsidencia": factor_subsidencia,
                                             "recursos_para_distribucion": recursos_para_distribucion,
                                             "recursos_para_mantenimiento": recursos_para_mantenimiento,
                                             "recursos_nuevainfrastructura": recursos_nuevainfrastructura,
                                             "ANP": setup.ANP,
                                             "requerimiento_deagua": requerimiento_deagua} 
                                        setupfile.write(
                                            setup_template.format(**e)
                                            )
