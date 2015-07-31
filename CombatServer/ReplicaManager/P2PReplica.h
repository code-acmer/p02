#ifndef __P2P_REPLICA_H__
#define __P2P_REPLICA_H__

#include "LeshuReplica.h"

class P2PReplica : public LeshuReplica 
{
    virtual RakNet::RakString GetName(void) const;

    // for abstract
    virtual RM3ConstructionState QueryConstruction(
        RakNet::Connection_RM3* destinationConnection, RakNet::ReplicaManager3* replicaManager3);

    virtual bool QueryRemoteConstruction(RakNet::Connection_RM3* sourceConnection);

    virtual RM3QuerySerializationResult QuerySerialization(
        RakNet::Connection_RM3* destinationConnection);

    virtual RM3ActionOnPopConnection QueryActionOnPopConnection(
        RakNet::Connection_RM3* droppedConnection) const;
};

#endif
