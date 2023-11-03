# Readme

This repository is aimed at providing a proof of concept for the post here:

Mitigating replication lag in an application with single-leader — multi-follower MongoDB setup

https://dan-gurgui.medium.com/mitigating-replication-lag-in-an-application-with-single-leader-multi-follower-mongodb-setup-e8e67c49b3f4

In order to execut this either setup the local MongoDB server using docker-compose 
OR 
Follow the guide below

## Setup local mongoDb replica set

Setting up a MongoDB replica set on your local machine for development purposes involves running multiple instances of MongoDB on different ports and then configuring them to be part of the same replica set. Here's a basic guide on how to do it:

Step 1: Install MongoDB
First, you need to have MongoDB installed on your local machine. You can download it from the MongoDB official website or use a package manager for your system.

Step 2: Create Data Directories
Create separate data directories for each member of the replica set. For example, you might create directories like this:

    mkdir -p ~/mongo-replica-set/rs0-0 ~/mongo-replica-set/rs0-1 ~/mongo-replica-set/rs0-2
Step 3: Start MongoDB Instances
Start each MongoDB instance on a different port, using the data directories you just created. You can do this by opening separate terminal windows or using a single command with & to run them in the background.

    mongod --replSet rs0 --port 27017 --bind_ip localhost --dbpath ~/mongo-replica-set/rs0-0 --oplogSize 128
    mongod --replSet rs0 --port 27018 --bind_ip localhost --dbpath ~/mongo-replica-set/rs0-1 --oplogSize 128
    mongod --replSet rs0 --port 27019 --bind_ip localhost --dbpath ~/mongo-replica-set/rs0-2 --oplogSize 128
Here, rs0 is the name of the replica set, and --oplogSize is the size of the operation log (oplog), which is a capped collection that stores all operations that modify the data stored in your databases.

Step 4: Connect to One of Your MongoDB Instances
Connect to one of your instances using the mongo shell. You can use the mongo command followed by the port number to connect to a specific instance:

    mongo --port 27017
Step 5: Initialize the Replica Set
Once connected to the shell, use the following commands to initialize the replica set and add the members:

    rs.initiate(
      {
        _id: "rs0",
        members: [
          { _id: 0, host: "localhost:27017" },
          { _id: 1, host: "localhost:27018" },
          { _id: 2, host: "localhost:27019" }
        ]
      }
    )
    
Step 6: Check the Status of Your Replica Set
To ensure your replica set is configured correctly, use the rs.status() command:

    rs.status()
This will print the status of your replica set, including the state of each member.

Step 7: Use the Replica Set
You can now use the replica set. When you connect to your application or use the mongo shell, specify the replica set in the connection string:


    mongo "mongodb://localhost:27017,localhost:27018,localhost:27019/?replicaSet=rs0"
By following these steps, you should have a functional MongoDB replica set running on your local machine. This setup is adequate for development and testing but should not be considered a production-grade configuration. For production, you would need to consider additional aspects such as security, backups, monitoring, and performance tuning.

## Test the setup

    node app.js

    curl -X POST http://localhost:3000/write -H "Content-Type: application/json" -d '{"key": "value"}' 

    curl -X GET http://localhost:3000/read



