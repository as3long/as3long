package ghostcat.ui.containers
{
	import ghostcat.ui.layout.LinearLayout;
	
	/**
	 * 线性布局容器
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GBox extends GView
	{
		public function GBox(skin:* = null, replace:Boolean=true)
		{
			super(skin, replace);
			
			setLayout(new LinearLayout());
		}
		
		/**
		 * 线性布局 
		 * @return 
		 * 
		 */
		public function get linearLayout():LinearLayout
		{
			return layout as LinearLayout;
		}
		
		/**
		 * 布局方向 
		 * @return 
		 * 
		 */
		public function get type():String
		{
			return (layout as LinearLayout).type;
		}

		public function set type(v:String):void
		{
			(layout as LinearLayout).type = v;
		}
	}
}