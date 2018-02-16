# Socio Hidrological Vulnerability

Urban hidric vulnerabilities agent based model.


## Python Environment

The use of a python virtual environment is advised.

To create one, run:

	$ virtualenv venv

Once created it should be activated, before use:

	$ source venv/bin/activate
	(venv) $ # environment is now active

Then you may want to install the dependencies.

	(venv) $ pip install -r requirements.txt

Experiments are configured in the setup.py file. To create a batch for
HT-Condor use the provided create_run.py script.


## Batch run

The script **create_run.py** creates XML files for ranges of
parameters. Within your active virtualenv run it like this:

	(venv) $ python create_run.py --netlogo /path/to/NetLogo-6.0.2/ --workdir /path/to/batch_dir --threads 10

It will create XML files in /path/to/batch_dir, along with symbolic
links to Netlogo and other supporting files. Jobs should be submitted
from this directory.

## Path to Java

The last version of the model uses R scripting which in turn uses
NetLogo's R extension which is bundled in version 6.0.2. This version
requires java version 1.8, so you should have that in your PATH.

Do this before submiting jobs to the queue:


	$ export PATH=/path/to/jre1.8.0_161/bin:$PATH
	$ condor_submit submit_all.condor
