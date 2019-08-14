//+------------------------------------------------------------------+
//|                                              TradingPanel-EA.mq4 |
//|           Copyright 2019, oncetrader2018, FF Capital & Analysis. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, oncetrader2018, FF Capital & Analysis."
#property link      "https://www.mql5.com"
#property version   "2.00"
#property strict


extern double LotSize=0.01;
extern int StopLoss=280;
extern int TakeProfit=500;
extern int SL2BE=14;

int Slippage=5;



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   int x = 700;
   int y = 5;
   int x1=x+65, x2=x1+65,y1=y+35,x3=x2+45,y2=y1+35; 
     
   CreateButton("button2","Sell",x,y,60,30,White,Green,White,12);
   CreateButton("button1","Buy",x1,y,60,30,White,Maroon,White,12);
   CreateButton("button3","close All "+Symbol(),x,y1,125,30,White,Gray,White,10);
   CreateButton("button4","Clear",x2,y1,40,30,White,clrMediumAquamarine,White,10);
   CreateButton("button5","SL2BE",x3,y1,60,30,White,clrRoyalBlue,White,10);
   CreateButton("button6","清仓",x3,y2,60,30,White,clrCadetBlue,White,10);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   DeleteButtons();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
  
//按扭创建类，10个参数，CreateButton（对象名，对象内文字，基准X，基准Y，按纽宽，按钮高，文字色，填充背景色，边框色，字号）
void CreateButton(string btnName,string btnText,int &x,int &y,int w,int h,color clrText,color clrBg,color clrBorder,int fontSize)
  {
   //先（X，Y）基准坐标定位，左上角为对象的基准点锚
   ObjectCreate(0,btnName,OBJ_BUTTON,0,0,0);//无时间和价格坐标
   ObjectSetInteger(0,btnName,OBJPROP_XDISTANCE,x);//基准坐标X
   ObjectSetInteger(0,btnName,OBJPROP_YDISTANCE,y);//基准坐标Y
   ObjectSetInteger(0,btnName,OBJPROP_XSIZE,w);//按钮宽
   ObjectSetInteger(0,btnName,OBJPROP_YSIZE,h);//按钮高
   ObjectSetString(0,btnName,OBJPROP_TEXT,btnText);//按钮内文字
   ObjectSetInteger(0,btnName,OBJPROP_COLOR,clrText);//按钮内文字色
   ObjectSetInteger(0,btnName,OBJPROP_BGCOLOR,clrBg);//按钮填充背景色
   ObjectSetInteger(0,btnName,OBJPROP_BORDER_COLOR,clrBorder);//按钮边框色
   ObjectSetInteger(0,btnName,OBJPROP_BORDER_TYPE,BORDER_FLAT);//按钮边样式
   ObjectSetInteger(0,btnName,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,btnName,OBJPROP_STATE,false);//按钮状态,不按下
   ObjectSetInteger(0,btnName,OBJPROP_FONTSIZE,fontSize);//按钮内字号
   //x=x+w+10;
  }

void DeleteButtons()//EA退出后删除所有对象
  {
   for(int i=ObjectsTotal()-1; i>-1; i--)
     {
      if(StringFind(ObjectName(i),"button")>=0) ObjectDelete(ObjectName(i));
     }
  }  
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
//OnChartEvent传入不同类型参数做为通信连接
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
      if(sparam=="button1") // Buy
        {
         Action_Button1();
         ObjectSetInteger(0,"button1",OBJPROP_STATE,false);//按钮状态改变，不按下
         ObjectSetInteger(0,"button1",OBJPROP_BGCOLOR,clrDodgerBlue);//按钮填充背景色
         Sleep(400);
         ObjectSetInteger(0,"button1",OBJPROP_BGCOLOR,Green);//按钮填充背景色         
        }
        
      else if(sparam=="button2") // Sell
        {
         Action_Button2();
         ObjectSetInteger(0,"button2",OBJPROP_STATE,false);//按钮状态改变，不按下
         ObjectSetInteger(0,"button2",OBJPROP_BGCOLOR,clrDodgerBlue);//按钮填充背景色
         Sleep(400);
         ObjectSetInteger(0,"button2",OBJPROP_BGCOLOR,Maroon);//按钮填充背景色         
        }
      else if(sparam=="button3") // Close all
        {
         Action_Button3();
         ObjectSetInteger(0,"button3",OBJPROP_STATE,false);//按钮状态改变，不按下
         ObjectSetInteger(0,"button3",OBJPROP_BGCOLOR,clrDodgerBlue);//按钮填充背景色
         Sleep(400);
         ObjectSetInteger(0,"button3",OBJPROP_BGCOLOR,Gray);//按钮填充背景色  
        }  
      else if(sparam=="button4") // 清屏
        {
         ObjectsDeleteAll(0);
         ObjectSetInteger(0,"button3",OBJPROP_BGCOLOR,Gray);//按钮填充背景色 
         Sleep(400);
         OnInit();
        } 
      else if(sparam=="button5") // SL2BE
        {
         ObjectSetInteger(0,"button5",OBJPROP_STATE,false);//按钮状态改变，不按下
         ObjectSetInteger(0,"button5",OBJPROP_BGCOLOR,clrDodgerBlue);//按钮填充背景色
         SL2BE_set();
         Sleep(400);
         ObjectSetInteger(0,"button5",OBJPROP_BGCOLOR,clrRoyalBlue);//按钮填充背景色
        }
      else if(sparam=="button6") // 清仓
        {
         ObjectSetInteger(0,"button6",OBJPROP_STATE,false);//按钮状态改变，不按下
         ObjectSetInteger(0,"button6",OBJPROP_BGCOLOR,clrDodgerBlue);//按钮填充背景色
         CloseAllSymbol_Orders();
         Sleep(400);
         ObjectSetInteger(0,"button6",OBJPROP_BGCOLOR,clrCadetBlue);//按钮填充背景色
        }  
  }
//+------------------------------------------------------------------+
void Action_Button1(){
   {
      OrderBuy();
      PlaySound("ok.wav");
   }
}

void OrderBuy(){
   int ticket;
      for(int i=0;i<3;i++)
      {
         ticket=OrderSend(Symbol(),OP_BUY,LotSize,Ask,Slippage,Ask-StopLoss*Point,Ask+TakeProfit*Point, "QQ3084684467-"+TimeToStr(TimeLocal(),TIME_SECONDS)+"-Buy");
         if(ticket>0){break;}    
         RefreshRates();     
      }
}

void Action_Button2(){
   {
      OrderSell();
      PlaySound("ok.wav");
   }
}

void OrderSell(){
int ticket;
   for(int i=0;i<3;i++)
   {
      ticket=OrderSend(Symbol(),OP_SELL,LotSize,Bid,Slippage,Bid+StopLoss*Point,Bid-TakeProfit*Point,"QQ3084684467-"+TimeToStr(TimeLocal(),TIME_SECONDS)+"-Sell");
      if(ticket>0){break;}    
      RefreshRates();     
   }
}

void Action_Button3(){
   {
      CloseAll();
      PlaySound("ok.wav");
   }
}

//特定品种全平
int CloseAll() {

     int total = OrdersTotal();

     bool ticket = false;
     
     for(int i=total-1;i>=0;i--)
     {
       ticket = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
       int type   = OrderType();
       bool closed = false;
       
       switch(type)
       {
         //Close opened long positions
         case OP_BUY       : if ( Symbol() == OrderSymbol()) closed = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 1, CLR_NONE);
                             break;
         
         //Close opened short positions
         case OP_SELL      : if ( Symbol() == OrderSymbol()) closed = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 1, CLR_NONE);
                             
       }  
     }  
  return(0);
}

//推保护
int SL2BE_set(){

   double digits   = MarketInfo(Symbol(),MODE_DIGITS);

   for(int i=OrdersTotal()-1;i>=0;i--)
   {
   
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=Symbol())
         continue;
      
      RefreshRates();
      
      if(OrderType()==OP_BUY) //多单推保护
        bool res= OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL2BE*Point,OrderTakeProfit(),OrderExpiration());
      
      if(OrderType()==OP_SELL) //空单推保护
        bool res= OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL2BE*Point,OrderTakeProfit(),OrderExpiration());      
      
      if(((OrderType()==OP_BUYSTOP) || (OrderType()==OP_BUYLIMIT)))
        bool res= OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL2BE*Point,OrderOpenPrice(),OrderExpiration());   
      
      if(((OrderType()==OP_SELLSTOP) || (OrderType()==OP_SELLLIMIT)))
        bool res= OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL2BE*Point,OrderOpenPrice(),OrderExpiration());
   }   
   return(0);
}


//清仓
int CloseAllSymbol_Orders() {

     int total = OrdersTotal();

     bool ticket = false;
     
     for(int i=total-1;i>=0;i--)
     {
       ticket = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
       int type   = OrderType();
       bool closed = false;
       
       switch(type)
       {
         //Close opened long positions
         case OP_BUY       : closed = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 1, CLR_NONE);
                             break;
         
         //Close opened short positions
         case OP_SELL      : closed = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 1, CLR_NONE);
                             
       }  
     }  
  return(0);
}
