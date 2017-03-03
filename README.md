# uhv
urban hidric vulnerabilities agent based model


## postgres intagration
    sql:configure "defaultconnection" [["brand" "PostgreSQL"]["host" "localhost"]["port" 5432] ["user" "fidel"]["database" "netlogo"]]

    sql:exec-update "INSERT into tabla values (?,?)" [5 "luis"] 
