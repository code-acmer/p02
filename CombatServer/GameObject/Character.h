//
//  Character.h
//  ReplicaIOS
//
//  Created by dai tianqi on 9/3/13.
//  The class is used by both client and server
//  Make should it works on both side if you modify it
//
//

#ifndef __ReplicaIOS__Character__
#define __ReplicaIOS__Character__

#include "ReplicaManager3.h"
#include "TransformationHistory.h"
#include "StringTable.h"
#include "VariableDeltaSerializer.h"

#include "ReplicaManager/ClientCreatibleClientReplica.h"
#include "ReplicaManager/LeshuConnectionManager.h"
#include "ReplicaManager/LeshuReplicaManager.h"

#if ISCLIENT==1
#include "cocos2d.h"
using namespace cocos2d;
#else
#include "CCGeometry.h"
#endif

#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT==1
#include "jsapi.h"
#include "jsfriendapi.h"
#include "ScriptingCore.h"
#endif

class CharacterRM3;

class CharacterNetwork : public ClientCreatibleClientReplica
{
public:
    CharacterNetwork();
    virtual ~CharacterNetwork();
    // ls.Character created from client
    static CharacterNetwork* createEntity();
    static CharacterNetwork* createEntity(float x, float y);
    
    // ls.Character will be create after CharacterNetwork detected
    static CharacterNetwork* createEntityFromNetwork();
    
    // overwrite
    virtual RakNet::RakString GetName() const { return RakNet::RakString("Character"); };
    
    virtual RakNet::RM3SerializationResult Serialize(RakNet::SerializeParameters *serializeParameters);
    virtual void Deserialize(RakNet::DeserializeParameters *deserializeParameters);
    
    void RandomizeVariables(void);
    
    static CharacterRM3 _characterRM3;
    
#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT == 1
    static NetworkID _idParameters[10];
    static int _intParameters[10];
    static float _floatParameters[10];
    static bool _boolParameters[10];
    static void CharacterCmd(NetworkID id, RakNet::RakString cmd, int characterState);
#endif

    // get interpolated position
    CCPoint getInterpolatedPosition(int tick);
    
    // interface for js
    const char* getNetworkId();
        
    // member variable
    CC_SYNTHESIZE(bool, _native, Native);
    CC_SYNTHESIZE(bool, _connected, Connected);
    
    // property need replication
    CC_SYNTHESIZE(float, _x, X);
    CC_SYNTHESIZE(float, _y, Y);
    CC_SYNTHESIZE(float, _velocityX, VelocityX);
    CC_SYNTHESIZE(float, _velocityY, VelocityY);
    CC_SYNTHESIZE(float, _speed, Speed);
    CC_SYNTHESIZE(bool, _flipX, FlipX);
    
    // cast property: cast skill id
    CC_SYNTHESIZE(int, _castIndex, CastIndex);
    
    // hurt property
    CC_SYNTHESIZE(int, _hurtIndex, HurtIndex);
    CC_SYNTHESIZE(bool, _knockDown, KnockDown);
    CC_SYNTHESIZE(bool, _knockUp, KnockUp);
    CC_SYNTHESIZE(bool, _knockFly, KnockFly);
    
    // rect change by timeline
    CC_SYNTHESIZE(CCRect, _attackRect, AttackRect);
    // rect will never changed
    CC_SYNTHESIZE(CCRect, _collisionRect, CollisionRect);
    
    /*
    CC_SYNTHESIZE(float, _attackRectX, AttackRectX);
    CC_SYNTHESIZE(float, _attackRectY, AttackRectY);
    CC_SYNTHESIZE(float, _attackRectWidth, AttackRectWidth);
    CC_SYNTHESIZE(float, _attackRectHeight, AttackRectHeight);
     */
    
    CC_SYNTHESIZE(int, _state, State);
    CC_SYNTHESIZE(int, _characterState, CharacterState);
    CC_SYNTHESIZE(int, _previousCharacterState, PreviousCharacterState);
    
    CC_SYNTHESIZE(bool, _jsObjectCreated, JsObjectCreated);
    
    TransformationHistory transformationHistory;
    
private:
#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT==1
    static ScriptingCore * _sc();
    static JSContext * _cx();
    
    static jsval getNetworkObjects();
    static jsval getNetworkObjectById(const char* id);
    static jsval getCharacterById(const char* id);
#endif
    RakNet::TimeMS _lastDeserializeTime;
    RakNet::TimeMS _lastSerializeTime;

};


// One instance of Connection_RM2 is implicitly created per connection that uses ReplicaManager2. The most important function to implement is Construct() as this creates your game objects.
// It is designed this way so you can override per-connection behavior in your own game classes
class CharacterConnection : public LeshuConnectionManager
{
public:
    CharacterConnection(const SystemAddress &_systemAddress, RakNetGUID _guid) : LeshuConnectionManager(_systemAddress, _guid) {};
    
    // overwrite
	virtual RakNet::Replica3 *AllocReplica(RakNet::BitStream *allocationIdBitstream, RakNet::ReplicaManager3 *replicaManager3)
	{
		RakNet::RakString typeName;
        allocationIdBitstream->Read(typeName);
        printf("objectName: %s\n", typeName.C_String());
		if (typeName == "Character")
		{
            return CharacterNetwork::createEntityFromNetwork();
		}
		return 0;
	}
};

class CharacterRM3 : public LeshuReplicaManager
{
	// overwrite
    virtual RakNet::Connection_RM3* AllocConnection(const RakNet::SystemAddress &systemAddress, RakNet::RakNetGUID rakNetGUID) const { return new CharacterConnection(systemAddress,rakNetGUID); }
};




#endif /* defined(__ReplicaIOS__Character__) */
