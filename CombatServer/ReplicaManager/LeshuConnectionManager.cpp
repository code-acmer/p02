#include "LeshuConnectionManager.h"
#include "ClientCreatibleClientReplica.h"
#include "ClientCreatibleServerReplica.h"
#include "ServerCreatedClientReplica.h"
#include "ServerCreatedServerReplica.h"
#include "P2PReplica.h"
//#include <boost/make_shared.hpp>

LeshuConnectionManager::LeshuConnectionManager(const SystemAddress &_systemAddress, RakNetGUID _guid)
    : Connection_RM3(_systemAddress, _guid)
{

}

LeshuConnectionManager::~LeshuConnectionManager()
{

}

// See documentation - Makes all messages between ID_REPLICA_MANAGER_DOWNLOAD_STARTED and ID_REPLICA_MANAGER_DOWNLOAD_COMPLETE arrive in one tick
bool LeshuConnectionManager::QueryGroupDownloadMessages(void) const
{
    return true;
}

Replica3* LeshuConnectionManager::AllocReplica(
    RakNet::BitStream *allocationId, ReplicaManager3 *replicaManager3)
{
    RakNet::RakString typeName;
    allocationId->Read(typeName);
    printf("typeName: %s\n", typeName.C_String());
    
    if (typeName == "ClientCreatible_ClientSerialized")
        // client for client
        return new ClientCreatibleClientReplica;
    else if (typeName == "ServerCreated_ClientSerialized")
        // server for client
        return new ServerCreatedClientReplica;
    else if (typeName == "ClientCreatible_ServerSerialized")
        // client for server
        return new ClientCreatibleServerReplica;
    else if (typeName == "ServerCreated_ServerSerialized")
        // server for server
        return new ServerCreatedServerReplica;
    else if (typeName == "P2P")
        // p 2 p
        return new P2PReplica;
    else
        return NULL;
}

