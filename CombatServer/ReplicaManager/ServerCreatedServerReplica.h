#ifndef __SERVER_CREATED_SERVER_REPLICA_H__
#define __SERVER_CREATED_SERVER_REPLICA_H__

#include "LeshuReplica.h"

class ServerCreatedServerReplica : public LeshuReplica
{
public:
    virtual RakNet::RakString GetName(void) const;

    // for abstract
    virtual RM3SerializationResult Serialize(RakNet::SerializeParameters* serializeParameters);

    virtual RM3ConstructionState QueryConstruction(
        RakNet::Connection_RM3* destinationConnection, RakNet::ReplicaManager3* replicaManager3);

    virtual bool QueryRemoteConstruction(RakNet::Connection_RM3* sourceConnection);

    virtual RM3QuerySerializationResult QuerySerialization(RakNet::Connection_RM3* destinationConnection);

    virtual RM3ActionOnPopConnection QueryActionOnPopConnection(
        RakNet::Connection_RM3* droppedConnection) const;
};

#endif
