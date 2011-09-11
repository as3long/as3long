package{
 import flash.net.*;
 import flash.display.*;
 
 public class Test extends Sprite{
  
  private var nc:NetConnection;
  
  //执行程序的入口就是as程序的构造方法
  public function Test(){
   abc();
  }
  
  private function abc():void{
   remoting();
  }
  
  private function remoting():void {
   nc=new NetConnection;

   //访问java端的地址
   nc.connect("http://360rushgame.sinaapp.com/Amfphp/");
   
   //java端的方法没有传任何参数
   nc.call("MirrorService.returnSum",new Responder(Result,Faild),145,256);
   
   //java端的方法接受一个字符串参数
   //nc.call("cn.com.zj.test.Abc.test",new Responder(Result,Faild),"hahaahh");

 

   //java端的方法接受2个参数，第一个是数字类型，第二个是字符类型
   //nc.call("cn.com.zj.test.Abc.test",new Responder(Result,Faild),123,"hahaha");


  }
  
  //传入new Responder中的第一个参数
  private function Result(result:*):void {
   trace("连接成功");
   trace(result);
   //trace(result[8].contents);
  }
  
  //传入new Responder中的第二个参数
  private function Faild(result:*):void {
   trace("连接失败");
  }
  
 }
}
