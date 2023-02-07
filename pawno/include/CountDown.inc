#if defined countdown_included
	#endinput
#endif
#define countdown_included

/*
By Jovanny

native InitManagerInstance();
native StopManagerInstance();
native StartCountDown(minutos, segundos, CallBack[] = "", bool:two_callbacks=false);
native StopCountDown(countdown_id);

*/
#define MAX_COUNTS_DOWN 4000
new Started;

enum countDowns
{
	Mins,
	Secs,
	CallBackEx[32],
	bool:twocallbacks,
	bool:InUse
};

new CountDown[MAX_COUNTS_DOWN][countDowns];


stock InitManagerInstance()
{
    if(Started != 0) return 0;
    Started = SetTimer("ProcessCountDowns", 1000, 1);
    return 1;
}

stock StopManagerInstance()
{
	if(Started == 0) return 0;
	KillTimer(Started);
	Started = 0;
    return 1;
}
stock StartCountDown(minutos, segundos, CallBack[] = "", bool:two_callbacks=false)
{
    if(Started == 0) return -1;
	new e_id = -1;
	for(new i; i<MAX_COUNTS_DOWN; i++)
	{
	    if(CountDown[i][InUse] == false)
	    {
	        CountDown[i][InUse] = true;
	        CountDown[i][Mins] = minutos;
	        CountDown[i][Secs] = segundos;
			CountDown[i][twocallbacks] = two_callbacks;
			format(CountDown[i][CallBackEx], 32, "%s", CallBack);
	        
			e_id 	= i;
	        break;
	    }
	}
	return e_id;
}

stock StopCountDown(countdown_id)
{
	if(CountDown[countdown_id][InUse] == false) return 0;
	if(Started == 0) return 2;
	CountDown[countdown_id][InUse] = false;
	CountDown[countdown_id][Mins] = 0;
	CountDown[countdown_id][Secs] = 0;
	CountDown[countdown_id][twocallbacks] = false;
	format(CountDown[pid][CallBackEx], 32, "");
	return 1;
}

forward OnCountDownTick(countdown_id, minutos, segundos, stateid);

forward ProcessCountDowns();
public ProcessCountDowns()
{
    static i;
    for(new pid = 0; pid < MAX_COUNTS_DOWN; pid++)
    {
        if(CountDown[pid][Secs] == 0 && CountDown[pid][Mins] == 0) continue;
        if(CountDown[pid][Secs] == 0 && CountDown[pid][Mins] >= 1) CountDown[pid][Secs] = 60, CountDown[pid][Mins] --;
        if(CountDown[pid][Secs] >= 1) CountDown[pid][Secs]--;
        if(i == 60)
        {
            i = 0;
            if(CountDown[pid][Mins] != 0 && CountDown[pid][Secs] != 0) CountDown[pid][Secs] = 59;
        }
        
        if(CountDown[pid][Secs] == 0 && CountDown[pid][Mins] == 0)
        {
           // On Count finish
           	
			if(CountDown[pid][twocallbacks] && strlen(CountDown[pid][CallBackEx]))
			{
           		CallLocalFunction("OnCountDownTick", "dddd", pid, CountDown[pid][Mins], CountDown[pid][Secs], 0);
           		if(funcidx(CountDown[pid][CallBackEx]) != -1)CallLocalFunction(CountDown[pid][CallBackEx], "ddd", CountDown[pid][Mins], CountDown[pid][Secs], 0);
           		else
           		    printf("ERROR: El callback \'%s\' no existe", CountDown[pid][CallBackEx]);
 			}
 			else
			 	if(!CountDown[pid][twocallbacks] && strlen(CountDown[pid][CallBackEx]))
 				{
 			    	if(funcidx(CountDown[pid][CallBackEx]) != -1)CallLocalFunction(CountDown[pid][CallBackEx], "ddd", CountDown[pid][Mins], CountDown[pid][Secs], 0);
 			    	else
           		    	printf("ERROR: El callback \'%s\' no existe", CountDown[pid][CallBackEx]);
 				}
 				else
 				    CallLocalFunction("OnCountDownTick", "dddd", pid, CountDown[pid][Mins], CountDown[pid][Secs], 0);

            CountDown[pid][InUse] = false;
			CountDown[pid][Mins] = 0;
			CountDown[pid][Secs] = 0;
			CountDown[pid][twocallbacks] = false;
			format(CountDown[pid][CallBackEx], 32, "");

        }
        else
            if(CountDown[pid][twocallbacks] && strlen(CountDown[pid][CallBackEx]))
			{
           		CallLocalFunction("OnCountDownTick", "dddd", pid, CountDown[pid][Mins], CountDown[pid][Secs], 1);
           		if(funcidx(CountDown[pid][CallBackEx]) != -1)CallLocalFunction(CountDown[pid][CallBackEx], "ddd", CountDown[pid][Mins], CountDown[pid][Secs], 1);
           		else
           		    printf("ERROR: El callback \'%s\' no existe", CountDown[pid][CallBackEx]);
 			}
 			else if(!CountDown[pid][twocallbacks] && strlen(CountDown[pid][CallBackEx]))
 			{
 			    if(funcidx(CountDown[pid][CallBackEx]) != -1)CallLocalFunction(CountDown[pid][CallBackEx], "ddd", CountDown[pid][Mins], CountDown[pid][Secs], 1);
 			    else
           		    printf("ERROR: El callback \'%s\' no existe", CountDown[pid][CallBackEx]);
 			}
 			else
 			    CallLocalFunction("OnCountDownTick", "dddd", pid, CountDown[pid][Mins], CountDown[pid][Secs], 1);

        //printf("\a%02d:%02d", CountDown[pid][Mins], CountDown[pid][Secs]);
    }
    i++;
    return 1;
}