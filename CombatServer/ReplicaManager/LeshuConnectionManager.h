#ifndef __LESHU_CONNECTION_MANAGER_H__
#define __LESHU_CONNECTION_MANAGER_H__

#include "ReplicaManager3.h"

using namespace RakNet;

class LeshuConnectionManager : public Connection_RM3 
{
public:
    LeshuConnectionManager(const SystemAddress &_systemAddress, RakNetGUID _guid);
    virtual ~LeshuConnectionManager();

    // See documentation - Makes all messages between ID_REPLICA_MANAGER_DOWNLOAD_STARTED and 
    //                     ID_REPLICA_MANAGER_DOWNLOAD_COMPLETE arrive in one tick
    bool QueryGroupDownloadMessages(void) const;

    virtual Replica3 *AllocReplica(
        RakNet::BitStream *allocationId, ReplicaManager3 *replicaManager3);
protected:
};

#endif
