// Demonstrates ReplicaManager 3: A system to automatically create, destroy, and serialize objects

#include "StringTable.h"

#include <stdio.h>
#include "Kbhit.h"
#include <string.h>
#include "MessageIdentifiers.h"
#include "NetworkIDManager.h"
#include "RakSleep.h"
#include "FormatString.h"
#include "RakString.h"
#include "GetTime.h"
#include "SocketLayer.h"
#include "Getche.h"
#include "RakPeerInterface.h"
#include "ReplicaManager/LeshuReplica.h"
#include "ReplicaManager/LeshuReplicaManager.h"
#include "ReplicaManager/ClientCreatibleClientReplica.h"
#include "ReplicaManager/ClientCreatibleServerReplica.h"
#include "ReplicaManager/ServerCreatedClientReplica.h"
#include "ReplicaManager/ServerCreatedServerReplica.h"
#include "ReplicaManager/P2PReplica.h"

#include "GameObject/Character.h"

#include "Gets.h"


// ReplicaManager3 is in the namespace RakNet
using namespace RakNet;

unsigned char GetPacketIdentifier(RakNet::Packet *p);

int main(void)
{
    char ch;
    RakNet::SocketDescriptor sd;
    // Only IPV4 supports broadcast on 255.255.255.255
    sd.socketFamily = AF_INET;
    // char ip[128];
    static const int SERVER_PORT = kServerPort;
    topology _topo;

    // ReplicaManager3 requires NetworkIDManager to lookup pointers from numbers.
    NetworkIDManager networkIdManager;
    // Each application has one instance of RakPeerInterface
    RakNet::RakPeerInterface *rakPeer;
    
    // The system that performs most of our functionality for this demo
    LeshuReplicaManager replicaManager;

    printf("Demonstration of ReplicaManager3.\n");
    printf("1. Demonstrates creating objects created by the server and client.\n");
    printf("2. Demonstrates automatic serialization data members\n");
    printf("Difficulty: Intermediate\n\n");

    
    rakPeer = RakNet::RakPeerInterface::GetInstance();
 
    //printf("Start as (p)eer? \n");
 
//    ch = getche();
//	
//    if (ch=='p' || ch == 'P')
//	{
//		printf("I'm a peer!\n");
//        _topo=P2P;
//		sd.port=SERVER_PORT;
//		while (IRNS2_Berkley::IsPortInUse(sd.port,sd.hostAddress,sd.socketFamily, SOCK_DGRAM)==true)
//			sd.port++;
//	}
//    else
    
    if (G_IsClient)
    {
        printf("I'm a client!\n");
        _topo=CLIENT;
        //Character::_isServer = false;
		sd.port=0;
    }
    else
    {
        printf("I'm a server!\n");
        _topo=SERVER;
        //Character::_isServer = true;
		sd.port=SERVER_PORT;
    }
    
    

    // Start RakNet, up to 32 connections if the server
    rakPeer->SetTimeoutTime(15000, RakNet::UNASSIGNED_SYSTEM_ADDRESS);
    rakPeer->Startup(32, &sd, 1);
    rakPeer->AttachPlugin(&replicaManager);
    replicaManager.SetNetworkIDManager(&networkIdManager);
    
    rakPeer->AttachPlugin(&CharacterNetwork::_characterRM3);
    CharacterNetwork::_characterRM3.SetNetworkIDManager(&networkIdManager);
    CharacterNetwork::_characterRM3.SetAutoSerializeInterval(kSerializeTick);
    
    rakPeer->SetMaximumIncomingConnections(32);
    rakPeer->SetOccasionalPing(true);
    printf("\nMy GUID is %s\n", rakPeer->GetMyGUID().ToString());
    printf("Commands:\n(Q)uit\n'C'reate objects\n'R'andomly change variables in my objects\n'D'estroy my objects\n");
    
    printf("\n");
    char ip[128];
	if (_topo == CLIENT)
	{
		printf("Enter server IP: ");
		Gets(ip, sizeof(ip));
		if (ip[0] == 0)
			strcpy(ip, "127.0.0.1");
		rakPeer->Connect(ip,SERVER_PORT,0,0,0);
		printf("Connecting...\n");
	}
    
	printf("Commands:\n(Q)uit\n'C'reate objects\n'R'andomly change variables in my objects\n'D'estroy my objects\n");

    // Enter infinite loop to run the system
    RakNet::Packet *packet;
    bool quit = false;
    // GetPacketIdentifier returns this
    unsigned char packetIdentifier;
    while (!quit)
    {
        for (packet = rakPeer->Receive(); packet; rakPeer->DeallocatePacket(packet), packet = rakPeer->Receive())
        {
            packetIdentifier = GetPacketIdentifier(packet);
            switch (packetIdentifier)
            {
                case ID_CONNECTION_ATTEMPT_FAILED:
                    printf("ID_CONNECTION_ATTEMPT_FAILED\n");
                    quit = true;
                    break;
                case ID_NO_FREE_INCOMING_CONNECTIONS:
                    printf("ID_NO_FREE_INCOMING_CONNECTIONS\n");
                    quit = true;
                    break;
                case ID_CONNECTION_REQUEST_ACCEPTED:
                    printf("ID_CONNECTION_REQUEST_ACCEPTED\n");
                    break;
                case ID_NEW_INCOMING_CONNECTION:
                    printf("ID_NEW_INCOMING_CONNECTION from %s\n", packet->systemAddress.ToString());
                    break;
                case ID_DISCONNECTION_NOTIFICATION:
                {
                    printf("ID_DISCONNECTION_NOTIFICATION\n");
                    RakNet::BitStream myBitStream;
                    MessageID typeId = ID_PLAYER_DISCONNECT;
                    myBitStream.Write(typeId);
                    myBitStream.Write(packet->guid);
                    
                    rakPeer->Send(&myBitStream, HIGH_PRIORITY, RELIABLE_ORDERED, 'c', AddressOrGUID(RakNet::RakNetGUID(packet->guid)), true);
                    
                    break;
                }
                case ID_CONNECTION_LOST:
                {
                    printf("ID_CONNECTION_LOST %s %s\n", packet->systemAddress.ToString(), packet->guid.ToString());
                    
                    RakNet::BitStream myBitStream;
                    MessageID typeId = ID_PLAYER_DISCONNECT;
                    myBitStream.Write(typeId);
                    myBitStream.Write(packet->guid);
                    
                    rakPeer->Send(&myBitStream, HIGH_PRIORITY, RELIABLE_ORDERED, 'c', AddressOrGUID(RakNet::RakNetGUID(packet->guid)), true);
                    
                    /* no use because the replica3 objects has already been deleted by now
                    DataStructures::List<Replica3*> replicaListOut;
                    // The reason for ClearPointers is that in the sample, I don't track which objects have and have not been allocated at the application level. So ClearPointers will call delete on every object in the returned list, which is every object that the application has created. Another way to put it is
                    // 	A. Send a packet to tell other systems to delete these objects
                    // 	B. Delete these objects on my own system
                    replicaManager.GetReplicasCreatedByGuid(packet->guid, replicaListOut);
                    replicaManager.BroadcastDestructionList(replicaListOut, RakNet::UNASSIGNED_SYSTEM_ADDRESS);
                    printf("delete list size %d\n", replicaListOut.Size());
                    for (unsigned int i=0; i < replicaListOut.Size(); i++)
                        RakNet::OP_DELETE(replicaListOut[i], _FILE_AND_LINE_);
                    
                    // characters
                    CharacterNetwork::_characterRM3.GetReplicasCreatedByGuid(packet->guid, replicaListOut);
                    CharacterNetwork::_characterRM3.BroadcastDestructionList(replicaListOut, RakNet::UNASSIGNED_SYSTEM_ADDRESS);
                    printf("delete list size %d\n", replicaListOut.Size());
                    for (unsigned int i=0; i < replicaListOut.Size(); i++)
                        RakNet::OP_DELETE(replicaListOut[i], _FILE_AND_LINE_);
                    
                    */
                    // to do: delete all game object created by this client
                    break;
                }
                case ID_ADVERTISE_SYSTEM:
                    // The first conditional is needed because ID_ADVERTISE_SYSTEM may be from a system we are connected to, but replying on a different address.
                    // The second conditional is because AdvertiseSystem also sends to the loopback
                    if (rakPeer->GetSystemAddressFromGuid(packet->guid) == RakNet::UNASSIGNED_SYSTEM_ADDRESS &&
                        rakPeer->GetMyGUID() != packet->guid)
                    {
                        printf("Connecting to %s\n", packet->systemAddress.ToString(true));
                        rakPeer->Connect(packet->systemAddress.ToString(false), packet->systemAddress.GetPort(),0,0);
                    }
                    break;
                case ID_SND_RECEIPT_LOSS:
                case ID_SND_RECEIPT_ACKED:
                {
                    uint32_t msgNumber;
                    memcpy(&msgNumber, packet->data+1, 4);

                    DataStructures::List<Replica3*> replicaListOut;
                    replicaManager.GetReplicasCreatedByMe(replicaListOut);
                    unsigned int idx;
                    for (idx=0; idx < replicaListOut.Size(); idx++)
                    {
                        ((LeshuReplica*)replicaListOut[idx])->NotifyReplicaOfMessageDeliveryStatus(packet->guid,msgNumber, packet->data[0]==ID_SND_RECEIPT_ACKED);
                    }
                    
                    CharacterNetwork::_characterRM3.GetReplicasCreatedByMe(replicaListOut);
                    for (idx=0; idx < replicaListOut.Size(); idx++)
                    {
                        ((CharacterNetwork*)replicaListOut[idx])->NotifyReplicaOfMessageDeliveryStatus(packet->guid,msgNumber, packet->data[0]==ID_SND_RECEIPT_ACKED);
                    }
                    break;
                }
                case ID_CHARACTER_CMD:
                {
                    MessageID useTimeStamp; // Assign this to ID_TIMESTAMP
                    RakNet::Time timeStamp; // Put the system time in here returned by RakNet::GetTime()
                    MessageID typeId;
                    BitStream receiveBitStream(packet->data, packet->length, false);
                    receiveBitStream.Read(useTimeStamp);
                    receiveBitStream.Read(timeStamp);
                    receiveBitStream.Read(typeId);
                    
                    RakNet::RakString cmdStr;
                    receiveBitStream.Read(cmdStr);
                    
                    NetworkID characterId;
                    receiveBitStream.Read(characterId);
                    
                    NetworkID clientId;
                    receiveBitStream.Read(clientId);
                    
                    int characterState;
                    receiveBitStream.Read(characterState);
                    
                    printf("%s c %s cmd: %s\n", RakNet::RakNetGUID(clientId).ToString(), RakNet::RakNetGUID(characterId).ToString(), cmdStr.C_String());
                    
                    if (_topo == SERVER)
                    {
                        // if we use UNRELIABLE_SEQUENCED mode to send these cmd, we need to seprerate 'hurt' in a different channel because if a 'hurt' arrive before an 'attack' which caused that 'hurt', the 'attack' will be ignored
                        if (!strcmp(cmdStr.C_String(), "run") ||
                            !strcmp(cmdStr.C_String(), "stop") ||
                            !strcmp(cmdStr.C_String(), "attack") ||
                            !strcmp(cmdStr.C_String(), "cast") ||
                            !strcmp(cmdStr.C_String(), "jump")
                            )
                        {
                            // send to all except the native one
                            // native: character is created from client, not from replication
                            rakPeer->Send(&receiveBitStream, HIGH_PRIORITY, RELIABLE_ORDERED, kCommandChannel, AddressOrGUID(RakNet::RakNetGUID(clientId)), true);
                        }
                        else if (!strcmp(cmdStr.C_String(), "hurt"))
                        {
                            NetworkID attackerId;
                            receiveBitStream.Read(attackerId);
                            // attacker property
                            int hurtIndex;
                            bool knockDown;
                            bool knockFly;
                            bool knockUp;
                            receiveBitStream.Read(hurtIndex);
                            receiveBitStream.Read(knockDown);
                            receiveBitStream.Read(knockFly);
                            receiveBitStream.Read(knockUp);
                            // collision detection
                            CCRect attackRect;
                            receiveBitStream.Read(attackRect);
                            
                            CharacterNetwork *attacker = (CharacterNetwork *)CharacterNetwork::_characterRM3.GetReplicaByNetworkID(attackerId, 0);
                            if (attacker->getFlipX())
                                attackRect.origin.x = 0 - attackRect.origin.x - attackRect.size.width;
                            
                            attackRect.origin.x += attacker->getX();
                            attackRect.origin.y += attacker->getY();
                            
                            DataStructures::List<Replica3*> replicaListOut;
                            CharacterNetwork::_characterRM3.GetReferencedReplicaList(replicaListOut);
                            unsigned int idx;
                            for (idx = 0; idx < replicaListOut.Size(); idx++)
                            {
                                CharacterNetwork *defender = (CharacterNetwork*)replicaListOut[idx];
                                if (defender->GetNetworkID() != attackerId)
                                {
                                    CCRect collisionRect = defender->getCollisionRect();
                                    // Lag compensation
                                    float packetLatency = 200/kSerializeTick;
                                    CCPoint position = defender->getInterpolatedPosition(2+packetLatency);
                                    collisionRect.origin.x += position.x;
                                    collisionRect.origin.y += position.y;
                                    if (attackRect.intersectsRect(collisionRect))
                                    {
                                        
                                        BitStream sendBitStream;
                                        sendBitStream.Write(useTimeStamp);
                                        sendBitStream.Write(timeStamp);
                                        sendBitStream.Write(typeId);
                                        sendBitStream.Write(cmdStr);
                                        sendBitStream.Write(defender->GetNetworkID()); // In the struct this is NetworkID networkId
                                        sendBitStream.Write(rakPeer->GetMyGUID());
                                        sendBitStream.Write(defender->getPreviousCharacterState());
                                        
                                        // attacker info
                                        sendBitStream.Write(attacker->GetNetworkID());
                                        sendBitStream.Write(hurtIndex);
                                        sendBitStream.Write(knockDown);
                                        sendBitStream.Write(knockFly);
                                        sendBitStream.Write(knockUp);
                                        
                                        // send to all
                                        rakPeer->Send(&sendBitStream, HIGH_PRIORITY, RELIABLE_ORDERED, kHurtChannel, UNASSIGNED_SYSTEM_ADDRESS, true);
                                    }
                                }
                            }
                            
                            
                            // send to all
                            /*
                            rakPeer->Send(&myBitStream, HIGH_PRIORITY, RELIABLE_ORDERED, kHurtChannel, UNASSIGNED_SYSTEM_ADDRESS, true);
                            */
                        }
                    }
                    break;
                }
                default:
                    break;
                    
                break;
            }
        }

        if (kbhit())
        {
            ch=getch();
            if (ch=='q' || ch=='Q')
            {
                printf("Quitting.\n");
                quit=true;
            }
            if (ch=='c' || ch=='C')
            {
                printf("Objects created.\n");
                if (_topo == SERVER || _topo == CLIENT)
                {
                    CharacterNetwork::createEntity();
                    //replicaManager.Reference(new ClientCreatibleClientReplica);
                    //replicaManager.Reference(new ServerCreatedClientReplica);
                    //replicaManager.Reference(new ClientCreatibleServerReplica);
                    //replicaManager.Reference(new ServerCreatedServerReplica);
                }
                else
                {
                    //	for (int i=0; i < 20; i++)
                    replicaManager.Reference(new P2PReplica);
                }
            }
            if (ch=='r' || ch=='R')
            {
                DataStructures::List<Replica3*> replicaListOut;
                replicaManager.GetReplicasCreatedByMe(replicaListOut);
                unsigned int idx;
                for (idx=0; idx < replicaListOut.Size(); idx++)
                {
                    ((LeshuReplica*)replicaListOut[idx])->RandomizeVariables();
                }
                
                // characters
                CharacterNetwork::_characterRM3.GetReplicasCreatedByMe(replicaListOut);
                for (idx=0; idx < replicaListOut.Size(); idx++)
                {
                    ((CharacterNetwork*)replicaListOut[idx])->RandomizeVariables();
                }
            }
            if (ch=='d' || ch=='D')
            {
                printf("My objects destroyed.\n");
                DataStructures::List<Replica3*> replicaListOut;
                // The reason for ClearPointers is that in the sample, I don't track which objects have and have not been allocated at the application level. So ClearPointers will call delete on every object in the returned list, which is every object that the application has created. Another way to put it is
                // 	A. Send a packet to tell other systems to delete these objects
                // 	B. Delete these objects on my own system
                replicaManager.GetReplicasCreatedByMe(replicaListOut);
                replicaManager.BroadcastDestructionList(replicaListOut, RakNet::UNASSIGNED_SYSTEM_ADDRESS);
                for (unsigned int i=0; i < replicaListOut.Size(); i++)
                    RakNet::OP_DELETE(replicaListOut[i], _FILE_AND_LINE_);
                
                // characters
                //CharacterNetwork::_characterRM3.Clear();
                ///*
                CharacterNetwork::_characterRM3.GetReplicasCreatedByMe(replicaListOut);
                CharacterNetwork::_characterRM3.BroadcastDestructionList(replicaListOut, RakNet::UNASSIGNED_SYSTEM_ADDRESS);
                for (unsigned int i=0; i < replicaListOut.Size(); i++)
                    RakNet::OP_DELETE(replicaListOut[i], _FILE_AND_LINE_);
                //*/
            }

        }

        // 20 tick for a second
        RakSleep(kNetworkTick);
        for (int i=0; i < 4; i++)
        {
            if (rakPeer->GetInternalID(RakNet::UNASSIGNED_SYSTEM_ADDRESS,0).GetPort()!=SERVER_PORT+i)
                rakPeer->AdvertiseSystem("255.255.255.255", SERVER_PORT+i, 0,0,0);
        }
    }

    rakPeer->Shutdown(100,0);
    RakNet::RakPeerInterface::DestroyInstance(rakPeer);
}

// If the first byte is ID_TIMESTAMP, then we want the 5th byte
// Otherwise we want the 1st byte
unsigned char GetPacketIdentifier(RakNet::Packet *p)
{
	if (p == 0)
		return 255;
    
	if ((unsigned char)p->data[0] == ID_TIMESTAMP)
	{
		RakAssert(p->length > sizeof(RakNet::MessageID) + sizeof(RakNet::Time));
		return (unsigned char) p->data[sizeof(RakNet::MessageID) + sizeof(RakNet::Time)];
	}
	else
		return (unsigned char) p->data[0];
}
