#ifndef __LESHU_REPLICA_MANAGER_H__
#define __LESHU_REPLICA_MANAGER_H__

#include "ReplicaManager3.h"

class LeshuReplicaManager : public RakNet::ReplicaManager3
{
public:

    // for abstract
    virtual RakNet::Connection_RM3* AllocConnection(
        const RakNet::SystemAddress &systemAddress, RakNet::RakNetGUID rakNetGUID) const;
    virtual void DeallocConnection(RakNet::Connection_RM3 *connection) const;
};

#endif
