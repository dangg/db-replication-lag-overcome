#!/bin/bash
# replica-init.sh

# Function to wait for the primary to initialize the replica set.
wait_for_primary() {
    echo "Waiting for primary to initiate replica set..."
    until mongosh --host mongo-primary --eval "rs.status().ok"; do
        echo "Waiting for primary node..."
        sleep 2
    done
}

# Add self to the replica set.
add_self_to_replica_set() {
    echo "Adding self to the replica set..."
    until mongosh --host mongo-primary --eval 'rs.add("mongo-replica:27017")'; do
        echo "Retrying to add self to replica set..."
        sleep 5
    done
}

# Main execution
# Wait for the primary to be ready.
wait_for_primary

# Add self to the replica set.
add_self_to_replica_set

echo "Replica node initialization complete."
