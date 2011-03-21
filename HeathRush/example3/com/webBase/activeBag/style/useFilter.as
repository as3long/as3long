// Copyright @ shch8.com All Rights Reserved At 2008-3-6
//开发：商创技术（www.shch8.com）望月狼
/*
·用于MC或图片的效果滤镜。
*********参数解释
useFilter(_MC:MovieClip,_type:String="",_setObj="")
@ _MC: 需要添加效果的影片
@ _type:需要添加的效果类型,值表下面介绍
@ _setObj:各效果所用到的参数,值表下面介绍

  注: 本类涵盖了针对MC的所有滤镜生成功能,所有参数皆为可选并设有默认值,使用Object对象传入参数,并且可以删除添加的滤镜

*********值表
_type的值
 @ shadow:添加阴影滤镜  
   例:
    new useFilter(tt,"shadow",{distance:3,angle:30,color:0x000000,alpha:0.6,strength:0.5}) //添加阴影
    new useFilter(tt,"shadow")//清除添加的阴影
 @ glow:添加发光滤镜  
   例:
    new useFilter(tt,"glow",{color:0x000000,alpha:0.6}) //添加发光
    new useFilter(tt,"glow")//清除添加的发光
 @ colorTransform:MC的色彩调整
   例:
    new useFilter(tt,"color",{red:150,blue:150,green:150})  //调为高亮色
    new useFilter(tt,"color")//清除色彩调整样式
 @ gray:转为灰度
   例:
      new useFilter(tt,"gray")//添加灰度滤镜
  new useFilter(tt,"gray",{clear:true})//清除滤镜
 @ negative:转为底片及反相
   例:
      new useFilter(tt,"negative")//添加反相滤镜
  new useFilter(tt,"negative",{clear:true})//清除滤镜
 @ sharpen:锐化
   例:
      new useFilter(tt,"sharpen",{strength:5})//添加滤镜,强度为5,如果小等于0,则表示清除此滤镜
  new useFilter(tt,"sharpen",{strength:0})//清除滤镜
 @ edges:查找边缘
   例:
      new useFilter(tt,"edges",{strength:5})//添加滤镜,强度为5,如果小等于0,则表示清除此滤镜
  new useFilter(tt,"edges",{strength:0})//清除滤镜
 @ emboss:浮雕
   例:
      new useFilter(tt,"emboss",{strength:5})//添加滤镜,强度为5,如果小等于0,则表示清除此滤镜
  new useFilter(tt,"emboss",{strength:0})//清除滤镜
 @ blur:模糊
   例:
      new useFilter(tt,"blur",{blurX:3,blurY:3,quality:BitmapFilterQuality.LOW})//添加滤镜
  new useFilter(tt,"blur")//清除滤镜
 @ ref:倒影
   例： new useFilter(tt,"ref",{alpha:0.6,long:80,hei:0.6})//添加滤镜
       
   
_setObj的值
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
package com.webBase.activeBag.style 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	public class useFilter {
		private var runTime:Timer;
		private var MC:*;
		private var setObj:Object;
		private var colorTransformer:ColorTransform;
		public static const SHADOW:String = "shadow";//阴影
		public static const COLOR:String = "color";//调色
		public static const GLOW:String = "glow";//发光
		public static const GRAY:String = "gray";//黑白
		public static const NEGATIVE:String = "negative";//反相
		public static const SHARPEN:String = "sharpen";//锐化
		public static const EDGES:String = "edges";//查找边缘
		public static const EMBOSS:String = "emboss";//浮雕
		public static const BLUR:String = "blur";//模糊
		public static const BEVEL:String = "bevel";//斜角
		public static const REF:String = "ref";//生成倒影
		public function useFilter(_MC:*,_type:String="",_setObj:Object=""):void {
			MC=_MC;
			setObj=_setObj;
			switch (_type) {
				case "shadow" ://阴影
					MC.filters =createShadow();
					break;
				case "color" ://调色
					MC.transform.colorTransform=createColorTrans();
					break;
				case "glow" ://发光
					MC.filters=createGlow();
					break;
				case "gray" ://黑白
					if (setObj=="[object Object]") {
						if (setObj.clear) {
							MC.filters =[];
							break;
						}
					}
					MC.filters =[new ColorMatrixFilter([0.3086,0.6094,0.0820,0,0,0.3086,0.6094,0.0820,0,0,0.3086,0.6094,0.0820,0,0,0,0,0,1,0])];
					break;
				case "negative" ://反相
					if (setObj=="[object Object]") {
						if (setObj.clear) {
							MC.filters =[];
							break;
						}
					}
					MC.filters =[new ColorMatrixFilter([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0])];
					break;
				case "sharpen" ://锐化
					MC.filters =createSharpen();
					break;
				case "edges" ://查找边缘
					MC.filters =createEdges();
					break;
				case "emboss" ://浮雕
					MC.filters =createEmboss();
					break;
				case "blur" ://模糊
					MC.filters =createBlur();
					break;
				case "bevel" ://斜角
					MC.filters =createBevel();
					break;
				case "ref" :
					createRef(MC);
					break;
				default :
					trace("error filter!");
			}
		}
		private function createBevel():Array {//斜角
			var myFilters:Array = new Array();
			var gradientBevel:GradientBevelFilter = new GradientBevelFilter();
			if (setObj=="[object Object]") {
				if (setObj.distance!=undefined) {
					gradientBevel.distance = setObj.distance;
				}
				if (setObj.angle!=undefined) {
					gradientBevel.angle= setObj.angle;
				} else {
					gradientBevel.angle = 225;// 反向 45 度
				}
				if (setObj.colors!=undefined) {
					gradientBevel.colors = setObj.colors;
				} else {
					gradientBevel.colors = [0xFFFFCC, 0xFEFE78, 0x8F8E01];
				}
				if (setObj.alphas!=undefined) {
					gradientBevel.alphas = setObj.alphas;
				} else {
					gradientBevel.alphas = [1, 0, 1];
				}
				if (setObj.ratios!=undefined) {
					gradientBevel.ratios= setObj.ratios;
				} else {
					gradientBevel.ratios = [0, 128, 255];
				}
				if (setObj.blurX!=undefined) {
					gradientBevel.blurX= setObj.blurX;
				} else {
					gradientBevel.blurX = 8;
				}
				if (setObj.blurY!=undefined) {
					gradientBevel.blurY= setObj.blurY;
				} else {
					gradientBevel.blurY = 8;
				}
				if (setObj.quality!=undefined) {
					gradientBevel.quality= setObj.quality;
				} else {
					gradientBevel.quality = BitmapFilterQuality.HIGH;
				}
			}
			myFilters.push(gradientBevel);
			return myFilters;
		}
		private function createColorTrans():ColorTransform {//调色
			var resultColorTransform:ColorTransform = new ColorTransform();
			if (setObj=="[object Object]") {
				if (setObj.greenMul!=undefined) {
					resultColorTransform.greenMultiplier=setObj.greenMul;
				}
				if (setObj.redMul!=undefined) {
					resultColorTransform.redMultiplier=setObj.redMul;
				}
				if (setObj.blueMul!=undefined) {
					resultColorTransform.blueMultiplier=setObj.blueMul;
				}
				if (setObj.color!=undefined) {//color=0xffcc00
					resultColorTransform.color=Number(setObj.color)
					
				}
				if (setObj.alpha!=undefined) {
					resultColorTransform.alphaMultiplier=setObj.alpha;
				}
				if (setObj.red!=undefined) {
					resultColorTransform.redOffset=setObj.red;
				}//-255 到 255 之间的数字，它先与 blueMultiplier 值相乘，再与红色通道值相加。 
				if (setObj.blue!=undefined) {
					resultColorTransform.blueOffset=setObj.blue;
				}
				if (setObj.green!=undefined) {
					resultColorTransform.greenOffset=setObj.green;
				}
			}
			return resultColorTransform;
		}
		private function createShadow():Array {//发光
			var myFilters:Array = new Array();
			var color:uint=0x000000;
			var alpha:Number=0.5;
			var blurX:Number=5;
			var blurY:Number=5;
			var strength:Number=1;//印记或跨页的强度。该值越高，压印的颜色越深，且发光与背景之间的对比度也越强。有效值为0到255。
			var inner:Boolean=false;//是否内侧发光
			var knockout:Boolean=false;//是否挖空
			var quality:Number=BitmapFilterQuality.HIGH;
			var filter:BitmapFilter;
			var distance:Number=4;//距离
			var angle:Number=45;//角度
			if (setObj=="[object Object]") {
				if (setObj.color!=undefined) {
					color=setObj.color;
				}
				if (setObj.alpha!=undefined) {
					alpha=setObj.alpha;
				}
				if (setObj.blurX!=undefined) {
					blurX=setObj.blurX;
				}
				if (setObj.blurY!=undefined) {
					blurY=setObj.blurY;
				}
				if (setObj.strength!=undefined) {
					strength=setObj.strength;
				}
				if (setObj.inner!=undefined) {
					inner=setObj.inner;
				}
				if (setObj.knockout!=undefined) {
					knockout=setObj.knockout;
				}
				if (setObj.quality!=undefined) {
					quality=setObj.quality;
				}
				if (setObj.distance!=undefined) {
					distance=setObj.distance;
				}
				if (setObj.angle!=undefined) {
					angle=setObj.angle;
				}
				filter= new DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,quality,inner,knockout);
				myFilters.push(filter);
			}
			return myFilters;
		}
		private function createBlur():Array {//模糊
			var blurX:Number=5;
			var blurY:Number=5;
			var quality:Number=BitmapFilterQuality.HIGH;
			var ary:Array=new Array();
			if (setObj=="[object Object]") {
				if (setObj.blurX!=undefined) {
					blurX=setObj.blurX;
				}
				if (setObj.blurY!=undefined) {
					blurY=setObj.blurY;
				}
				if (setObj.quality!=undefined) {
					quality=setObj.quality;
				}
				var con:BlurFilter=new BlurFilter(blurX, blurY, quality);
				ary.push(con);
			}
			return ary;
		}
		private function createEdges():Array {//检测边缘
			var strength:Number=5;
			if (setObj=="[object Object]") {
				if (setObj.strength!=undefined) {
					strength=setObj.strength;
				}
			}
			var ary:Array=new Array();
			if (strength>0) {
				var con:ConvolutionFilter=new ConvolutionFilter(3,3,[0,-1,0,-1,strength,-1,0,-1,0]);
				ary.push(con);
			}
			return ary;
		}
		private function createSharpen():Array {//锐化
			var strength:Number=5;
			if (setObj=="[object Object]") {
				if (setObj.strength!=undefined) {
					strength=setObj.strength;
				}
			}
			var ary:Array=new Array();
			if (strength>0) {
				ary.push(new ConvolutionFilter(3,3,[0,-1,0,-1,strength,-1,0,-1,0]));
			}
			return ary;
		}
		private function createEmboss():Array {//浮雕
			var strength:Number=3;
			if (setObj=="[object Object]") {
				if (setObj.strength!=undefined) {
					strength=(setObj.strength-1);
				}
			}
			var ary:Array=new Array();
			if (strength>=0) {
				ary.push(new ConvolutionFilter(3,3,[strength*-1,-1,0,-1,1,1,0,1,strength]));
			}
			return ary;
		}
		private function createRef(sourceObj:DisplayObject):void {//生成倒影
			var alpha:Number=0.6;
			var long:Number=100;
			var hei:Number=1;
			if (setObj=="[object Object]") {
				if (setObj.alpha!=undefined) {
					alpha=setObj.alpha;
				}
				if (setObj.long!=undefined) {
					long=setObj.long;
				}
				if (setObj.hei!=undefined) {
					hei=setObj.hei;
				}
			}
			//对源显示对象做上下反转处理
			var bd:BitmapData=new BitmapData(sourceObj.width+sourceObj.x,sourceObj.height,true,0);
			var mtx:Matrix=new Matrix();
			mtx.d=-1;
			mtx.tx=sourceObj.x;
			mtx.ty=bd.height+sourceObj.y;
			bd.draw(sourceObj,mtx);

			//生成一个渐变遮罩
			var width:int=bd.width;
			var height:int=bd.height+sourceObj.y;
			mtx=new Matrix();
			mtx.createGradientBox(width,height,0.5 * Math.PI,0,height*hei);//渐变高度与方向
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[alpha,0],[0,long],mtx);
			shape.graphics.drawRect(sourceObj.x,sourceObj.y,width,height);
			shape.graphics.endFill();
			var mask_bd:BitmapData=new BitmapData(width,height,true,0);
			mask_bd.draw(shape);
			//生成最终效果
			bd.copyPixels(bd,bd.rect,new Point(0,0),mask_bd,new Point(0,0),false);
			//将倒影位图放在源显示对象下面
			var ref:Bitmap=new Bitmap();
			ref.y=sourceObj.height;
			ref.bitmapData=bd;
			sourceObj.parent.addChild(ref);
		}
		private function createGlow():Array {//阴影
			var myFilters:Array = new Array();
			var color:uint=0x000000;
			var alpha:Number=1;
			var blurX:Number=5;
			var blurY:Number=5;
			var strength:Number=1;
			var inner:Boolean=false;
			var knockout:Boolean=false;
			var quality:Number=BitmapFilterQuality.HIGH;
			var filter:BitmapFilter;
			if (setObj=="[object Object]") {
				if (setObj.color!=undefined) {
					color=setObj.color;
				}
				if (setObj.alpha!=undefined) {
					alpha=setObj.alpha;
				}
				if (setObj.blurX!=undefined) {
					blurX=setObj.blurX;
				}
				if (setObj.blurY!=undefined) {
					blurY=setObj.blurY;
				}
				if (setObj.strength!=undefined) {
					strength=setObj.strength;
				}
				if (setObj.inner!=undefined) {
					inner=setObj.inner;
				}
				if (setObj.knockout!=undefined) {
					knockout=setObj.knockout;
				}
				if (setObj.quality!=undefined) {
					quality=setObj.quality;
				}
				filter= new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
				myFilters.push(filter);
			}
			return myFilters;
		}
	}
}