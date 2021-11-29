#!/bin/bash

if [ -n "$MONGODB_REPLICA_SET_NAME" ] && [ "$MONGO_INITDB_ROOT_USERNAME" ] && [ "$MONGO_INITDB_ROOT_PASSWORD" ]; then
    echo "Shutdown mongo for now, restart it with --replSet param, initiate the repliSet and finally add the startup param to the other args"
    "$@" --shutdown
    echo "Okay, MongoDB is down for now."
    #"${mongodHackedArgs[@]} --fork --replSet $MONGODB_REPLICA_SET_NAME"
    MONGO_RESTART="${mongodHackedArgs[@]//'27017'/$MONGODB_PORT} --fork --replSet $MONGODB_REPLICA_SET_NAME"
    MONGO_RESTART=${MONGO_RESTART//'--bind_ip 127.0.0.1'/'--bind_ip_all'}
    $MONGO_RESTART
    echo "MongoDB restarted."
    #IP_ADDRESS="$(ip route | head -n 1 | cut -d ' ' -f 3)"
    echo "Check that changed"
    IP_ADDRESS=${MONGO_HOSTNAME:-}
    if [ -z "${IP_ADDRESS}" ]; then
     echo "No explicit hostname set, using docker bridge";
     IP_ADDRESS="$(hostname -I)";
    else
     echo "Explicit hostname set, using it";
     IP_ADDRESS="${MONGO_HOSTNAME}";
    fi
    echo "Will use ${IP_ADDRESS} in replica set"
    MONGO_RS_INIT="${mongo[@]//'27017'/$MONGODB_PORT}"
    $MONGO_RS_INIT --eval "rs.initiate({_id: \"$MONGODB_REPLICA_SET_NAME\", members: [{_id: 0, host: \"${IP_ADDRESS}:$MONGODB_PORT\"}]})"
    echo "ReplicaSet should be initialized now."
    set -- "$@" --replSet "${MONGODB_REPLICA_SET_NAME}"
    set -- "$@" --port "${MONGODB_PORT}"
    echo "Added '--replSet ${MONGODB_REPLICA_SET_NAME}' to startup parameters."
fi