package ghostcat.parse.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ghostcat.debug.Debug;
	import ghostcat.parse.DisplayParse;
	import ghostcat.util.display.MatrixUtil;

	/**
	 * 绘制到位图
	 * @author flashyiyi
	 * 
	 */
	public class DrawParse extends DisplayParse
	{
		public var source:IBitmapDrawable;
		
		public var matrix:Matrix = null;
		public var colorTransform:ColorTransform = null;
		public var blendMode:String = null;
		public var clipRect:Rectangle = null;
		public var smoothing:Boolean = false;
		
		public var transparent:Boolean = true;
		public var fillColor:uint = 0x00FFFFFF;
		
		public function DrawParse(source:IBitmapDrawable,matrix:Matrix=null,colorTransform:ColorTransform=null,clipRect:Rectangle = null,smoothing:Boolean = false,transparent:Boolean = true,fillColor:uint = 0x00FFFFFF)
		{
			this.source = source;
			this.matrix = matrix;
			this.colorTransform = colorTransform;
			this.blendMode = blendMode;
			this.clipRect = clipRect;
			this.smoothing = smoothing;
			
			this.transparent = transparent;
			this.fillColor = fillColor;
		}
		/** @inheritDoc*/
		public override function parse(target:*):void
		{
			if (target is Bitmap)
				target = (target as Bitmap).bitmapData;
		
			super.parse(target);
		}
		/** @inheritDoc*/
		public override function parseBitmapData(target:BitmapData) : void
		{
			super.parseBitmapData(target);
			
			try
			{
				target.draw(source,matrix,colorTransform,blendMode,clipRect,smoothing);
			}
			catch (e:Error)
			{
				Debug.error(e.message);
			}
		}
		
		/**
		 * 创建Bitmap
		 * 
		 * @param para
		 * @return 
		 * 
		 */
		public function createBitmap():Bitmap
		{
			var displayObj:DisplayObject = source as DisplayObject;
			if (!displayObj)
				return null;
			
			var bounds:Rectangle = displayObj.getBounds(displayObj);
			if (!matrix)
			{
				matrix = new Matrix();
				matrix.tx -= bounds.x;
				matrix.ty -= bounds.y;
			}
//			else
//			{
//				var rotate:Number = Math.atan(matrix.b / matrix.a);
//				bounds.x += matrix.tx;
//				bounds.y += matrix.ty;
//				bounds.width *= matrix.b / Math.sin(rotate);
//				bounds.height *= matrix.d / Math.cos(rotate);
//			}
			
			var width:int = Math.ceil(bounds.width);
			var height:int = Math.ceil(bounds.height);
			
			
			var bitmap:Bitmap;
			try
			{
				bitmap = new Bitmap(new BitmapData(width,height,transparent,fillColor));
			}
			catch (e:Error)
			{
				Debug.error(e.message);
				bitmap = new Bitmap();
			}
			
			if (source is DisplayObject)
			{
				bitmap.x = (source as DisplayObject).x + bounds.x;
				bitmap.y = (source as DisplayObject).y + bounds.y;
			}
			
			this.parse(bitmap);
			
			return bitmap;
		}
		
		/**
		 * 创建BitmapData
		 * 
		 * @return 
		 * 
		 */
		public function createBitmapData():BitmapData
		{
			return createBitmap().bitmapData;
		}
		
		/**
		 * 根据图形创建一个位图 
		 * @param source
		 * @param matrix
		 * @param colorTransform
		 * @param clipRect
		 * @param smoothing
		 * @return 
		 * 
		 */
		public static function createBitmap(source:IBitmapDrawable,matrix:Matrix=null,colorTransform:ColorTransform=null,clipRect:Rectangle = null,smoothing:Boolean = false):Bitmap
		{
			return new DrawParse(source,matrix,colorTransform,clipRect,smoothing).createBitmap();
		}
	}
}