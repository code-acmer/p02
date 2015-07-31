#include "ServerCreatedClientReplica.h"

RakNet::RakString ServerCreatedClientReplica::GetName(void) const
{
    return RakNet::RakString("ServerCreated_ClientSerialized");
}

RM3SerializationResult ServerCreatedClientReplica::Serialize(
    RakNet::SerializeParameters* serializeParameters)
{
    return LeshuReplica::Serialize(serializeParameters);
}

RM3ConstructionState ServerCreatedClientReplica::QueryConstruction(
    RakNet::Connection_RM3* destinationConnection, RakNet::ReplicaManager3* replicaManager3)
{
    return QueryConstruction_ServerConstruction(destinationConnection, !G_IsClient);
}

bool ServerCreatedClientReplica::QueryRemoteConstruction(RakNet::Connection_RM3* sourceConnection)
{
    return QueryRemoteConstruction_ServerConstruction(sourceConnection, !G_IsClient);
}

RM3QuerySerializationResult ServerCreatedClientReplica::QuerySerialization(
    RakNet::Connection_RM3* destinationConnection)
{
    return QuerySerialization_ClientSerializable(destinationConnection, !G_IsClient);
}

RM3ActionOnPopConnection ServerCreatedClientReplica::QueryActionOnPopConnection(
    RakNet::Connection_RM3* droppedConnection) const
{
    return QueryActionOnPopConnection_Server(droppedConnection);
}
