#include "P2PReplica.h"

RakNet::RakString P2PReplica::GetName(void) const
{
    return RakNet::RakString("P2PReplica");
}

RM3ConstructionState P2PReplica::QueryConstruction(
    RakNet::Connection_RM3* destinationConnection, RakNet::ReplicaManager3* replicaManager3)
{
    return QueryConstruction_PeerToPeer(destinationConnection);
}

bool P2PReplica::QueryRemoteConstruction(RakNet::Connection_RM3* sourceConnection)
{
    return QueryRemoteConstruction_PeerToPeer(sourceConnection);
}

RM3QuerySerializationResult P2PReplica::QuerySerialization(
    RakNet::Connection_RM3* destinationConnection)
{
    return QuerySerialization_PeerToPeer(destinationConnection);
}

RM3ActionOnPopConnection P2PReplica::QueryActionOnPopConnection(
    RakNet::Connection_RM3* droppedConnection) const
{
    return QueryActionOnPopConnection_PeerToPeer(droppedConnection);
}
