//
//  Character.cpp
//  ReplicaIOS
//
//  Created by dai tianqi on 9/3/13.
//
//

#include "Character.h"

#include "GetTime.h"
#include "RakPeerInterface.h"
#include "Rand.h"


#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT==1

#include "cocos2d_specifics.hpp"

NetworkID CharacterNetwork::_idParameters[10];
int CharacterNetwork::_intParameters[10];
float CharacterNetwork::_floatParameters[10];
bool CharacterNetwork::_boolParameters[10];

#endif

// static variable
CharacterRM3 CharacterNetwork::_characterRM3;

CharacterNetwork::CharacterNetwork() : ClientCreatibleClientReplica()
{
    _x = 0;
    _y = 0;
    _velocityX = 0;
    _velocityY = 0;
    _state = 0;
    _connected = false;
    _jsObjectCreated = false;
    
    _characterState = 0;
    _previousCharacterState = 0;
    
    _castIndex = 0;
    
    _hurtIndex = 0;
    _knockDown = false;
    _knockFly = false;
    _knockUp = false;
    
    _lastDeserializeTime = RakNet::GetTimeMS();
    _lastSerializeTime = RakNet::GetTimeMS();
    
    // Buffer up for 3 seconds if we were to get 20 updates per second
    transformationHistory.Init(kNetworkTick,3000);
}

CharacterNetwork::~CharacterNetwork()
{
    const char* id = getNetworkId();
    printf("~CharacterNetwork %s\n", id);
    
#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT == 1
    if (!_native)
    {
        jsval jsCharacterNetwork = CharacterNetwork::getNetworkObjectById(id);
        jsval networkObjects = CharacterNetwork::getNetworkObjects();
        if (jsCharacterNetwork != JSVAL_VOID)
        {
            //printf("set null\n");
            jsCharacterNetwork.setNull();
            JS_SetProperty(_cx(), &networkObjects.toObject(), id, &jsCharacterNetwork);
        }  
    }
#endif
    
}

CharacterNetwork* CharacterNetwork::createEntity()
{
    CharacterNetwork *cha = new CharacterNetwork();
    CharacterNetwork::_characterRM3.Reference(cha);
    cha->setNative(true);
    // to do: show to the scene
    printf("CharacterNetwork::createEntity temp id: %s\n", cha->getNetworkId());
    return cha;
}

CharacterNetwork* CharacterNetwork::createEntity(float x, float y)
{
    CharacterNetwork *cha = new CharacterNetwork();
    cha->setX(x);
    cha->setY(y);
    CharacterNetwork::_characterRM3.Reference(cha);
    cha->setNative(true);
    // to do: show to the scene
    printf("CharacterNetwork::createEntity temp id: %s\n", cha->getNetworkId());
    return cha;
}

CharacterNetwork* CharacterNetwork::createEntityFromNetwork()
{
    CharacterNetwork *cha = new CharacterNetwork();
    CharacterNetwork::_characterRM3.Reference(cha);
    cha->setNative(false);
    // at this moment, the network id is not real from the server, but a tempory value generate from this moment
    // only after Deserialize, the network id is the real one
    const char *id = cha->getNetworkId();
    printf("CharacterNetwork::createEntityFromNetwork temp id: %s\n", id);
    
    return cha;
}

const char* CharacterNetwork::getNetworkId()
{
    uint64_t id = GetNetworkID();
    return RakNet::RakNetGUID(id).ToString();
}

// this will be invoked every network loop
RakNet::RM3SerializationResult CharacterNetwork::Serialize(RakNet::SerializeParameters *serializeParameters)
{
    //printf("Character %llu---Serialize\n", GetNetworkID());
    RakNet::VariableDeltaSerializer::SerializationContext serializationContext;
    
    
#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT==1
    RakNet::TimeMS time = RakNet::GetTimeMS();
    //printf("Serialize: %u\n", time -_lastSerializeTime);
    _lastSerializeTime = time;
#endif
    
    // Put all variables to be sent unreliably on the same channel, then specify the send type for that channel
    serializeParameters->pro[0].reliability = RELIABLE_ORDERED;
    // Sending unreliably with an ack receipt requires the receipt number, and that you inform the system of ID_SND_RECEIPT_ACKED and ID_SND_RECEIPT_LOSS
    //serializeParameters->pro[0].sendReceipt = replicaManager->GetRakPeerInterface()->IncrementNextSendReceipt();
    serializeParameters->messageTimestamp = RakNet::GetTime();
    
    // Begin writing all variables to be sent UNRELIABLE_WITH_ACK_RECEIPT
    /*
    variableDeltaSerializer.BeginUnreliableAckedSerialize(
                                                          &serializationContext,
                                                          serializeParameters->destinationConnection->GetRakNetGUID(),
                                                          &serializeParameters->outputBitstream[0],
                                                          serializeParameters->pro[0].sendReceipt
                                                          );
    */
    
    variableDeltaSerializer.BeginIdenticalSerialize(&serializationContext,
                                                    serializeParameters->whenLastSerialized==0,
                                                    &serializeParameters->outputBitstream[0]);
    
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, _x);
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, _y);
    
    variableDeltaSerializer.SerializeVariable(&serializationContext, _velocityX);
    variableDeltaSerializer.SerializeVariable(&serializationContext, _velocityY);
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, _flipX);
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, _state);
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, _characterState);
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, _previousCharacterState);
    // Write each variable
    variableDeltaSerializer.SerializeVariable(&serializationContext, _collisionRect);
    // Tell the system this is the last variable to be written
    variableDeltaSerializer.EndSerialize(&serializationContext);
    
    /* something wrong when we do like this
     * the value of _velocityX is the value of _x
     * to do : find out why?
    // All variables to be sent using a different mode go on different channels
    serializeParameters->pro[1].reliability = RELIABLE_ORDERED;
    
    // Same as above, all variables to be sent with a particular reliability are sent in a batch
    // We use BeginIdenticalSerialize instead of BeginSerialize because the reliable variables have the same values sent to all systems. This is memory-saving optimization
    variableDeltaSerializer.BeginIdenticalSerialize(
                                                    &serializationContext,
                                                    serializeParameters->whenLastSerialized==0,
                                                    &serializeParameters->outputBitstream[1]
                                                    );
    
    variableDeltaSerializer.EndSerialize(&serializationContext);
     */
    
    // This return type makes is to ReplicaManager3 itself does not do a memory compare. we entirely control serialization ourselves here.
    // Use RM3SR_SERIALIZED_ALWAYS instead of RM3SR_SERIALIZED_ALWAYS_IDENTICALLY to support sending different data to different system, which is needed when using unreliable and dirty variable resends
    return RakNet::RM3SR_SERIALIZED_ALWAYS;
}

void CharacterNetwork::Deserialize(RakNet::DeserializeParameters *deserializeParameters)
{
    //printf("Character %llu---Deserialize\n", GetNetworkID());
    //printf("true id: %s\n", getNetworkId());
    
//#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT==1
//#ifndef ISCLIENT
    RakNet::TimeMS time = RakNet::GetTimeMS();
    //printf("Deserialize: %u\n", time -_lastDeserializeTime);
    //printf("c: %llu\n", RakNet::GetTime() - deserializeParameters->timeStamp);
    _lastDeserializeTime = time;
//#endif
    
    RakNet::VariableDeltaSerializer::DeserializationContext deserializationContext;
    
    // Deserialization is written similar to serialization
    // Note that the Serialize() call above uses two different reliability types. This results in two separate Send calls
    // So Deserialize is potentially called twice from a single Serialize
    variableDeltaSerializer.BeginDeserialize(&deserializationContext, &deserializeParameters->serializationBitstream[0]);
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _x)){
        //printf("%s _x changed to %f\n", getNetworkId(), _x);
    }
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _y)){
        //printf("%s _y changed to %f\n", getNetworkId(), _y);
    }
    
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _velocityX))
        //printf("_velocityX changed to %f\n", _velocityX);
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _velocityY))
        //printf("_velocityY changed to %f\n", _velocityY);
    
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _flipX)){
        printf("_flipX changed to %d\n", _flipX);
    }
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _state)){
        //printf("_state changed to %d\n", _state);
    }
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _characterState)){
        //printf("_characterState changed to %d\n", _characterState);
    }
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _previousCharacterState)){
        //printf("_previousCharacterState changed to %d\n", _previousCharacterState);
    }
    if (variableDeltaSerializer.DeserializeVariable(&deserializationContext, _collisionRect)){
        printf("_collisionRect changed to %f %f %f %f\n", _collisionRect.origin.x, _collisionRect.origin.y, _collisionRect.size.width, _collisionRect.size.height);
    }
    variableDeltaSerializer.EndDeserialize(&deserializationContext);
    
    /*
    variableDeltaSerializer.BeginDeserialize(&deserializationContext, &deserializeParameters->serializationBitstream[1]);
    
    variableDeltaSerializer.EndDeserialize(&deserializationContext);
    */
    
    // Every time we get a network packet, we write it to the transformation history class.
    // This class, given a time in the past, can then return to us an interpolated position of where we should be in at that time
    //transformationHistory.Write(_x, _y, _velocityX, _velocityY, _state, RakNet::GetTime());
    transformationHistory.Write(_x, _y, _velocityX, _velocityY, _state, deserializeParameters->timeStamp);
    
#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT==1
    if (!_jsObjectCreated && !_native)
    {
        // manipulate js side context`
        _jsObjectCreated = true;
        jsval networkObjects = CharacterNetwork::getNetworkObjects();
        if(networkObjects != JSVAL_VOID)
        {
            // get js object from c++ object
            js_proxy_t *proxy = js_get_or_create_proxy<CharacterNetwork>(_cx(), this);
            if (!proxy)
                printf("can't get proxy for object when createEntityFromNetwork\n");
            else
            {
                jsval jsCharacter;
                JSObject *tmpObject = proxy->obj;
                jsCharacter = OBJECT_TO_JSVAL(tmpObject);
                JS_SetProperty(_cx(), &networkObjects.toObject(), getNetworkId(), &jsCharacter);
            }
        }
    }
    // actually all game object, whether native or not, should correct property from server packet
    /* test
    else if (_jsObjectCreated && !_native)
    {
        jsval jsCharacter = CharacterNetwork::getCharacterById(getNetworkId());
        if (jsCharacter != JSVAL_VOID)
        {
            cocos2d::CCPoint point = ccp(_x, _y);
            //printf("js get d: %f %f\n", direction.x, direction.y);
            jsval jsPoint = ccpoint_to_jsval(_cx(), point);
            _sc()->executeFunctionWithOwner(jsCharacter, "setPosition", 1, &jsPoint);
        }
        
        
    }
    */
#endif
    
}

void CharacterNetwork::RandomizeVariables(void)
{
    printf("Character %llu--------RandomizeVariables\n", GetNetworkID());
    if (randomMT()%2)
    {
        _x = randomMT();
        printf("x changed to %5.2f\n", _x);
    }
    if (randomMT()%2)
    {
        _y = randomMT();
        printf("y changed to %5.2f\n", _y);
    }
    if (randomMT()%2)
    {
        _velocityX = randomMT();
        printf("_velocityX changed to %5.2f\n", _velocityX);
    }
    if (randomMT()%2)
    {
        _velocityY = randomMT();
        printf("_velocityX changed to %5.2f\n", _velocityY);
    }
    if (randomMT()%2)
    {
        _state = randomMT();
        printf("_state changed to %i\n", _state);
    }
    
    // write history
    transformationHistory.Write(_x, _y, _velocityX, _velocityY, _state, RakNet::GetTimeMS());
}

CCPoint CharacterNetwork::getInterpolatedPosition(int tick)
{
    // last cell value
    float x = _x, y = _y;
    int vx = _velocityY, vy = _velocityY, state = _state;
    TransformationHistory::ReadResult re = transformationHistory.Read(&x, &y, &vx, &vy, &state, RakNet::GetTimeMS() - tick*kSerializeTick , RakNet::GetTimeMS());
    if (re == TransformationHistory::VALUES_UNCHANGED)
        return CCPoint(-99, -99);
    return CCPoint(x,y);
}

#if defined(COCOS2D_JAVASCRIPT) && ISCLIENT == 1
void CharacterNetwork::CharacterCmd(NetworkID id, RakNet::RakString cmd, int characterState)
{
    const char* idstr = RakNet::RakNetGUID(id).ToString();
    printf("CharacterCmd %s %s\n", cmd.C_String(), idstr);
    
    jsval networkObjects = CharacterNetwork::getNetworkObjects();
    jsval jsCharacterNetwork = CharacterNetwork::getNetworkObjectById(idstr);

    if (jsCharacterNetwork != JSVAL_VOID)
    {
        jsval jsCharacter;
        JS_GetProperty(_cx(), &jsCharacterNetwork.toObject(), "delegate", &jsCharacter);
        if (jsCharacter == JSVAL_VOID)
            printf("CharacterCmd can't get js object 'NetworkObject.delegate'\n");
        else
        {
            //jsval jsState = int32_to_jsval(cx, characterState);
            //printf("js get s: %d\n", characterState);
            // update Character State first
            //sc->executeFunctionWithOwner(jsCharacter, "updateStateByIndex", 1, &jsState);
            // then execute cmd
            if (!strcmp(cmd.C_String(), "run"))
            {
                cocos2d::CCPoint direction = ccp(CharacterNetwork::_floatParameters[0], CharacterNetwork::_floatParameters[1]);
                //printf("js get d: %f %f\n", direction.x, direction.y);
                jsval jsPoint = ccpoint_to_jsval(_cx(), direction);
                _sc()->executeFunctionWithOwner(jsCharacter, cmd.C_String(), 1, &jsPoint);
            }
            else if (!strcmp(cmd.C_String(), "cast"))
            {
                jsval castIndex;
                castIndex.setInt32(CharacterNetwork::_intParameters[0]);
                _sc()->executeFunctionWithOwner(jsCharacter, cmd.C_String(), 1, &castIndex);
            }
            else if (!strcmp(cmd.C_String(), "hurt"))
            {
                NetworkID attackerId = CharacterNetwork::_idParameters[0];
                const char* attackerIdstr = RakNet::RakNetGUID(attackerId).ToString();
                
                jsval jsAttackerNetwork;
                JS_GetProperty(_cx(), &networkObjects.toObject(), attackerIdstr, &jsAttackerNetwork);
                if (jsAttackerNetwork == JSVAL_VOID)
                    printf("CharacterCmd can't get js attacker network object %s", attackerIdstr);
                else
                {
                    //CCLog("sc->hurt");
                    jsval jsAttacker = CharacterNetwork::getCharacterById(attackerIdstr);
                    JS_GetProperty(_cx(), &jsAttackerNetwork.toObject(), "delegate", &jsAttacker);
                    if (jsAttacker != JSVAL_VOID)
                    {
                        jsval knockDown;
                        knockDown.setBoolean(CharacterNetwork::_boolParameters[0]);
                        jsval knockFly;
                        knockFly.setBoolean(CharacterNetwork::_boolParameters[1]);
                        jsval knockUp;
                        knockUp.setBoolean(CharacterNetwork::_boolParameters[2]);
                        jsval hurtIndex;
                        hurtIndex.setInt32(CharacterNetwork::_intParameters[0]);
                        
                        JS_SetProperty(_cx(), &jsAttacker.toObject(), "_knockDown", &knockDown);
                        JS_SetProperty(_cx(), &jsAttacker.toObject(), "_knockFly", &knockFly);
                        JS_SetProperty(_cx(), &jsAttacker.toObject(), "_knockUp", &knockUp);
                        
                        jsval argv[2] = {
                            jsAttacker,
                            hurtIndex
                        };
                        
                        _sc()->executeFunctionWithOwner(jsCharacter, cmd.C_String(), 2, argv);
                    }
                }
            }
            // attack stop jump
            else
            {
                _sc()->executeFunctionWithOwner(jsCharacter, cmd.C_String());
            }
        }
    }

}

ScriptingCore * CharacterNetwork::_sc()
{
    return ScriptingCore::getInstance();
}

JSContext * CharacterNetwork::_cx()
{
    return ScriptingCore::getInstance()->getGlobalContext();
}

jsval CharacterNetwork::getNetworkObjects()
{
    jsval ls;
    JSObject *global = _sc()->getGlobalObject();
    //JSObject *global = sc->getDebugGlobal();
    // get global var ls
    JS_GetProperty(_cx(), global, "ls", &ls);
    if (ls == JSVAL_VOID)
        printf("CharacterCmd can't get js object 'ls'\n");
    else
    {
        jsval networkObjects;
        JS_GetProperty(_cx(), &ls.toObject(), "NetworkObjects", &networkObjects);
        
        if(networkObjects == JSVAL_VOID)
            printf("CharacterCmd can't get js object 'ls.NetworkObjects'\n");
        else
            return networkObjects;
    }
    return JSVAL_VOID;
}

jsval CharacterNetwork::getNetworkObjectById(const char* id)
{
    jsval networkObjects = CharacterNetwork::getNetworkObjects();
    ScriptingCore *sc = ScriptingCore::getInstance();
    JSContext *cx = sc->getGlobalContext();
    
    if(networkObjects != JSVAL_VOID)
    {
        jsval jsCharacterNetwork;
        JS_GetProperty(cx, &networkObjects.toObject(), id, &jsCharacterNetwork);
        if (jsCharacterNetwork == JSVAL_VOID)
            printf("can't get property %s from ls.NetworkObjects\n", id);
        else
            return jsCharacterNetwork;
    }
    return JSVAL_VOID;
}

jsval CharacterNetwork::getCharacterById(const char *id)
{
    jsval jsCharacterNetwork = CharacterNetwork::getNetworkObjectById(id);
    if (jsCharacterNetwork != JSVAL_VOID)
    {
        jsval jsCharacter;
        JS_GetProperty(_cx(), &jsCharacterNetwork.toObject(), "delegate", &jsCharacter);
        if (jsCharacter == JSVAL_VOID)
            printf("can't get js character for %s", id);
        else
            return jsCharacter;
    }
    return JSVAL_VOID;
}


#endif


