#include "LeshuReplicaManager.h"
#include "LeshuConnectionManager.h"

RakNet::Connection_RM3* LeshuReplicaManager::AllocConnection(
    const RakNet::SystemAddress &systemAddress, RakNet::RakNetGUID rakNetGUID) const
{
    return new LeshuConnectionManager(systemAddress, rakNetGUID);
}

void LeshuReplicaManager::DeallocConnection(RakNet::Connection_RM3 *connection) const
{
    delete connection;
}

