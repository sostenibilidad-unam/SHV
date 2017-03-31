import argparse
import random
import os

parser = argparse.ArgumentParser(description='Create meta-simulation package at workdir')
parser.add_argument('--netlogo', required=True, help='absolute path to netlogo directory')
parser.add_argument('--workdir', required=True, help='absolute path to working directory where meta-simulation will be setup.')
#parser.add_argument('--argumentspace', type=argparse.FileType('r'), required=True,
#                    help="argument space CSV file")
#parser.add_argument('--landscape', default="many-hills",
#                    help="type of landscape")
#parser.add_argument('--new_infra_investment', type=int, nargs="+")
#parser.add_argument('--maintenance', type=int, nargs="+")
#parser.add_argument('--budget_distribution', default="competitionwithinactions")
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

# lines = args.argumentspace.readlines()

# create setup XML files and condor files
# with open('%s/submit_all.condor' % args.workdir, 'w') as condorfile:
#     condorfile.write("executable = run.sh\n\n")
#     for simulation_number in range(len(lines)-1):
#         for new_infra_investment in args.new_infra_investment:
#             for maintenance in args.maintenance:
#                 random_seed = random.randint(0, 100000)
#                 run_id = "nii%s_mii%s_%s_%s" % (new_infra_investment,
#                                                 maintenance,
#                                                 args.landscape,
#                                                 simulation_number)
#                 with open('%s/setup_%s.xml' % (args.workdir, run_id), 'w') as setupfile:

years = 8
e = {"time_limit" : years * 365,
     "eficiencia_nuevainfra": 0.005,
     "eficiencia_mantenimiento": 0.005,
     "lambda": 0.000004,
     "escala": "ciudad",
     "factor_subsidencia": 0.45,
     "recursos_para_distribucion": 600,
     "recursos_para_mantenimiento": 500,
     "recursos_nuevainfrastructura": 500,
     "ANP": "true",
     "requerimiento_deagua": 0.2788}

#setupfile.write(
print setup_template.format(**e)

#simulation_number=simulation_number,
#                                                           new_infra_investment=new_infra_investment,
#                                                           maintenance=maintenance,
#                                                           landscape=args.landscape,
#                                                           budget_distribution=args.budget_distribution,
#                                                           random_seed=random_seed,
#                                                           threads=args.threads))
#                 condorfile.write(condor_template.format(run_id=run_id,
#                                                         threads=args.threads))
