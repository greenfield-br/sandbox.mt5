#include <Trade\Trade.mqh>
CTrade trade;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
    double bid, ask;
    double smaArray[];
    int smaHandle;

    bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   
    smaHandle = iMA(_Symbol, _Period, 20, 0, MODE_SMA, PRICE_CLOSE);
    ArraySetAsSeries(smaArray, true);
    CopyBuffer(smaHandle, 0, 0, 3, smaArray);
   
    if (bid > smaArray[0] && PositionsTotal()==0)
        {
            Comment("Buy");
            trade.Buy(0.01, _Symbol, ask, ask*0.99, ask*1.05, "Buying");
            trade.Buy
        }
    else if (ask < smaArray[0])
        {
            Comment("No Buy");
        }
  }
//+------------------------------------------------------------------+
