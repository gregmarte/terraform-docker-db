Setting up a local postgres DB for data collection.
Using Podman instead of Docker.
On Mac.


# Pre-reqs (system startup)
> podman machine start

# How to run
> mkdir /Users/Shared/Databases

> terrafom init
> terraform plan
> terraform apply

# Connecting to the database
> podman exec -it postgres_container psql -U admin -d property_db
> \l
> \dt
> select * from inventory;
