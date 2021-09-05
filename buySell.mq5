#include <Trade\Trade.mqh>

input int intPeriodMA = 20; //moving average period.
input ENUM_MA_METHOD enumMethodMA = MODE_LWMA; //moving average method.

CTrade trade;
MqlTick lastTick;
MqlRates lastCandle[];

double bid, ask;
double smaArray[];
int smaHandle;


int OnInit()
  {
   
    trade.SetExpertMagicNumber(1001); // 1 = greenfield 0 = sandbox 0 = education 1 = version
    trade.SetTypeFilling(ORDER_FILLING_RETURN);
   
    if(!ArraySetAsSeries(lastCandle, true))
        {
            Print("Error ", GetLastError());
            return (INIT_FAILED);
        }
   
    smaHandle = iMA(_Symbol, _Period, intPeriodMA, 0, enumMethodMA, PRICE_CLOSE);
    if (smaHandle==INVALID_HANDLE)
        {
            Print("Error ", GetLastError());
            return (INIT_FAILED);
        }
   
    if(!ArraySetAsSeries(smaArray, true))
        {
            Print("Error ", GetLastError());
        }

    return (INIT_SUCCEEDED);
  }


void OnTick()
  {
//---

    if(!SymbolInfoTick(_Symbol, lastTick))
        {
            Alert("Error ", GetLastError());
            return;
        }

    if(CopyRates(_Symbol, _Period, 0, 3, lastCandle)<0)
        {
            Alert("Error ", GetLastError());
            return;
        }
   
    if (CopyBuffer(smaHandle, 0, 0, 3, smaArray)<0)
        {
        Print("Error ", GetLastError());
        return;
        }
   
    if (lastTick.last > smaArray[0] && lastCandle[1].close > lastCandle[1].open && PositionsTotal()==0)
        {
            Comment("Buy");
            if (trade.Buy(0.01, _Symbol, lastTick.ask, lastTick.ask*0.99, lastTick.ask*1.05, "Buying"))
                {
                    Print("Error", GetLastError());
                }
            else
                {
                    Print("Order Succeeded.");
                }
        }
    else if (lastTick.last < smaArray[0])
        {
            Comment("No Buy");
        }
  }
//+------------------------------------------------------------------+

