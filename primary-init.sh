#!/bin/bash
# primary-init.sh

# Function to wait for MongoDB to start listening on its port.
wait_for_mongo() {
    echo "Waiting for MongoDB to start..."
    until mongosh --eval "print('waited for connection')"; do   
        sleep 1
    done
    echo "MongoDB started"
}

# Initiate the replica set.
init_replica_set() {
    echo "Initiating the replica set..."
    until mongosh --eval 'rs.initiate({_id: "rs0", members: [{_id: 0, host: "mongo-primary:27017"}]})'; do
        echo "Retrying to initiate replica set..."
        sleep 5
    done
}

# Main execution
# Wait for MongoDB to be ready.
wait_for_mongo

# Initiate the replica set.
init_replica_set

echo "Primary node initialization complete."
