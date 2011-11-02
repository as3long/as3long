package 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxTileblock;
	
	/**
	 * ...
	 * @author zb
	 */
	public class MovingPlatform extends FlxTileblock 
	{
		//平台水平移动的最大范围
		public var horizonMoving:uint;
		//平台垂直移动的最大范围
		public var verticalMoving:uint;
		//平台的初始 x 坐标
		public var stX:int;
		//平台的初始 y 坐标
		public var stY:int;
		//平台垂直方向的标识
		private var velFacing:uint;
		/**
		 * 构造方法
		 * @param	X 初始 x 坐标
		 * @param	Y 初始 y 坐标
		 * @param	Width 平台的宽度
		 * @param	Height 平台的高度
		 * @param	HM 平台水平移动的最大范围
		 * @param	VM 平台垂直移动的最大范围
		 * @param	randomPos 是否使用随机移动位置，就是说平台是否从范围内的某个点开始移动
		 */
		public function MovingPlatform(X:int, Y:int, Width:uint, Height:uint,HM:uint,VM:uint,randomPos:Boolean=true):void 
		{
			//先调用super
			super(X, Y, Width, Height);
			//赋值初始 坐标
			stX = X;
			stY = Y;
			//赋值水平和垂直最大移动范围
			horizonMoving = HM;
			verticalMoving = VM;
			
			//设置最大速度以及速度值,这里最大速度是用于给正反移动方向的速度赋值
			maxVelocity.x = HM * 0.2;
			maxVelocity.y = VM * 0.2;
			velocity.x = maxVelocity.x;
			velocity.y = maxVelocity.y;
			
			//facing在这里作为水平方向的标识，默认向右
			facing = RIGHT;
			//垂直方向标识，DOWN 和 UP 是flxSprite的静态变量，默认向下
			velFacing = DOWN;
			
			//如果设置了 randomPos 为 true
			if (randomPos) 
			{
				//那么x 和 y 的位置就设置成 范围内的 某个随机点
				x = Math.random() * HM + stX;
				y = Math.random() * VM + stY;
			}
		}
		
		override public function update():void 
		{
			//当平台 x 坐标大于最大水平范围 且方向为 右时
			if (x > (stX+horizonMoving) && facing==RIGHT) 
			{
				//将 x 轴的坐标设置为 负值，即向左移动
				velocity.x = -maxVelocity.x;
				//设置 facing方向 为 左
				facing = LEFT;
			}else if (x < stX && facing==LEFT) 
			{
				//如果 x 坐标小于初始 坐标，就设置速度 向右
				velocity.x = maxVelocity.x;
				facing = RIGHT;
			}
			if (y > (stY+verticalMoving) && velFacing==DOWN) 
			{
				//当 y 坐标大于 垂直最大范围，且方向向下
				//将 y 速度设置 向上，velFacing 向上
				velocity.y = -maxVelocity.y;
				velFacing = UP;
			}else if (y < stY && velFacing==UP) 
			{
				//当 y 坐标小于 垂直最大范围，且方向向上
				//将 y 速度设置 向下，velFacing 向下
				velocity.y = maxVelocity.y;
				velFacing = DOWN;
			}
			//别忘了
			super.update();
		}
	}
	
}