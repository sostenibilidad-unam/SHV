
# uhv
urban hidric vulnerabilities agent based model


## postgres intagration
    sql:configure "defaultconnection" [["brand" "PostgreSQL"]["host" "localhost"]["port" 5432] ["user" "fidel"]["database" "netlogo"]]

    sql:exec-update "INSERT into tabla values (?,?)" [5 "luis"] 


# Python Environment

The use of a python virtual environment is advised.

To create one, run:

   $ virtualenv venv

Once created it should be activated, before use:

    $ source venv/bin/activate
    (venv) $ # environment is now active
    

# Extract, Transform & Load

First grab the header of any output CSV, thusly:

      $ tail -n +7 output_r_0.005_0.005_2.7397260274e-05_0.05_500.0_750.0_500.0_0.007_9.0.csv | head -n 1 > gran_output.csv

Then append the rest of the data rows, like so:

     $ find . -iname 'output_*csv' -exec tail -n +8 {} \; >> gran_output.csv

Finally run the ETL script:

    $ python simulation_etl.py



# On-Line Analytical Processing

HT-SQL for OLAP can be used:

    $ htsql-ctl serve --port 8881 -E tweak.shell.default sqlite:aguas.sqlite

Then you may want to browse [http://patung:8881](http://patung:8881).