#include "ServerCreatedServerReplica.h"

RakNet::RakString ServerCreatedServerReplica::GetName(void) const
{
    return RakNet::RakString("ServerCreated_ServerSerialized");
}

RM3SerializationResult ServerCreatedServerReplica::Serialize(
    RakNet::SerializeParameters* serializeParameters)
{
    if (SERVER == CLIENT)
        return RM3SR_DO_NOT_SERIALIZE;

    return LeshuReplica::Serialize(serializeParameters);
}

RM3ConstructionState ServerCreatedServerReplica::QueryConstruction(
    RakNet::Connection_RM3* destinationConnection, RakNet::ReplicaManager3* replicaManager3)
{
    return QueryConstruction_ServerConstruction(destinationConnection, !G_IsClient);
}

bool ServerCreatedServerReplica::QueryRemoteConstruction(RakNet::Connection_RM3* sourceConnection)
{
    return QueryRemoteConstruction_ServerConstruction(sourceConnection, !G_IsClient);
}

RM3QuerySerializationResult ServerCreatedServerReplica::QuerySerialization(
    RakNet::Connection_RM3* destinationConnection)
{
    return QuerySerialization_ServerSerializable(destinationConnection, !G_IsClient);
}

RM3ActionOnPopConnection ServerCreatedServerReplica::QueryActionOnPopConnection(
    RakNet::Connection_RM3* droppedConnection) const
{
    return QueryActionOnPopConnection_Server(droppedConnection);
}
