//+-----------------------------------------------------------------+
//|                                      EA_MindStorms_v1.01.mq4 |
//|                                      rodolfo.leonardo@gmail.com. |
//+------------------------------------------------------------------+
#property copyright " XBEST_MindStorms_v1.01"
#property link "rodolfo.leonardo@gmail.com"
#property version "1.01"
#property description "XBEST_MindStorms_v1"
#property description "This EA is 100% FREE "
#property description "Coder: rodolfo.leonardo@gmail.com "
#property strict

extern string Version__ = "-----------------------------------------------------------------";
extern string vg_versao = "            XBEST_MindStorms_v1 2018-03-08  DEVELOPER EDITION             ";
extern string Version____ = "-----------------------------------------------------------------";

#include "EAframework.mqh"
#include "xbest.mqh"
#include "TrailingStop.mqh"

#include "SinalMA.mqh"
#include "SinalBB.mqh"
#include "SinalRSI.mqh"
#include "SinalNONLANG.mqh"

#include "FFCallNews.mqh"
#include "FilterTime.mqh"
//#include "FilterStopOut.mqh"

double vg_Spread = 0;
string vg_filters_on = "";
string vg_initpainel = false;
//+------------------------------------------------------------------+
//|  input parameters                                                |
//+------------------------------------------------------------------+

extern string Filter_Spread__ = "----------------------------Filter Max Spread----------------";
input int InpMaxvg_Spread = 24; // Max Spread

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    vg_Spread = MarketInfo(Symbol(), MODE_SPREAD) * Point;

    vg_filters_on = "";
    vg_initpainel = true;

    printf(vg_versao + " - INIT");

    XBEST_OnInit();

    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

    PainelUPER(vg_versao);
    RefreshRates();

    //FILTER SPREAD
    if (vg_Spread > InpMaxvg_Spread)
    {
        vg_filters_on += "Filter InpMaxvg_Spread ON \n";
        return;
    }

    //FILTER NEWS
    if (InpUseFFCall)
    {
        NewsHandling();

        if (vg_news_time)
        {
            vg_filters_on += "Filter News ON \n";
            return;
        }
    }

    //FILTER DATETIME
    if (InpUtilizeTimeFilter && !TimeFilter())
    {
        vg_filters_on += "Filter TimeFilter ON \n";

        return;
    }

    int Sinal = (GetSinalMA() + GetSinalBB() + GetSinalRSI() + GetSinalNONLANG()) / (DivSinalMA() + DivSinalBB() + DivSinalRSI() + DivSinalNONLANG());

    XBEST_OnTick(Sinal);

    // SE TrailingStop  ENABLE
    if (InpUseTrailingStop)
        TrailingAlls(InpTrailStart, InpTrailStep, XBEST_m_mediaprice1, XBEST_Magic);
}