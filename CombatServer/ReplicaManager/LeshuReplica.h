#ifndef __LESHU_REPLICA_H__
#define __LESHU_REPLICA_H__

#include "ReplicaManager3.h"
#include "RakPeerInterface.h"
#include "VariableDeltaSerializer.h"
#include "GetTime.h"
#include "Rand.h"
#include "Global.h"

using namespace RakNet;

enum topology
{
    CLIENT,
    SERVER,
    P2P
};

class LeshuReplica : public Replica3
{
public:
    // constructor and destructor
    LeshuReplica();
    ~LeshuReplica();

    virtual RakNet::RakString GetName(void) const = 0;
    void PrintStringInBitstream(RakNet::BitStream *bs);

    virtual void WriteAllocationID(
        RakNet::Connection_RM3* destinationConnection, RakNet::BitStream* allocationIdBitstream) const;

    virtual void SerializeConstruction(
        RakNet::BitStream* constructionBitstream, RakNet::Connection_RM3* destinationConnection);

    virtual bool DeserializeConstruction(
        RakNet::BitStream* constructionBitstream, RakNet::Connection_RM3* sourceConnection);

    virtual void SerializeDestruction(
        RakNet::BitStream* destructionBitstream, RakNet::Connection_RM3* destinationConnection);

    virtual bool DeserializeDestruction(
        RakNet::BitStream* destructionBitstream, RakNet::Connection_RM3* sourceConnection);

    virtual void DeallocReplica(RakNet::Connection_RM3* sourceConnection);

    // Overloaded Replica3 function
    virtual void OnUserReplicaPreSerializeTick(void);
    virtual RM3SerializationResult Serialize(RakNet::SerializeParameters* serializeParameters);
    virtual void Deserialize(RakNet::DeserializeParameters* deserializeParameters);

    virtual void SerializeConstructionRequestAccepted(
        RakNet::BitStream *serializationBitstream, RakNet::Connection_RM3 *requestingConnection);
    virtual void DeserializeConstructionRequestAccepted(
        RakNet::BitStream *serializationBitstream, RakNet::Connection_RM3 *acceptingConnection);
    virtual void SerializeConstructionRequestRejected(
        RakNet::BitStream *serializationBitstream, RakNet::Connection_RM3 *requestingConnection);
    virtual void DeserializeConstructionRequestRejected(
        RakNet::BitStream *serializationBitstream, RakNet::Connection_RM3 *rejectingConnection);

    virtual void OnPoppedConnection(RakNet::Connection_RM3 *droppedConnection);
    void NotifyReplicaOfMessageDeliveryStatus(RakNetGUID guid, uint32_t receiptId, bool messageArrived);
    void RandomizeVariables(void);

protected:
    // Demonstrate per-variable synchronization
    // We manually test each variable to the last synchronized value and only send those values that change
    int var1Unreliable;
    int var2Unreliable;
    int var3Reliable;
    int var4Reliable;

    // Class to save and compare the states of variables this Serialize() to the last Serialize()
    // If the value is different, true is written to the bitStream, followed by the value. Otherwise false is written.
    // It also tracks which variables changed which Serialize() call, so if an unreliable message was lost (ID_SND_RECEIPT_LOSS) those variables are flagged 'dirty' and resent
    VariableDeltaSerializer variableDeltaSerializer;
};

#endif
