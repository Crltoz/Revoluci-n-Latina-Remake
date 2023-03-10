/*
 *            DDUDB 2.2
 *       (c) Copyright 2006 by DracoBlue and Ramjet
 *
 * @version   : 2.2
 * @author    : DracoBlue (http://dracoblue.net)
 * @date      : 8th May 2006
 * @update    : 15nd Feb 2007
 * @require   : DUtils 1.6
 * @require   : DINI 1.4
 *
 * This file is provided as is (no warranties).
 *
 * Feel free to use it, a little message in 
 * about box is honouring thing, isn't it?
 *
 */

#if defined _dudb_included
  #endinput
#endif

#define _dudb_included
#pragma library dutils

#include <dutils>
#include <dini>
#define dUser(%1).( udb_User(%1,
#define dUserINT(%1).( udb_UserInt(%1,
#define dUserSet(%1).( udb_UserSet(%1,
#define dUserSetINT(%1).( udb_UserSetInt(%1,
#define dUserSetFLOAT(%1).( udb_UserSetFloat(%1,
#define dUserFLOAT(%1).( udb_UserFloat(%1,

public udb_hash(buf[]) {
    new modulus = 65521;
    new len = strlen(buf);
    new a = 0,b = 1,c = 2,d = 3;
    for (new i = 0; i < len; i++)
    {
        a = ((a + buf[i])    % modulus);
        b = ((a + b)	     % modulus);
        c = ((a + b + c)     % modulus);
        d = ((a + b + c + d) % modulus);
    }
    return ((d << 16) + (a + b + c));
}

public udb_encode(nickname[]) {
  new tmp[MAX_STRING];
  set(tmp,nickname);
  tmp=strreplace("_","_00",tmp);
  tmp=strreplace(";","_01",tmp);
  tmp=strreplace("!","_02",tmp);
  tmp=strreplace("/","_03",tmp);
  tmp=strreplace("\\","_04",tmp);
  tmp=strreplace("[","_05",tmp);
  tmp=strreplace("]","_06",tmp);
  tmp=strreplace("?","_07",tmp);
  tmp=strreplace(".","_08",tmp);
  tmp=strreplace("*","_09",tmp);
  tmp=strreplace("<","_10",tmp);
  tmp=strreplace(">","_11",tmp);
  tmp=strreplace("{","_12",tmp);
  tmp=strreplace("}","_13",tmp);
  tmp=strreplace(" ","_14",tmp);
  tmp=strreplace("\"","_15",tmp);
  tmp=strreplace(":","_16",tmp);
  tmp=strreplace("|","_17",tmp);
  tmp=strreplace("=","_18",tmp);
  return tmp;
}

public udb_decode(nickname[]) {
  new tmp[MAX_STRING];
  set(tmp,nickname);
  tmp=strreplace("_01",";",tmp);
  tmp=strreplace("_02","!",tmp);
  tmp=strreplace("_03","/",tmp);
  tmp=strreplace("_04","\\",tmp);
  tmp=strreplace("_05","[",tmp);
  tmp=strreplace("_06","]",tmp);
  tmp=strreplace("_07","?",tmp);
  tmp=strreplace("_08",".",tmp);
  tmp=strreplace("_09","*",tmp);
  tmp=strreplace("_10","<",tmp);
  tmp=strreplace("_11",">",tmp);
  tmp=strreplace("_12","{",tmp);
  tmp=strreplace("_13","}",tmp);
  tmp=strreplace("_14"," ",tmp);
  tmp=strreplace("_15","\"",tmp);
  tmp=strreplace("_16",":",tmp);
  tmp=strreplace("_17","|",tmp);
  tmp=strreplace("_18","=",tmp);
  tmp=strreplace("_00","_",tmp);
  return tmp;
}


public udb_Exists(nickname[]) {
  new tmp[MAX_STRING];
  format(tmp,sizeof(tmp),"/Usuarios/%s.ini,nickname);
  return fexist(tmp);
}


public udb_Remove(nickname[]) {
  new tmp[MAX_STRING];
  format(tmp,sizeof(tmp),"/Usuarios/%s.ini",nickname);
  return dini_Remove(tmp);
}

public udb_UserSetInt(nickname[],key[],value) {
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  return dini_IntSet(fname,key,value);
}

public udb_UserSetFloat(nickname[],key[],Float:value) {
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  return dini_FloatSet(fname,key,value);
}

public udb_UserSet(nickname[],key[],value[]) {
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  return dini_Set(fname,key,value);
}

public udb_User(nickname[],key[]) {
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  format(fname,sizeof(fname),dini_Get(fname,key));
  return fname;
}

public Float:udb_UserFloat(nickname[],key[]) {
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  return dini_Float(fname,key);
}

public udb_UserInt(nickname[],key[]) {
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  return dini_Int(fname,key);
}

public udb_CheckLogin(nickname[],pwd[]) {
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  if (udb_UserInt(nickname,"password_hash")==udb_hash(pwd)) return true;
  return false;
}


public udb_Create(nickname[],pwd[]) {
  if (udb_Exists(nickname)) return false;
  new fname[MAX_STRING];
  format(fname,sizeof(fname),"/Usuarios/%s.ini",nickname);
  dini_Create(fname);
  udb_UserSetInt(nickname,"password_hash",udb_hash(pwd));
  return true;
}
