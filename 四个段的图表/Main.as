/**
 * 2010年7月7日 13:29:47
 * 入口函数
 */
package 
{
	import com.greensock.TweenMax;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import mx.rpc.events.FaultEvent;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class Main extends Sprite 
	{
		private var _tubiao:tubiao;
		private var mouseFirstX:Number;
		private var changhuakuai_mouseX:Number;
		private var zhezhaoX:Number;
		private var isMove:Boolean = false;
		private var isQiehuan:Boolean = false;
		private var zhuArray:Array = new Array();
		private var dataArray:Array;
		/**
		 * 用于存放线的高度
		 */
		private var lineHeight:Number;
		private var tool:toolLabel = new toolLabel();
		/**
		 * 字体数组
		 */
		private var fontArray:Array;
		
		private var _loadData:loadData;
		/**
		 * 是否是增加的
		 */
		private var isAdd:Boolean
		
		private var loader:URLLoader;
		
		private	var dataValue:String;
		private	var dataTime:String;
		private var max0:Number;
		private	var max1:Number;
		private	var max2:Number;
		private	var max3:Number;
		private var max4:Number;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			hl_init();
		}
		private function hl_init():void {
			_tubiao = new tubiao();
			this.addChild(_tubiao);
			_tubiao.qiehuan.textColor = 0x0000FF;
			//trace(dataArray.length);
			createData();
			if (root.loaderInfo.parameters["name"])
			{
			_tubiao.title.text = root.loaderInfo.parameters["name"];
			}
			else
			{
				_tubiao.title.text = "血液黏度";
			}
			_tubiao.changhuakuai.addEventListener(MouseEvent.MOUSE_DOWN, huakuai_MouseEvent);
			this.addEventListener(MouseEvent.MOUSE_UP, allMouseEvent);
			this.addEventListener(Event.ENTER_FRAME, zhixing);
			_tubiao.line_mc.visible = false;
			_tubiao.qiehuan.addEventListener(MouseEvent.CLICK, qiehuan_click);
			tool.alpha = 0;
			var s:ColorTransform = new ColorTransform();
			var m:uint = 0x0080FF;
			s.color = m;
			tool.label.transform.colorTransform = s;
			this.addChild(tool);
			_tubiao.zuo_btn.addEventListener(MouseEvent.CLICK, zuo_btn_Click);
			_tubiao.you_btn.addEventListener(MouseEvent.CLICK, you_btn_Click);
			var loader:Loader = new Loader();
			//加载字体库
			loader.load(new URLRequest('fontlib.swf'));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,lc);
		}
		private  function lc(event:Event):void {
			fontArray = Font.enumerateFonts();
			//trace(fontArray[1].fontName);
			_tubiao.title.defaultTextFormat.font = fontArray[1].fontName;
			_tubiao.qiehuan.defaultTextFormat.font = fontArray[1].fontName;
			_tubiao.qiehuan.antiAliasType = AntiAliasType.ADVANCED;
			_tubiao.title.antiAliasType = AntiAliasType.ADVANCED;
			}
		private function allMouseEvent(event:Event):void
		{
			isMove = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE, huakuai_MouseEvent);
		}
		
		private function huakuai_MouseEvent(event:Event):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
				this.addEventListener(MouseEvent.MOUSE_MOVE, huakuai_MouseEvent);
				mouseFirstX = this.mouseX;
				changhuakuai_mouseX = _tubiao.changhuakuai.x;
				zhezhaoX = _tubiao.zhezhao_mc.x;
						break;
				case MouseEvent.MOUSE_MOVE:
								isMove = true;
						break;
				default:
						break;
			}
		}
		
		private function shijian_txt_init(dataArray:Array):void
			{
				if (dataArray.length < 17)
				{
					_tubiao.changhuakuai.visible = false;
				}
				else
				{
				_tubiao.changhuakuai.kuai.width = 465 / dataArray.length * 500/30;
				_tubiao.changhuakuai.tiao.x = _tubiao.changhuakuai.kuai.x + _tubiao.changhuakuai.kuai.width * 0.5-_tubiao.changhuakuai.tiao.width*0.5;
				}
				_tubiao.line_mc.graphics.lineStyle(0, 0xFF8000);
				_tubiao.line_mc.graphics.moveTo(20, 100-dataArray[0].gaodu);
				for (var i:int = 0; i<dataArray.length; i++ )
				{
					var a:shijian_txt = new shijian_txt();
					a.x = 10+30 * i;
					a.y = 100;
					a.sj_txt.text = dataArray[i].shijian;
					a.zhu.height = dataArray[i].gaodu;
					a.xmValue.text = dataArray[i].xmValue;
					a.guang.height = a.zhu.height;
					a.guang.alpha = 0.3;
					var s:ColorTransform = new ColorTransform();
					var m:uint = 0x00FF80;
					if (a.zhu.height <= 25)
					{
					}
					else if (a.zhu.height <= 50)
					{
					
						m = 0xFFFF80;
					
					}
					else if (a.zhu.height <= 75)
					{
						m = 0xFF8040;
					}
					else
					{
						m = 0xFF3E3E;
					}
					s.color = m;
					a.zhu.transform.colorTransform = s;
					_tubiao.line_mc.graphics.lineTo(a.x+10, a.y - a.zhu.height);
					_tubiao.zhezhao_mc.addChild(a);
					a.guang.addEventListener(MouseEvent.ROLL_OVER, xianshiTool);
					a.guang.addEventListener(MouseEvent.ROLL_OUT, yincangTool);
					zhuArray[i] = a;
					TweenMax.fromTo(a.zhu, 1, { height:0 }, { height:dataArray[i].gaodu } );
					TweenMax.fromTo(a.guang, 1,{height:0},{height:dataArray[i].gaodu} );
				}
				lineHeight = _tubiao.line_mc.height;
			}
			
			/**
			 * 创建测试数据的方法
			 * 时间：2010年7月9日 10:32:39
			 * @return 测试数组
			 */
			private function createData():void
			{
			if (root.loaderInfo.parameters["dataValue"])
			{
				dataValue= root.loaderInfo.parameters["dataValue"];
			}
			else
			{
				dataValue = "100,60";
			}
			if (root.loaderInfo.parameters["dataTime"])
			{
				dataTime= root.loaderInfo.parameters["dataTime"];
			}
			else
			{
				dataTime = "2010.07.01,2010.07.02";
			}
			if (root.loaderInfo.parameters["max0"])
			{
				max0 = root.loaderInfo.parameters["max0"];
			}
			else
			{
				max0 = 48.264;
			}
			if(root.loaderInfo.parameters["max1"])
			{
				max1= root.loaderInfo.parameters["max1"];
			}
			else
			{
				max1 = 65.371;
			}
			if(root.loaderInfo.parameters["max2"])
			{
				max2= root.loaderInfo.parameters["max2"];
			}
			else
			{
				max2 = 69.645;
			}
			if(root.loaderInfo.parameters["max3"])
			{
				max3= root.loaderInfo.parameters["max3"];
			}
			else
			{
				max3 = 73.673;
			}
			if(root.loaderInfo.parameters["max4"])
			{
				max4= root.loaderInfo.parameters["max4"];
			}
			else
			{
				max4 = 200;
			}
			if (root.loaderInfo.parameters["isAdd"])
			{
				var _isadd:String = root.loaderInfo.parameters["isAdd"];
				if (_isadd == "0")
				{
					isAdd = false;
				}
				else
				{
					isAdd = true;
				}
				_loadData = new loadData(dataValue,dataTime,max0,max1,max2,max3,max4,isAdd);
			}
			else
			{
				_loadData = new loadData(dataValue, dataTime, max0, max1, max2, max3, max4);
			}
				dataArray = _loadData.load();
				loader = new URLLoader();
				var rq:URLRequest = new URLRequest();
			if (root.loaderInfo.parameters["address"])
			{
				rq.url = root.loaderInfo.parameters["address"] + _tubiao.title.text;
			}
			else
			{
				rq.url = "http://192.168.1.105/hello.php?" + _tubiao.title.text;
			}
				loader.load(rq);
				loader.addEventListener(Event.COMPLETE, onResult);
			}
			
			private function zhixing(event:Event):void
			{
			if (_tubiao.changhuakuai.x < 84)
			{
				_tubiao.changhuakuai.x = 84;
			}
			else if (_tubiao.changhuakuai.x + _tubiao.changhuakuai.width > 550)
			{
				_tubiao.changhuakuai.x = 565 - _tubiao.changhuakuai.width;
			}
			else if(isMove==true)
			{
				if (this.mouseX - mouseFirstX + changhuakuai_mouseX < 84)
				{
				_tubiao.changhuakuai.x = 84;
				_tubiao.zhezhao_mc.x = zhezhaoX - 500 / _tubiao.changhuakuai.kuai.width * (84 - changhuakuai_mouseX);
				_tubiao.line_mc.x = _tubiao.zhezhao_mc.x;
				}
				else if (this.mouseX - mouseFirstX + changhuakuai_mouseX > 550 - _tubiao.changhuakuai.width)
				{
				_tubiao.changhuakuai.x = 550 - _tubiao.changhuakuai.width;
				_tubiao.zhezhao_mc.x = zhezhaoX - 500 / _tubiao.changhuakuai.kuai.width * (550 - _tubiao.changhuakuai.width-changhuakuai_mouseX);
				_tubiao.line_mc.x = _tubiao.zhezhao_mc.x;
				}
				else 
				{
				_tubiao.changhuakuai.x = this.mouseX - mouseFirstX + changhuakuai_mouseX;
				_tubiao.zhezhao_mc.x = zhezhaoX - 500 / _tubiao.changhuakuai.kuai.width * (this.mouseX  - mouseFirstX);
				_tubiao.line_mc.x = _tubiao.zhezhao_mc.x;
				}
			}
			}
			
			private function qiehuan_click(event:Event):void
			{
				if (isQiehuan == false)
				{
				_tubiao.qiehuan.text = "切换柱状方式";
				for (var i:int = 0; i < zhuArray.length; i++ )
				{
				zhuArray[i].zhu.visible = false;
				}
				_tubiao.line_mc.visible = true;
				isQiehuan = true;
				TweenMax.fromTo(_tubiao.line_mc, 1,{height:0}, {height:lineHeight} );
				}
				else
				{
				_tubiao.qiehuan.text = "切换曲线方式";
				for (i= 0; i < zhuArray.length; i++ )
				{
				zhuArray[i].zhu.visible = true;
				TweenMax.fromTo(zhuArray[i].zhu, 1, { height:0 }, { height:dataArray[i].gaodu } );
				TweenMax.fromTo(zhuArray[i].guang, 1,{height:0}, {height:dataArray[i].gaodu} );
				}
				_tubiao.line_mc.visible = false;
				isQiehuan = false;
				}
			}
			
			private function xianshiTool(event:Event):void
			{
				tool.alpha = 0.5;
				tool.parent
				tool.x = event.target.parent.x+event.target.parent.mouseX+_tubiao.zhezhao_mc.x-tool.width*0.5+5;
				tool.y = event.target.parent.y+event.target.parent.mouseY;
				tool.label.text = _tubiao.title.text+","+event.target.parent.sj_txt.text+","+event.target.parent.xmValue.text;
			}
			
			private function yincangTool(event:Event):void
			{
				tool.alpha = 0;
			}
			
			/**
			 * 创建滤镜数组的方法
			 * 时间：2010年7月9日 10:39:04
			 * 暂时不用的原因是：对该数组暂时还不是很熟悉
			 * @return
			 */
			/*
			private function lvjing():Array
			{
				//创建滤镜实例
				var distance:Number=0;
				var angleInDegress:Number=180;
				var colors:Array=[0xFFFFFF,0xFF8E8E,0xFF0000,0xFFFFFF];
				var alphas:Array=[0,1,1,1];
				var ratios:Array=[0,63,126,255];
				var blurX:Number=50;
				var blurY:Number=50;
				var strength:Number=3.5;
				var quality:Number = BitmapFilterQuality.HIGH;
				var type:String = BitmapFilterType.INNER;
				var knockout:Boolean = true;
				//var a:GradientBevelFilter = new GradientBevelFilter(distance, angleInDegress, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
				var gradientBevelFilter:GradientGlowFilter=new GradientGlowFilter(distance,angleInDegress,colors,alphas,ratios,blurX,blurY,strength,quality,type,knockout);
				//创建滤镜数组,通过将滤镜作为参数传递给Array()构造函数,
				//将该滤镜添加到数组中
				var filtersArray:Array = new Array(gradientBevelFilter);
				return filtersArray;
			}
			*/
			
			/**
			 * 向左的按钮的触发事件
			 * @param	event
			 */
			private function zuo_btn_Click(event:Event):void
			{
				if (_tubiao.changhuakuai.x <= 84)
				{
					
				}
				else
				{
					if (_tubiao.changhuakuai.x - 84 < 30 / (500 / _tubiao.changhuakuai.width))
					{
					}
					else
					{
					_tubiao.changhuakuai.x = _tubiao.changhuakuai.x - 30 / (500 / _tubiao.changhuakuai.width);
					_tubiao.zhezhao_mc.x += 30;
					_tubiao.line_mc.x += 30;
					}
				}
			}
			
			/**
			 * 向右的按钮的触发事件
			 * @param	event
			 */
			private function you_btn_Click(event:Event):void
			{
				if (_tubiao.changhuakuai.x >= 550)
				{
					
				}
				else
				{
					if (_tubiao.changhuakuai.x+_tubiao.changhuakuai.width >550-(30 / (500 / _tubiao.changhuakuai.width)))
					{
						//_tubiao.zhezhao_mc.x =10-(dataArray.length - (50 / 3)) * 30;

					}
					else
					{
						trace(_tubiao.changhuakuai.x);
					_tubiao.zhezhao_mc.x -= 30;
					_tubiao.line_mc.x -= 30;
					_tubiao.changhuakuai.x = _tubiao.changhuakuai.x + 30 / (500 / _tubiao.changhuakuai.width);
					}
				}
			}
			/**
			 * 数据执行成功事件
			 * @param	event
			 */
			private function onResult(event:Event):void
			{
				var allDataString:String = loader.data;
				var allDataArray:Array = allDataString.split("|");
				dataValue = allDataArray[0].toString();
				dataTime = allDataArray[1].toString();
				if (root.loaderInfo.parameters["isAdd"])
				{
				var _isadd:String = root.loaderInfo.parameters["isAdd"];
				if (_isadd == "0")
				{
					isAdd = false;
				}
				else
				{
					isAdd = true;
				}
				_loadData = new loadData(dataValue,dataTime,max0,max1,max2,max3,max4,isAdd);
				}
				else
				{
				_loadData = new loadData(dataValue, dataTime, max0, max1, max2, max3, max4);
				}
				dataArray = _loadData.load();
				shijian_txt_init(dataArray);
			}
			
			private function onFault(event:FaultEvent):void
			{
				trace(event.toString());
				shijian_txt_init(dataArray);
			}
	}
	
}