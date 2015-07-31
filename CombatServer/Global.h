//
//  Global.h
//  server
//
//  Created by dai tianqi on 9/4/13.
//  Copyright (c) 2013 dai tianqi. All rights reserved.
//

#ifndef server_Global_h
#define server_Global_h

// for js binding
//#define ISCLIENT 1

#if defined(ISCLIENT) && ISCLIENT == 1
#define G_IsClient true
#else
#define G_IsClient false
#endif

#define kServerPort 12345

#define kNetwork 1
#define kNetworkTick 50
#define kSerializeTick 100

#define kCommandChannel 'c'
#define kHurtChannel 'h'

#endif


/** CC_SYNTHESIZE is used to declare a protected variable.
 We can use getter to read the variable, and use the setter to change the variable.
 @param varType : the type of variable.
 @param varName : variable name.
 @param funName : "get + funName" is the name of the getter.
 "set + funName" is the name of the setter.
 @warning : The getter and setter are public  inline functions.
 The variables and methods declared after CC_SYNTHESIZE are all public.
 If you need protected or private, please declare.
 */
#define CC_SYNTHESIZE(varType, varName, funName)\
protected: varType varName;\
public: virtual varType get##funName(void) const { return varName; }\
public: virtual void set##funName(varType var){ varName = var; }
