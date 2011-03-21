package com.webBase.activeBag.style 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class StyleBag 
	{
		/**
		 * 用于显示对象添加效果滤镜
		 * @param	_MC	需要添加效果的影片
		 * @param	_type	需要添加的效果类型,值表下面介绍
		 * @param	_setObj 各效果所用到的参数,值表下面介绍
		 * *********值表
			_type的值
			 @ shadow:添加阴影滤镜  
			   例:
				addFilter(tt,"shadow",{distance:3,angle:30,color:0x000000,alpha:0.6,strength:0.5}) //添加阴影
				addFilter(tt,"shadow")//清除添加的阴影
			 @ glow:添加发光滤镜  
			   例:
				addFilter(tt,"glow",{color:0x000000,alpha:0.6}) //添加发光
				addFilter(tt,"glow")//清除添加的发光
			 @ colorTransform:MC的色彩调整
			   例:
				addFilter(tt,"color",{red:150,blue:150,green:150})  //调为高亮色
				addFilter(tt,"color")//清除色彩调整样式
			 @ gray:转为灰度
			   例:
				  addFilter(tt,"gray")//添加灰度滤镜
			  addFilter(tt,"gray",{clear:true})//清除滤镜
			 @ negative:转为底片及反相
			   例:
				  addFilter(tt,"negative")//添加反相滤镜
			  addFilter(tt,"negative",{clear:true})//清除滤镜
			 @ sharpen:锐化
			   例:
				  addFilter(tt,"sharpen",{strength:5})//添加滤镜,强度为5,如果小等于0,则表示清除此滤镜
			  addFilter(tt,"sharpen",{strength:0})//清除滤镜
			 @ edges:查找边缘
			   例:
				  addFilter(tt,"edges",{strength:5})//添加滤镜,强度为5,如果小等于0,则表示清除此滤镜
			  addFilter(tt,"edges",{strength:0})//清除滤镜
			 @ emboss:浮雕
			   例:
				  addFilter(tt,"emboss",{strength:5})//添加滤镜,强度为5,如果小等于0,则表示清除此滤镜
			  addFilter(tt,"emboss",{strength:0})//清除滤镜
			 @ blur:模糊
			   例:
				  addFilter(tt,"blur",{blurX:3,blurY:3,quality:BitmapFilterQuality.LOW})//添加滤镜
			  addFilter(tt,"blur")//清除滤镜
			 @ ref:倒影
			   例： addFilter(tt,"ref",{alpha:0.6,long:80,hei:0.6})//添加滤镜
				   
		 * _setObj的值
			@ shadow:添加阴影滤镜 
				  distance:Number //阴影距离
				  angle:          //阴影的角度
				  color:uint;     //阴影的颜色
				  alpha:Number;   //阴影透明度
				  blurX:Number;   //X轴模糊度 值:0-255
				  blurY:Number;   //Y轴模糊度 值:0-255
				  strength:Number;//阴影强度 值:0-255
				  inner:Boolean;  //是否内侧阴影
				  knockout:Boolean;//是否挖空
				  quality:Number;  //阴影强度 
				   -> BitmapFilterQuality.HIGH(高品质,默认设置)
					  BitmapFilterQuality.MEDIUM(中等品质)
					  BitmapFilterQuality.LOW(低品质)
			@ glow:添加发光滤镜  
				  color:uint;     //发光的颜色
				  alpha:Number;   //发光透明度
				  blurX:Number;   //X轴模糊度 值:0-255
				  blurY:Number;   //Y轴模糊度 值:0-255
				  strength:Number;//阴影强度 值:0-255
				  inner:Boolean;  //是否内侧发光
				  knockout:Boolean;//是否挖空
				  quality:Number;  //阴影强度 
				   -> BitmapFilterQuality.HIGH(高品质,默认设置)
					  BitmapFilterQuality.MEDIUM(中等品质)
					  BitmapFilterQuality.LOW(低品质)  
		   @ color:MC的色彩调整
				 color:Number    //直接设置颜色,值如:0xffcc00
				 red:Number      //新红色值 = (旧红色值 * redMul)+red  值为-255~255
				 blue:Number     //类同
				 green:Number
				 redMul:Number   
				 blueMul:Number
				 greenMul:Number 
				 alpha:Number   //透明度 0-1
		   @ sharpen:锐化
				 strength:Number //滤镜的强度,如果小等于0,则表示清除此滤镜
		   @ edges:查找边缘
				 strength:Number //滤镜的强度,如果小等于0,则表示清除此滤镜
		   @ emboss:浮雕
				 strength:Number //滤镜的强度,如果小等于0,则表示清除此滤镜
		   @ blur:模糊
				 blurX:Number=5; //x轴模糊度
				 blurY:Number=5;  //y轴模糊度
				 quality:Number=BitmapFilterQuality.HIGH; //品质
				   @ bevel:斜角
						 distance:Number //偏移值
						 angle:Number    //角度 有效值:0~360 
						 colors:Array    //三个角度的颜色数组,如:[0xFFFFCC,0xFEFE78,0x8F8E01]
				 alphas:Array    //三个角度的透明值,如:[1, 0, 1];
				 ratios:Array    //对应于colors数组中颜色的一组颜色分布比率。如:[0,128,255]//值为0~255
				 blurX:Number  
				 blurY:Number  
				 quality:Number
		 
		 @ ref:倒影
		   alpha:Number //倒影透明度 值：0~1
		   long:Number  //倒影渐变过渡的长度 值：0-100
		   hei:Number   //倒影的高度百分比 值：0-1
		 
		 */
		public function addFilter(_MC:InteractiveObject,_type:String="",_setObj:Object=""):void {
			  new useFilter(_MC,_type,_setObj)
		}
		/**
		 * 位图文字转换
		 * 由于我们的中文字体在FlashCS4以下的版本中是无法动态显示的，但有个小巧门，在Flash中手动创建动态文本时，如果一开始是中文字体，则这个文本块发布
		 * 以后可以使用中文字体了，本方法就是采用这点来写的位图文字转化，只要你传入一个文字模板(Flash中手动创建为中文字体的动态文本)并能创建一个像静态
		 * 文本一样的位图文字。
		 * 
		 * @param	sourceTxt	文字模板
		 * 最好是在Flash中手动创建为中文字体的动态文本，也可以用程序创建，但无法显示中文字体
		 * @param	showText	显示文字
		 * @param	txtFormat	文本样式
		 * @param	wid			强制宽度
		 * 						设置这个参数可以强制设置文字的宽度，当文字超出这个宽后会自动换行，默认为0表示不限制宽度，将单行自动延伸显示
		 * @param	sharp		是否使用未消除锯齿功能
		 * @return  Sprite
		 * @example 
		 * var txtFormat:TextFormat = new TextFormat("隶书",15,0x990000);
			var bf:Sprite = new BitmapFont(textExalpme,"测试文本abcdefg",txtFormat);
			addChild(bf)
		 */
		public function bitmapFont(sourceTxt:TextField=null,showText:String="",txtFormat:TextFormat=null,wid:Number=0,sharp:Boolean=false):Sprite
		{
			return new BitmapFont(sourceTxt, showText, txtFormat, wid, sharp);
		}
		/**
		 * 嵌入字体加载
		 * @param	fontSource	字体源，封装进SWF中
		 * @param	_loadComp	加载成功后的回调函数
		 * @param	_loading	正在加载进度回调函数
		 * @example
		 * new LoadFont("images/FontPackage.swf",loadEnd,loading);
function loadEnd() {
	LoadFont.loadFont="kt_font";
	LoadFont.loadFont="CAI978_951";
	var fontList:Array=LoadFont.getFont;
	var tf=new TextFormat(fontList[1].fontName,20,0x666666);
	var txt:TextField=new TextField();
	txt.text="字体调用";
	txt.embedFonts=true;
	txt.type="input";
	txt.setTextFormat(tf);
	addChild(txt);
}
function loading(num:Number) {
	trace(num);
}
}
		 */
		public function loadFont(fontSource:String, _loadComp:Function = null, _loading:Function = null):void 
		{
			new LoadFont(fontSource,_loadComp,_loading)
		}
		
	}
	
}