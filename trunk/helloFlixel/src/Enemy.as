package 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author zb
	 */
	public class Enemy extends FlxSprite 
	{
		//敌人素材
		[Embed(source='media/enemy.png')]
		protected var enemyImg:Class;
		//敌人死亡时，爆炸碎片的素材。。河蟹
		[Embed(source = 'media/enemygibs.png')]
		protected var gibsImg:Class;
		
		//敌人的移动速度
		protected static const ENEMY_SPEED:Number = 20;
		//敌人的生命值
		protected static const ENEMY_HEALTH:int = 5;
		
		//敌人初始移动的 x 坐标
		protected var startingX:Number;
		//敌人移动的水平范围，本次做的敌人会随机出现在某个平台上移动
		protected var maxHorizontalMovement:Number;
		//敌人爆炸的发射器
		//flxEmitter，是个轻量的粒子发射器，
		//麻雀虽小，五脏俱全,看看API 上的功能吧，很有用哦
		protected var gibs:FlxEmitter;
		
		//敌人爆炸的声音
		[Embed(source = 'media/asplode.mp3')]
		protected var asplodeSnd:Class;
		/**
		 * 创建敌人时的参数
		 * @param	sX 敌人初始 x 坐标
		 * @param	sY 敌人初始 y 坐标
		 * @param	maxHorizontalMovement 这里传入的是为所在平台的宽度
		 */
		public function Enemy(sX:Number, sY:Number,maxHorizontalMovement:Number):void 
		{
			super(sX, sY);
			loadGraphic(enemyImg, true, false, 13, 13);
			
			//将敌人的y坐标 上调 一个敌人高度的 位置
			//因为 sX 和 sY 是我们传入的 平台的 坐标
			//所以上调 1个 高度 这样 敌人就不会和所在平台重叠
			this.y = sY - this.height;
			//初始位置为 sX，也就是平台的 x 坐标
			this.startingX = sX;
			
			//最大水平移动范围，参数中的是 平台的宽度
			//平台的宽度 减去 敌人的宽度作为最大水平范围，这样敌人就不会离开平台了
			this.maxHorizontalMovement = maxHorizontalMovement - this.width;
			
			//设置敌人的x 轴 速度
			this.velocity.x = ENEMY_SPEED;
			//设置敌人的 生命值
			this.health = ENEMY_HEALTH;
			
			//生成爆炸发射器
			//参数1：x 坐标
			//参数2：y 坐标
			//都填0，刚生成的时候，用不着，
			//用的时候再根据敌人的位置来设置坐标
			this.gibs = new FlxEmitter(0, 0);
			
			//这里就是具体的创建发射器的内容
			//参数1：粒子的素材
			//参数2：粒子的数量
			//参数3：发射粒子后，每一帧，每个粒子旋转的角度
			//参数4：注明粒子的素材图片是 单一粒子 还是 多个粒子
			//如果是多个粒子就会把素材图片切割做成多个粒子
			//true 为 多个粒子，false为单个粒子
			//参数5：注明发射的这些粒子是否参与碰撞检测
			//0表示不参与，1表示参与，设置0的话性能会提高
			//参数6：注明粒子是否会在碰撞的时候发生反弹
			//0表示不会，1表示会，此参数只在 参数5设置为1的时候才有效果
			this.gibs.createSprites(gibsImg, 5, 16, false, 0, 0);
			
			//以下是发射器的一些发射效果，更多的参考 API
			//发射时每个粒子 x轴 的 初始速度范围，会在范围中随机选择
			this.gibs.setXSpeed( -100, 100);
			//发射时每个粒子 y轴 的 初始速度范围
			this.gibs.setYSpeed( -100, -150);
			//每个粒子所受到的重力加速度
			this.gibs.gravity = 300;
			
			//将粒子加入当前 state 中去
			//为什么不 add 在 敌人这里？
			//因为 flxSprite 没有 add 方法。。。。
			FlxG.state.add(gibs);
			
			//添加敌人移动的动画并开始播放
			this.addAnimation("move", [0, 1], 12);
			this.play("move");
		}
		
		//重写hitSide方法，让敌人碰到障碍物便反向移动
		override public function hitSide(Contact:FlxObject,Velocity:Number):void 
		{
			this.velocity.x = -this.velocity.x;
			
			//为什么不加上 super.hitSide 方法？
			//因为 hitSide 方法本身就是改变 x 速度
			//这里既然已经改了，也就没必要加上了
			//当然 这也是根据 游戏本身的规则制定的
			//当同学们自己做一些小游戏的时候，或许可能需要加上
		}
		
		//重写 kill 方法，让敌人被 kill 的时候，
		//发射器会发射爆炸粒子
		override public function kill():void 
		{
			//直接调用 super的kill，敌人被杀掉
			super.kill();
			
			//将发射器的坐标 设置到 敌人当前的坐标位置
			gibs.x = this.x;
			gibs.y = this.y;
			
			//发射粒子
			//参数1：设置为 true，说明粒子以爆炸的形式发射，否则为 顺序发射
			//爆炸发射，就是说所有粒子同时发射出去
			//顺序发射，就是粒子一个接一个发射
			//参数2：延迟的秒数，这个延迟是指 发射粒子后，
			//经过多少秒后 粒子会被 取消掉，也就是回收粒子，消失掉
			//要不然发射出去的那些粒子会一直存在
			gibs.start(true, 5);
			
			//播放敌人爆炸的声音
			FlxG.play(asplodeSnd);
		}
		
		//重写update
		override public function update():void 
		{
			//判断敌人的移动
			if ((this.x - this.startingX) >= maxHorizontalMovement)
			{
				//this.x - this.startingX，为敌人 当前相对于 初始位置的 x 坐标
				//当这个 相对坐标 超过 最大的水平移动范围时，说明敌人在 平台最右端
				//此时设置敌人的 x 坐标到 最大范围处，这样 敌人就不会超过 平台了
				this.x = this.startingX + maxHorizontalMovement;
				//将敌人的速度设置为 向左移动
				this.velocity.x = -ENEMY_SPEED;
			}
			else if (this.x - this.startingX <= 0)
			{
				//当相对 x 坐标 小于等于 0后，说明敌人在 平台的最左端
				//这时将敌人 x 坐标 设置为 初始 x 坐标，就不会超过平台了
				this.x = this.startingX;
				//将敌人速度设置为 向右移动
				this.velocity.x = ENEMY_SPEED;
			}
			
			//要加上了哦
			super.update();
		}
	}
	
}