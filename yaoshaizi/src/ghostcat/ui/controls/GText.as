//	嵌入字体注意事项
//
//	当皮肤资源从外部加载时，里面的TextField想用主SWF里嵌入的字体，必须重新设置它的font（而且必须和原来的不同），
//	否则就要重建TextField
//	 
//	重建TextField可以手动执行rebuildTextField方法或者设置GText.autoRebuildEmbedText=true，
//	这样做之后可以正常显示嵌入字体，但会在初始化时多消耗一些性能，显示上有可能稍有不同。
//	此外在GButton，GButtonBase里，如果没有让构造函数的第5个参数autoRefreshLabelField为false的话，
//	这种情况下Button里如果还包含其他的GText对象，它的文字将会无法改变，而只能通过Button的label属性改变。
//	基本上只有这个缺点。使用无Label的GButtonLite同样没有这个问题。
//	
//	不想重建TextField，那么就要靠setFontReplace方法来自动替换TextField内的字体。
//	比如资源里使用宋体，主SWF嵌入的宋体就要取一个别名，然后设置setFontReplace("宋体",别名,true)，
//	别名必须和原字体不同，否则FLASH不会进行替换。
//
//	还有就是注意CS5创建的SWF里中文字体别名用的是字体英文名，但如果设置了仿粗/斜体，字体名却是中文名，
//	因此你需要用setFontReplace来进行统一	


package ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.FontManager;
	import ghostcat.manager.LanguageManager;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.util.text.TextFieldUtil;
	import ghostcat.util.text.TextUtil;
	import ghostcat.util.text.UBB;
	import ghostcat.ui.ToolTipSprite;
	import ghostcat.ui.layout.Layout;
	import ghostcat.ui.layout.LinearLayout;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.Util;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Geom;
	import ghostcat.util.display.MatrixUtil;
	import ghostcat.util.display.SearchUtil;

	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 文本框
	 * 
	 * 标签规则：内容将作为背景存在，以内部找到的第一个TextField为标准，否则重新创建
	 * @author flashyiyi
	 * 
	 */	
	public class GText extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(TextField,{autoSize:TextFieldAutoSize.LEFT});
		public static var defaultTextFormat:String;
		/**
		 * 文本改变时的回调函数 
		 */
		public static var textChangeHandler:Function;
		
		/**
		 * 将它设置为true，将会自动重建所有Embed的TextField以便通过外部嵌入字体，否则使用SWF内的字体
		 */
		public static var autoRebuildEmbedText:Boolean = false;
		
		/**
		 * 将它设置为true，将会自动重建所有非Embed的TextField，以便处理某些IDE无法修改设备字体的字体的问题
		 */
		public static var autoRebuildText:Boolean = false;
		
		/**
		 * 字体替换 
		 */
		public static var fontFamilyReplacer:Object;
		
		/**
		 * 嵌入字体模式切换
		 */
		public static var fontEmbedReplacer:Object;
		
		/**
		 * 字体准线调整
		 */
		public static var fontOffestYReplacer:Object;
		
		/**
		 * 设置字体替换
		 * @param name	原字体名
		 * @param fontName	新字体名
		 * @param embed	更改嵌入模式（为空则不改变）
		 * @param offestY	调整字体的y轴位置
		 */
		public static function setFontReplace(oldFont:String,newFont:String,embed:* = null,offestY:Number = NaN):void
		{
			if (!fontFamilyReplacer)
				fontFamilyReplacer = {};
			fontFamilyReplacer[oldFont] = newFont;
			
			if (embed is Boolean)
			{
				if (!fontEmbedReplacer)
					fontEmbedReplacer = {};
				fontEmbedReplacer[oldFont] = embed;
			}
			
			if (!isNaN(offestY))
			{
				if (!fontOffestYReplacer)
					fontOffestYReplacer = {};
				fontOffestYReplacer[oldFont] = offestY;	
			}
		}
		
		private var _textFormat:String;
		private var _autoSize:String = TextFieldAutoSize.NONE;
		private var _separateTextField:Boolean = false;
		
		/**
		 * 包含的TextField。此属性会在设置皮肤时自动设置成搜索到的第一个TextField。 
		 */		
		public var textField:TextField;
		
		/**
		 * 文本框是否是由皮肤提供
		 */
		public var isSkinText:Boolean;
		
		/**
		 * 文本框是否已经被重建过
		 */
		public var isRebuild:Boolean;
		
		private var _textStartPoint:Point;
		
		/**
		 * TextField的初始位置（如果是从skin中创建，此属性只读，否则可以通过修改它来设置TextField的位置）
		 */
		public function get textStartPoint():Point
		{
			return _textStartPoint;
		}

		public function set textStartPoint(value:Point):void
		{
			if (isSkinText)
				return;
			
			_textStartPoint = value;
			
			if (textField)
			{
				textField.x = value.x;
				textField.y = value.y;
			}
		}
		

		private var _textPadding:Padding;
		
		/**
		 * 当enabledAdjustContextSize为true时，会根据此属性调整皮肤大小以适应文本框
		 */
		public function get textPadding():Padding
		{
			return _textPadding;
		}

		public function set textPadding(value:Padding):void
		{
			_textPadding = value;
			
			if (enabledAdjustContextSize)
			{
				adjustContextSize();
			}
//			else
//			{
//				if (_textPadding && textField && !isSkinText)
//					_textPadding.adjectRect(textField,this);
//			}
		}

		
		/**
		 * 是否自动根据文本调整Skin体积。当separateTextField为false时，此属性无效。
		 * 要正确适应文本，首先必须在创建时将separateTextField参数设为true，其次可以根据textPadding来决定边距
		 */
		public var enabledAdjustContextSize:Boolean;
		
		/**
		 * 是否激活多语言 
		 */
		public var enabledLangage:Boolean = true;
		
		/**
		 * 是否激活截断文本
		 */
		public var enabledTruncateToFit:Boolean;
		
		/**
		 * 文本是否垂直居中
		 */
		public var enabledVerticalCenter:Boolean;
		
		/**
		 * 限定输入内容的正则表达式
		 */
		public var regExp:RegExp;
		
		/**
		 * 在输入文字的时候也发布Change事件
		 */
		public var changeWhenInput:Boolean;
		
		/**
		 * 文字是否竖排
		 */		
		public var vertical:Boolean;
		
		/**
		 * ANSI的最大输入限制字数（中文算两个字）
		 */
		public var ansiMaxChars:int;
		
		/**
		 * 是否强制使用HTML文本
		 */
		public var useHtml:Boolean;
		
		/**
		 * 是否转换UBB（只在HTML文本中有效）
		 */
		public var ubb:Boolean;
		
		/**
		 * 是否将文本从Skin中剥离。剥离后Skin缩放才不会影响到文本的正常显示
		 */
		public function get separateTextField():Boolean
		{
			return _separateTextField;
		}
		
		public function set separateTextField(v:Boolean):void
		{
			_separateTextField = v;
			
			if (textField)
			{
				if (v)
				{
					var m:Matrix = MatrixUtil.getMatrixAt(textField,this);
					if (m)
						textField.transform.matrix = m;
					addChild(textField);
				}
			}
		}
		
		/**
		 * 文本框自适应文字的方式
		 */
		public function get autoSize():String
		{
			return textField ? textField.autoSize : _autoSize;
		}

		public function set autoSize(v:String):void
		{
			_autoSize = v;
			if (textField)
				textField.autoSize = v;
		}
		
		/**
		 * 让文本框适应文本大小（文本框不动，皮肤根据padding改变自己的大小和位置）
		 * @return 
		 * 
		 */
		public function enabledAutoLayout(padding:Padding,autoSize:String = TextFieldAutoSize.LEFT):void
		{
			this.separateTextField = true;
			
			this.autoSize = autoSize;
			this.enabledAdjustContextSize = true;
			this.textPadding = padding;
		}
		
		/**
		 * 字体名称
		 */
		public function get textFormat():String
		{
			return _textFormat;
		}

		public function set textFormat(v:String):void
		{
			_textFormat = v;
			if (textField && v)
			{
				var f:TextFormat = FontManager.instance.getTextFormat(v);
				if (f)
					applyTextFormat(f,true);
			}
		}
		
		/**
		 * 应用字体样式
		 * 
		 * @param f	为空则取默认字体样式
		 * @param overwriteDefault	是否覆盖默认字体样式
		 * 
		 */
		public function applyTextFormat(f:*=null,overwriteDefault:Boolean = false):void 
		{
			if (!textField)
				return;
			
			if (!f)
				f = textField.defaultTextFormat;
			
			if (!(f is TextFormat))
				f = Util.createObject(TextFormat,f);
			
			if (textField.length > 0)
				textField.setTextFormat(f,0,textField.length);
			
			if (overwriteDefault)
				textField.defaultTextFormat = f;
			
			if (asTextBitmap)
				reRenderTextBitmap();
		}
		
		/**
		 * 设置字体样式 
		 * @param f
		 * 
		 */
		public function setTextFormat(f:TextFormat,beginIndex:int = -1,endIndex:int = -1):void
		{
			if (!textField)
				return;
			
			textField.setTextFormat(f,beginIndex,endIndex);
			
			if (asTextBitmap)
				reRenderTextBitmap();
		}
		
		/**
		 * 设置文本框大小 
		 * @param w
		 * @param h
		 * 
		 */
		public function setTextFieldSize(w:Number = NaN,h:Number = NaN,autoSize:String = TextFieldAutoSize.NONE):void
		{
			if (textField)
			{
				textField.autoSize = autoSize;
				
				if (!isNaN(w))
					textField.width = w;
				
				if (!isNaN(h))
					textField.height = h;
			}
		}
		
		/**
		 * 获得文本框大小 
		 * @return 
		 * 
		 */
		public function getTextFieldSize():Rectangle
		{
			return textField ? new Rectangle(textField.x,textField.y,textField.width,textField.height) : null
		}


		/**
		 * 最大输入限制字数
		 *  
		 * @return 
		 * 
		 */
		public function get maxChars():int
		{
			return textField ? textField.maxChars : 0;
		}

		public function set maxChars(v:int):void
		{
			if (textField)
				textField.maxChars = v;
		}
		
		/**
		 * 编辑时是否自动全选
		 */
		public var autoSelect:Boolean

		/**
		 * 可编辑
		 * @return 
		 * 
		 */
		public function get editable():Boolean
		{
			return textField.type == TextFieldType.INPUT;
		}

		public function set editable(v:Boolean):void
		{
			textField.type = v ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textField.mouseEnabled = v;
		}
		
		/**
		 * 是否可选
		 * 
		 */
		public function get selectable():Boolean
		{
			return textField.selectable;
		}
		
		public function set selectable(v:Boolean):void
		{
			textField.selectable = textField.mouseEnabled = v;
		}
		
		/**
		 * 是否多行显示（可激活回车换行） 
		 * @return 
		 * 
		 */
		public function get multiline():Boolean
		{
			return textField.multiline;
		}
		
		public function set multiline(v:Boolean):void
		{
			textField.multiline = v;
		}
		
		/**
		 * 是否自动断行
		 * @return 
		 * 
		 */
		public function get wordWrap():Boolean
		{
			return textField.wordWrap;
		}
		
		public function set wordWrap(v:Boolean):void
		{
			textField.wordWrap = v;
		}
		
		/**
		 * 文字输入限制
		 * @return 
		 * 
		 */
		public function get restrict():String
		{
			return textField.restrict;
		}
		
		public function set restrict(v:String):void
		{
			textField.restrict = v;
		}
		
		private var _editable:Boolean;
		
		/**
		 * 用于缓存的Bitmap
		 */
		protected var textBitmap:Bitmap;
		
		private var _asTextBitmap:Boolean;
		
		public function GText(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (textPadding)
				this._textPadding = textPadding;
			
			this._separateTextField = separateTextField;
			
			super(skin, replace);
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			getTextFieldFromSkin(this.skin);
		}
		
		/**
		 * 从skin中获得TextField对象，没有则自己创建。
		 * 
		 * @param skin
		 * 
		 */
		protected function getTextFieldFromSkin(skin:DisplayObject):void
		{
			isRebuild = false;
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				textField.removeEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
				textField.removeEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
				textField.removeEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
				if (textField.parent == this)
					this.removeChild(textField);
			}
			
			textField = SearchUtil.findChildByClass(skin,TextField) as TextField;
				
			if (!textField)//如果皮肤不存在文本框则创建
			{
				isSkinText = false;
				
				textField = TextFieldParse.createTextField();
				addChild(textField);
				
				this._separateTextField = true;
				
//				//根据textPadding设置文本框位置
//				if (_textPadding)
//					_textPadding.adjectRect(textField,this.content);
				_textStartPoint = new Point();
			}
			else
			{
				isSkinText = true;
				
				if (autoRebuildEmbedText && textField.embedFonts || autoRebuildText && !textField.embedFonts)//如果需要用Embed标签来定义嵌入字体，则必须重新创建文本框
				{
					rebuildTextField();
				}
				
				if (this._separateTextField)
					separateTextField = true;//提取文本框
					
				_textStartPoint = new Point(textField.x,textField.y);
			}
			
			this.textFormat = textFormat ? textFormat : defaultTextFormat;//应用字体样式（如果有）
			var oldFont:TextFormat = this.textField.defaultTextFormat;//替换字体
			if (fontEmbedReplacer && fontEmbedReplacer.hasOwnProperty(oldFont.font))
			{
				this.textField.embedFonts = fontEmbedReplacer[oldFont.font];
				if (!isRebuild && (autoRebuildEmbedText && textField.embedFonts || autoRebuildText && !textField.embedFonts))
					rebuildTextField();
			}
			if (fontOffestYReplacer && fontOffestYReplacer.hasOwnProperty(oldFont.font))
			{
				this.textField.y = _textStartPoint.y + Number(oldFont.size) * fontOffestYReplacer[oldFont.font];
			}
			if (fontFamilyReplacer && fontFamilyReplacer.hasOwnProperty(oldFont.font))
			{
				oldFont.font = fontFamilyReplacer[oldFont.font];
				this.applyTextFormat(oldFont,true);
			}
			
			
			if (!this.text)
				super.data = textField.text;
			
			doWithText(this.text);
			
			textField.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			textField.addEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
			textField.addEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
			textField.addEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
			
			textField.mouseEnabled = false;
		}
		
		/**
		 * 重新创建TextField，执行此方法后，TextField会和代码创建的相同（原本有些细节是不同的）
		 * 
		 */
		public function rebuildTextField():void
		{
			isRebuild = true;
			this.textField = TextFieldUtil.clone(this.textField,true);//将TextField重新创建避免出现显示错误
		}
		
		/**
		 * 当此属性包含<html>标签时，将作为html文本处理
		 * @return 
		 * 
		 */		
		
		public function get text():String
		{
			return data as String;
		}

		public function set text(v:String):void
		{
			data = v;
		}
		
		/**
		 * 当前文本 
		 * @return 
		 * 
		 */
		public function get curText():String
		{
			return textField ? textField.text : null;
		}
		
		/**
		 * 设置格式文本 
		 * @param v
		 * 
		 */
		public function set htmlText(v:String):void
		{
			data = v ? ("<html>"+LanguageManager.getString(v)+"</html>") : null
		}
		
		/**
		 * 根据文本框更新图形大小（文本框不动，皮肤根据padding改变自己的大小和位置）
		 * 
		 */
		public function adjustContextSize():void
		{
			if (content)
			{
				if (_textPadding)
				{
					_textPadding.invent().adjectRectBetween(content,textField);
				}
				else
				{
					var rect:Rectangle = getBounds(this);
					content.width = textField.width - rect.x;
					content.height = textField.height - rect.y;
				}
			}
		}
		
		/**
		 * 根据文本框大小截断文本 
		 * 
		 */
		public function truncateToFit(showToolTip:Boolean = true):void
		{
			if (TextFieldUtil.truncateToFit(textField) && showToolTip)
				this.toolTip = this.text;
		}
		
		/**
		 * 根据文本框大小设置文本字体
		 * @param adjustY	自动调整文本框的y值
		 * @param resetY	每次调整都将y设回0（否则重复设置data并调整大小会出问题）
		 * 
		 */
		public function autoFontSize(adjustY:Boolean = false,resetY:Boolean = false):void
		{
			TextFieldUtil.autoFontSize(textField,adjustY,resetY);
		}
		
		/**
		 * 使文本在皮肤中垂直居中
		 * 
		 */
		public function verticalCenter():void
		{
			if (!textField && textField.parent)
				return;
			
			var p:DisplayObjectContainer = textField.parent;
			p.removeChild(textField);
			var center:Point = Geom.center(content,p);
			p.addChild(textField);
			textField.y = center.y - textField.height / 2;
		}
		
		/** @inheritDoc*/
		public override function set data(v:*):void
		{
			if (v == super.data)
				return;
			
			super.data = v;
			
			doWithText(v);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function doWithText(str:String):void
		{
			if (!str)
				str = "";
			
			if (textChangeHandler != null && enabledLangage)
				str = textChangeHandler(str);
			
			if (this.vertical)
				str = TextUtil.vertical(str);
			
			if (textField)
			{
				if (useHtml || str.indexOf("<html>") != -1)
				{
					if (ubb)
						str = UBB.decode(str);
					
					textField.htmlText = str;
				}
				else
					textField.text = str;
				
				if (enabledTruncateToFit)
					truncateToFit();
				
				if (enabledAdjustContextSize)
					adjustContextSize();
				
				if (enabledVerticalCenter)
					verticalCenter();
					
				if (asTextBitmap)
					reRenderTextBitmap();
			}
		}
		
		/**
		 * 将TextField替换成Bitmap，以实现设备文本的平滑旋转缩放效果
		 * 
		 */		
		public function set asTextBitmap(v:Boolean):void
		{
			_asTextBitmap = v;
			
			if (v)
			{
				textField.visible = false;
				reRenderTextBitmap();	
			}
			else
			{
				textField.visible = true;
				if (textBitmap)
				{
					textBitmap.bitmapData.dispose();
					textBitmap.parent.removeChild(textBitmap);
					textBitmap = null;
				}
			}
		}
		
		public function get asTextBitmap():Boolean
		{
			return _asTextBitmap;
		}
		
		/**
		 * 更新位图文字
		 * 
		 */			
		public function reRenderTextBitmap():void
		{
			if (textBitmap)
			{
				textBitmap.parent.removeChild(textBitmap);
				textBitmap.bitmapData.dispose();
			}
			
			textBitmap = new Bitmap(new BitmapData(Math.ceil(textField.width),Math.ceil(textField.height),true,0));
			textBitmap.x = textField.x;
			textBitmap.y = textField.y;
			textField.parent.addChild(textBitmap);
			
			textBitmap.bitmapData.draw(textField);
		}
		
		/**
		 * 获得ANSI长度（中文按两个字符计算）
		 * @param data
		 * @return 
		 * 
		 */
		private function getANSILength(data:String):int
  		{
			return TextUtil.getANSILength(data);
		}
		
		/**
		 * 键入文字事件 
		 * @param event
		 * 
		 */
		protected function textInputHandler(event:TextEvent):void
		{
			if (regExp && !regExp.test(textField.text + event.text))
				event.preventDefault();
			
			if (ansiMaxChars && getANSILength(textField.text + event.text) > ansiMaxChars)
				event.preventDefault();
			
			if (changeWhenInput)
				this.data = textField.text;
		}
		
		/**
		 * 文件焦点事件 
		 * @param event
		 * 
		 */
		protected function textFocusInHandler(event:Event):void
		{
			if (autoSelect)
				textField.setSelection(0,textField.length);
		}
		
		protected function textFocusOutHandler(event:Event):void
		{
			if (editable)
				accaptText();
		}
		
		protected function textKeyDownHandler(event:KeyboardEvent):void
		{
			
		}
		
		/**
		 * 确认输入框的文本，使data获得新的值，并触发Change
		 * 
		 */
		public function accaptText():void
		{
			this.data = textField.text;
		}
		
		/** @inheritDoc*/
		protected override function updateSize():void
		{
			super.updateSize();
			
			if (_textPadding)
				_textPadding.adjectRect(textField,this);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (textBitmap)
				textBitmap.bitmapData.dispose();
				
			if (textField)
			{
				textField.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
				textField.removeEventListener(FocusEvent.FOCUS_IN,textFocusInHandler);
				textField.removeEventListener(FocusEvent.FOCUS_OUT,textFocusOutHandler);
				textField.removeEventListener(KeyboardEvent.KEY_DOWN,textKeyDownHandler);
				if (textField.parent == this)
					removeChild(textField);
			}
			
			super.destory();
		}
		
	}
}