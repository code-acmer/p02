#include "ClientCreatibleServerReplica.h"
#include "Global.h"

RakNet::RakString ClientCreatibleServerReplica::GetName(void) const
{
    return RakNet::RakString("ClientCreatible_ServerSerialized");
}

RakNet::RM3SerializationResult ClientCreatibleServerReplica::Serialize(
    RakNet::SerializeParameters* serializeParameters)
{
    if (SERVER == CLIENT)
        return RM3SR_DO_NOT_SERIALIZE;
    return LeshuReplica::Serialize(serializeParameters);
}

RM3ConstructionState ClientCreatibleServerReplica::QueryConstruction(
    RakNet::Connection_RM3* destinationConnection, RakNet::ReplicaManager3* replicaManager3)
{
    return QueryConstruction_ClientConstruction(destinationConnection, !G_IsClient);
}

bool ClientCreatibleServerReplica::QueryRemoteConstruction(
    RakNet::Connection_RM3* sourceConnection)
{
    return QueryRemoteConstruction_ClientConstruction(sourceConnection, !G_IsClient);
}

RM3QuerySerializationResult ClientCreatibleServerReplica::QuerySerialization(
    RakNet::Connection_RM3* destinationConnection)
{
    return QuerySerialization_ServerSerializable(destinationConnection, !G_IsClient);
}

RM3ActionOnPopConnection ClientCreatibleServerReplica::QueryActionOnPopConnection(
    RakNet::Connection_RM3* droppedConnection) const
{
    return QueryActionOnPopConnection_Client(droppedConnection);
}
