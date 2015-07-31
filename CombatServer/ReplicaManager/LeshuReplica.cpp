#include "LeshuReplica.h"

LeshuReplica::LeshuReplica() : 
var1Unreliable(0),
var2Unreliable(0),
var3Reliable(0),
var4Reliable(0)
{

}

LeshuReplica::~LeshuReplica()
{

}

void LeshuReplica::WriteAllocationID(
    RakNet::Connection_RM3 *destinationConnection, RakNet::BitStream *allocationIdBitstream) const
{
    allocationIdBitstream->Write(GetName());
}

void LeshuReplica::PrintStringInBitstream(RakNet::BitStream *bs)
{
    if (bs->GetNumberOfBitsUsed() == 0)
        return;
    RakNet::RakString rakString;
    bs->Read(rakString);
    printf("Receive: %s\n", rakString.C_String());
}

void LeshuReplica::SerializeConstruction(
    RakNet::BitStream* constructionBitstream, RakNet::Connection_RM3* destinationConnection)
{
    // variableDeltaSerializer is a helper class that tracks what variables were sent to what remote system
    // This call adds another remote system to track
    variableDeltaSerializer.AddRemoteSystemVariableHistory(destinationConnection->GetRakNetGUID());
    constructionBitstream->Write(GetName() + RakString(" SerializeConstruction"));
}

bool LeshuReplica::DeserializeConstruction(
    RakNet::BitStream *constructionBitstream, RakNet::Connection_RM3 *sourceConnection)
{
    PrintStringInBitstream(constructionBitstream);
    return true;
}

void LeshuReplica::SerializeDestruction(
    RakNet::BitStream* destructionBitstream, RakNet::Connection_RM3* destinationConnection)
{
    // variableDeltaSerializer is a helper class that tracks what variables were sent to what remote system
    // This call removes a remote system
    variableDeltaSerializer.RemoveRemoteSystemVariableHistory(destinationConnection->GetRakNetGUID());
    destructionBitstream->Write(GetName() + RakNet::RakString(" SerializeDestruction"));
}

bool LeshuReplica::DeserializeDestruction(
    RakNet::BitStream* destructionBitstream, RakNet::Connection_RM3* sourceConnection)
{
    PrintStringInBitstream(destructionBitstream);
    return true;
}

void LeshuReplica::DeallocReplica(RakNet::Connection_RM3* sourceConnection)
{
    delete this;
}

// Overloaded Replica3 function
void LeshuReplica::OnUserReplicaPreSerializeTick(void)
{
    /// Required by VariableDeltaSerializer::BeginIdenticalSerialize()
    variableDeltaSerializer.OnPreSerializeTick();
}

RM3SerializationResult LeshuReplica::Serialize(RakNet::SerializeParameters* serializeParameters)
{
    VariableDeltaSerializer::SerializationContext serializationContext;

    // Put all variables to be sent unreliably on the same channel, then specify the send type for that channel
    serializeParameters->pro[0].reliability=UNRELIABLE_WITH_ACK_RECEIPT;
    // Sending unreliably with an ack receipt requires the receipt number, and that you inform the system of ID_SND_RECEIPT_ACKED and ID_SND_RECEIPT_LOSS
    serializeParameters->pro[0].sendReceipt = 
        replicaManager->GetRakPeerInterface()->IncrementNextSendReceipt();
    serializeParameters->messageTimestamp = RakNet::GetTime();

    // Begin writing all variables to be sent UNRELIABLE_WITH_ACK_RECEIPT 
    variableDeltaSerializer.BeginUnreliableAckedSerialize(
        &serializationContext,
        serializeParameters->destinationConnection->GetRakNetGUID(),
        &serializeParameters->outputBitstream[0],
        serializeParameters->pro[0].sendReceipt
        );
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, var1Unreliable);
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, var2Unreliable);
    // Tell the system this is the last variable to be written
    variableDeltaSerializer.EndSerialize(&serializationContext);

    // All variables to be sent using a different mode go on different channels
    serializeParameters->pro[1].reliability=RELIABLE_ORDERED;

    // Same as above, all variables to be sent with a particular reliability are sent in a batch
    // We use BeginIdenticalSerialize instead of BeginSerialize because the reliable variables have the same values sent to all systems. This is memory-saving optimization
    variableDeltaSerializer.BeginIdenticalSerialize(
        &serializationContext,
        serializeParameters->whenLastSerialized == 0,
        &serializeParameters->outputBitstream[1]
    );
    variableDeltaSerializer.SerializeVariable(&serializationContext, var3Reliable);
    variableDeltaSerializer.SerializeVariable(&serializationContext, var4Reliable);
    variableDeltaSerializer.EndSerialize(&serializationContext);

    // This return type makes is to ReplicaManager3 itself does not do a memory compare. we entirely control serialization ourselves here.
    // Use RM3SR_SERIALIZED_ALWAYS instead of RM3SR_SERIALIZED_ALWAYS_IDENTICALLY to support sending different data to different system, which is needed when using unreliable and dirty variable resends
    return RM3SR_SERIALIZED_ALWAYS;
}

void LeshuReplica::Deserialize(RakNet::DeserializeParameters* deserializeParameters)
{
    VariableDeltaSerializer::DeserializationContext deserializationContext;

    // Deserialization is written similar to serialization
    // Note that the Serialize() call above uses two different reliability types. This results in two separate Send calls
    // So Deserialize is potentially called twice from a single Serialize
    variableDeltaSerializer.BeginDeserialize(&deserializationContext, &deserializeParameters->serializationBitstream[0]);
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, var1Unreliable))
        printf("var1Unreliable changed to %i\n", var1Unreliable);
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, var2Unreliable))
        printf("var2Unreliable changed to %i\n", var2Unreliable);
    variableDeltaSerializer.EndDeserialize(&deserializationContext);

    variableDeltaSerializer.BeginDeserialize(&deserializationContext, &deserializeParameters->serializationBitstream[1]);
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, var3Reliable))
        printf("var3Reliable changed to %i\n", var3Reliable);
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, var4Reliable))
        printf("var4Reliable changed to %i\n", var4Reliable);
    variableDeltaSerializer.EndDeserialize(&deserializationContext);
}

void LeshuReplica::SerializeConstructionRequestAccepted(
    BitStream *serializationBitstream, Connection_RM3 *requestingConnection)
{
    serializationBitstream->Write(GetName() + RakNet::RakString(" SerializeConstructionRequestAccepted"));
}

void LeshuReplica::DeserializeConstructionRequestAccepted(
    BitStream *serializationBitstream, Connection_RM3 *acceptingConnection)
{
    PrintStringInBitstream(serializationBitstream);
}

void LeshuReplica::SerializeConstructionRequestRejected(
    BitStream *serializationBitstream, Connection_RM3 *requestingConnection)
{
    serializationBitstream->Write(GetName() + RakNet::RakString(" SerializeConstructionRequestRejected"));
}

void LeshuReplica::DeserializeConstructionRequestRejected(
    BitStream *serializationBitstream, Connection_RM3 *rejectingConnection)
{
    PrintStringInBitstream(serializationBitstream);
}

void LeshuReplica::OnPoppedConnection(Connection_RM3 *droppedConnection)
{
    // Same as in SerializeDestruction(), no longer track this system
    variableDeltaSerializer.RemoveRemoteSystemVariableHistory(droppedConnection->GetRakNetGUID());
}

void LeshuReplica::NotifyReplicaOfMessageDeliveryStatus(
    RakNetGUID guid, uint32_t receiptId, bool messageArrived)
{
    // When using UNRELIABLE_WITH_ACK_RECEIPT, the system tracks which variables were updated with which sends
    // So it is then necessary to inform the system of messages arriving or lost
    // Lost messages will flag each variable sent in that update as dirty, meaning the next Serialize() call will resend them with the current values
    variableDeltaSerializer.OnMessageReceipt(guid, receiptId, messageArrived);
}

void LeshuReplica::RandomizeVariables(void)
{
    if (randomMT()%2)
    {
        var1Unreliable=randomMT();
        printf("var1Unreliable changed to %i\n", var1Unreliable);
    }
    if (randomMT()%2)
    {
        var2Unreliable=randomMT();
        printf("var2Unreliable changed to %i\n", var2Unreliable);
    }
    if (randomMT()%2)
    {
        var3Reliable=randomMT();
        printf("var3Reliable changed to %i\n", var3Reliable);
    }
    if (randomMT()%2)
    {
        var4Reliable=randomMT();
        printf("var4Reliable changed to %i\n", var4Reliable);
    }
}

