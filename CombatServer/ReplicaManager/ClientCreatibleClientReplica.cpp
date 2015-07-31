#include "ClientCreatibleClientReplica.h"

RakNet::RakString ClientCreatibleClientReplica::GetName(void) const
{
    return RakNet::RakString("ClientCreatible_ClientSerialized");
}

RM3SerializationResult ClientCreatibleClientReplica::Serialize(
    RakNet::SerializeParameters* serializeParameters)
{
    return LeshuReplica::Serialize(serializeParameters);
}

RM3ConstructionState ClientCreatibleClientReplica::QueryConstruction(
    RakNet::Connection_RM3* destinationConnection, RakNet::ReplicaManager3* replicaManager3)
{
    return QueryConstruction_ClientConstruction(destinationConnection, !G_IsClient);
}

bool ClientCreatibleClientReplica::QueryRemoteConstruction(RakNet::Connection_RM3* sourceConnection)
{
    return QueryRemoteConstruction_ClientConstruction(sourceConnection, !G_IsClient);
}

RM3QuerySerializationResult ClientCreatibleClientReplica::QuerySerialization(
    RakNet::Connection_RM3* destinationConnection)
{
    return QuerySerialization_ClientSerializable(destinationConnection, !G_IsClient);
}

RM3ActionOnPopConnection ClientCreatibleClientReplica::QueryActionOnPopConnection(
    RakNet::Connection_RM3* droppedConnection) const
{
    return QueryActionOnPopConnection_Client(droppedConnection);
}
