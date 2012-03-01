package
{
	import fl.events.ColorPickerEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	//import ghostcat.ui.controls.GColorPicker;
	
	/**
	 * ...
	 * @author huanglong
	 */
	public class AddBorder extends MovieClip
	{
		private var cp:ColorPicker;
		public function AddBorder()
		{
			/*mcAddBorder();
			   var mc:MovieClip = new MovieClip();
			   mc.graphics.beginFill(0xFF8040, 0.8);
			   mc.graphics.drawCircle(50, 90, 30);
			   mc.graphics.endFill();
			   mc.x = 100;
			   addChild(mc);
			   mc.addBorder(3, 0x0000FF);
			   //mc.hideBorder();
			
			   var keyController:KeyComtroller = new KeyComtroller();
			   keyController.addKeyEvent(stage);
			 keyController.mc = mc;*/
			//keyController.speed = 1;
			
			cp = new ColorPicker();
			this.addChild(cp);
			cp.addEventListener('change', change);
		}
		
		private function change(e:Event):void 
		{
			trace(cp.color);
		}
		
		/**
		 * 扩展MovieClip
		 */
		public static function mcAddBorder():void
		{
			MovieClip.prototype.border = null;
			
			/**
			 * 增加
			 */
			MovieClip.prototype.addBorder = function(borderWidth:Number = 2, color:uint = 0xFF8080):void
			{
				if (this.border == null)
				{
					var mc:Sprite = new Sprite();
					var r:Rectangle = this.getBounds(this);
					//mc.graphics.lineStyle(2, color);
					//var re myMC.getRect(myMC.parent);
					var p1:Point = new Point(r.x - borderWidth, r.y - borderWidth);
					var p2:Point = new Point(r.x + r.width + borderWidth, r.y - borderWidth);
					var p3:Point = new Point(r.x + r.width + borderWidth, r.y + borderWidth + r.height);
					var p4:Point = new Point(r.x - borderWidth, r.y + borderWidth + r.height);
					hua_xuxian(mc.graphics, p1, p2, color, borderWidth);
					hua_xuxian(mc.graphics, p2, p3, color, borderWidth);
					hua_xuxian(mc.graphics, p3, p4, color, borderWidth);
					hua_xuxian(mc.graphics, p4, p1, color, borderWidth);
					//mc.graphics.drawRect(, , r.width + 2, r.height + 2);
					mc.graphics.endFill();
					this.addChild(mc);
					this.border = mc;
					this.borderWidth = borderWidth;
				}
			/*else
			   {
			
			 }*/
			}
			
			/*MovieClip.prototype.addBorderWidth() = function():void
			   {
			   (this.border as Sprite).graphics.clear();
			
			 }*/
			
			/**
			 * 隐藏
			 */
			MovieClip.prototype.hideBorder = function():void
			{
				if (this.border != null)
				{
					this.border.visible = false;
				}
			}
			
			/**
			 * 显示
			 */
			MovieClip.prototype.showBorder = function():void
			{
				if (this.border != null)
				{
					this.border.visible = true;
				}
			}
			
			/**
			 * 删除
			 */
			MovieClip.prototype.removeBorder = function():void
			{
				if (this.border != null)
				{
					this.removeChild(this.border);
					this.border = null;
				}
			}
		}
		
		public static function hua_xuxian(graphics:Graphics, p1:Point, p2:Point, color:uint = 0xFF8080, border:Number = 2, length:Number = 5, gap:Number = 5):void
		{
			var max:Number = Point.distance(p1, p2);
			var l:Number = 0;
			var p3:Point
			var p4:Point;
			while (l < max)
			{
				p3 = Point.interpolate(p2, p1, l / max);
				l += length;
				if (l > max)
					l = max
				p4 = Point.interpolate(p2, p1, l / max);
				graphics.lineStyle(border, color);
				graphics.moveTo(p3.x, p3.y)
				graphics.lineTo(p4.x, p4.y)
				l += gap;
			}
		}
	}

}