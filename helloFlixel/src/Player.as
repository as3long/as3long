package 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author zb
	 */
	public class Player extends FlxSprite 
	{
		//嵌入的人物素材
		[Embed(source = 'media/spaceman1.png')]
		protected var playerImg:Class;
		
		//以下3个静态变量只是个值，方便修改
		//人物移动的速度得值
		protected static const PLAYER_RUN_SPEED:int = 100;
		//人物收到的重力加速度的值
		protected static const GRAVITY_ACCELERATION:Number = 420;
		//人物跳跃时的加速度
		protected static const JUMP_ACCELERATION:Number = 270;
		
		//子弹组
		//flxGroup 就是一种 组，有数组的储存，用于flixel的各种控制检测
		//用flxGroup 将多个 object 添加进 组，方便管理
		public var bullets:FlxGroup;
		//当前可以发射的子弹索引
		private var currentBul:uint = 0;
		
		[Embed(source = 'media/jump.mp3')]
		protected var jumpSnd:Class;
		[Embed(source = 'media/land.mp3')]
		protected var landSnd:Class;
		
		//加入玩家 挂掉时的 音效
		[Embed(source = 'media/asplode.mp3')]
		protected var killSnd:Class;
		
		//飞行背包的 喷气素材
		[Embed(source='media/jet.png')]
		protected var jetImg:Class;
		
		//飞行背包的音效
		[Embed(source = 'media/jetpack.mp3')]
		protected var sndJetPack:Class;
		
		//飞行背包 粒子发射器
		private var jetPack:FlxEmitter;
		
		//飞行背包的 气体 消失的时间，变量，计时用，-1为不计时
		private var jetPackCountDown:Number = -1;
		
		//飞行背包的气体消失时间的初始值，设置为0.5秒
		private const COUNT_DOWN:Number = 0.5;
		
		//初始化给个初始坐标，当然可以不用参数，不过super的时候一定要加上
		public function Player(startX:Number=100,startY:Number=50):void 
		{
			//这个是一定要要的
			//参数1：人物的初始 x 坐标
			//参数2：人物的初始 y 坐标
			//参数3：背景图片，不是作为人物素材图，填 null 就行了
			super(startX, startY, null);
			
			//加载人物素材图片
			//参数1：要加载的素材图的类名，Embed上面的那个
			//参数2：是否需要制作素材动画，
			//也就是说true的话，素材会被分割成很多小块，并保存为动画用，否则不会有动画
			//参数3：设置为true 的话 ，那么改Player的facing 属性(用于人物面朝方向)才有效果
			//类似于调整sprite的scaleX为-1（LEFT）/ 1（RIGHT）,自动调整对称点为中心点
			//第4、5个参数设置显示图片素材的 宽度和高度,以及该Player的有效碰撞矩阵范围
			//同时也作为分割素材动画小块的宽度和高度,具体可以打开 spaceman.png 来看看
			loadGraphic(playerImg, true, true, 8, 8);
			
			//drag像是摩擦力,当加速度小于drag的时候，就会慢慢停下来。
			//当人物不移动时，记得设置 加速度 为0,这样就会受摩擦力作用，人物缓慢停下
			//由于摩擦力是移动时受到的反作用力，所以是该值都是物体移动方向的反方向
			//即该值本身在算法中已经由公式运算时加入了方向判断，不需要人为再操作将它改成负数。
			//因此一般摩擦力最好设为正数，如果设为负数，那么这个摩擦力的方向就会和物体移动方向同向
			/** 注意 **/
			//drag 可以设置为0的，这样就不会有 缓慢开始移动和停下 的过程
			drag.x = PLAYER_RUN_SPEED * 8;
			
			//设置人物 y轴的加速度大小，相当于 重力加速度吧
			acceleration.y = GRAVITY_ACCELERATION;
			
			//设置人物 x轴的速度的最大值,
			//只需设置正数就行了，会自动判断反向的最大值的
			maxVelocity.x = PLAYER_RUN_SPEED;
			
			//设置人物 y轴的速度的最大值,同理也只需要设置正数
			maxVelocity.y = JUMP_ACCELERATION;
			
			//添加动画段，数组代表动画的节点位置
			//参数1：动画的名字
			//参数2：动画数组
			//由于上面loadGraphic的时候,已经将显示素材的宽度设置为8
			//所以动画的播放的时候，就是用节点数 乘以 显示素材的宽度来表示在原图中的像素位置（X坐标）
			//比如[1,2,3,0],显示宽度为8，就表示动画依次为原图像素的8、16，24，0的X坐标位置（对照素材图来看）
			//参数3：帧率，表示动画播放的快慢；
			//参数4：动画是否循环播放，默认为true
			/**  注意下  **/
			//这里用到的图片是单行的动作，如果素材图片是有多行的图片怎么办？
			//答案是一样的，假如图片 宽度 为24px，有3列动作，高度 为16px，有2行动作，
			//同样以 8  8 来分割宽和高
			//那么整个图片分割后的节点索引值排列如下：
			//*****   0   1   2
			//*****   3   4   5
			addAnimation("idle", [1]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("idle_up", [5]);
			addAnimation("run_up", [6, 7, 8, 5], 12);
			addAnimation("jump_up", [9]);
			addAnimation("jump_down", [10]);
			
			//添加飞行背包
			addJetPack();
		}
		
		//重写update 方法，用于控制
		public override function update():void
		{
			//人物移动设置
			//这里设置加速度为0，对应上面的注释说的drag的作用
			//当不按按钮的时候，人物加速度为0，就那么人物会收到drag影响而停下来
			acceleration.x = 0;
			
			//判断按的是 方向键 左还是右
			//有人会问，FlxG.keys.justPressed('LEFT')这种有什么区别
			//这个很明显的，justPressed 是 判断刚好按下去才会判断为true
			//而这个 是 一直按住 都会判断为 true
			//一般人物走动时都是一直按住方向键来移动的
			if(FlxG.keys.LEFT)
			{
				//按住左时，人物脸像左
				//这个就体现之前loadGraphic 方法中第三个参数reverse的作用了
				//因为我们的素材 只是单方向的，所以设置了true
				//facing为LEFT 的时候会反转方向
				//由于默认 RIGHT 为 正方向的，所以如果你的素材是以左为正方向的话
				//请去 PS 中调整下吧。。。
				facing = LEFT;
				
				//由于是要往左边走，drag的力度是向右的
				//所以此时 加速度设置 为 负数，这样做就抵消了 drag
				//人物也就不受到 “摩擦力”的作用了
				acceleration.x = -drag.x;
			}
			else if(FlxG.keys.RIGHT)
			{
				//这是往右的情况
				facing = RIGHT;
				
				//这里就说明了 drag为正数的时候，方向与人物移动方向相反
				acceleration.x = drag.x;
			}
			
			//按下 X 键 的时候，进行跳跃
			//onFloor是判断人物是否着地，初始化的时候值为 flase
			if(FlxG.keys.justPressed('X') && onFloor)
			{
				//跳跃的时候，人物的y轴速度是向上的
				velocity.y = -JUMP_ACCELERATION;
				
				//播放跳跃声音
				//参数1：播放的声音类
				//参数2：声音大小，默认为1
				//参数3：是否循环，默认为false
				FlxG.play(jumpSnd,1.0,false);
			}
			
			//以下是判断人物的一些速度状态来进行各种动画播放
			//看清楚 if，else if的判断，所以只会做其中一个，按优先级来排列判断内容
			if(velocity.y != 0)
			{
				//y轴速度不为0 的时候，播放跳跃的动画
				play("jump");
			}
			else if(velocity.x == 0)
			{
				//y轴速度为 0 了，就判断这里
				//x轴速度为0 的时候，播放闲暇的动画
				play("idle");
			}
			else
			{
				//y轴速度为 0 且 x轴速度不为 0，就播放跑步动画
				play("run");
			}
			
			//子弹发射设置
			//为了让教程的顺序比较好写，这里加了个判断
			//这样 子弹 就不需要在Player构造的时候必须存在了
			if (bullets!=null) 
			{
				//按 C 键 发射子弹吧
				if (FlxG.keys.justPressed('C')) 
				{
					//按 上 的时候 向上 发射子弹
					if (FlxG.keys.UP) 
					{
						//member 是 Array 类型，
						//存放在 bullets中的元素都可以通过 members 找到
						//shoot 的时候 将 player 的 x y 坐标作为初始点来调整
						bullets.members[currentBul].shoot(x, y-4, 0, -250);
					}else if (FlxG.keys.DOWN) 
					{
						//按下的时候向下 发射子弹
						bullets.members[currentBul].shoot(x, y+4, 0, 250);
					}else if (facing==LEFT) 
					{
						//人物面向左的时候 向左发射子弹
						//为什么不用 按下 左的时候呢
						//因为 不按按钮的时候 仍然需要可以发射子弹呢。。。
						bullets.members[currentBul].shoot(x-4, y, -250, 0);
					}else if(facing==RIGHT)
					{
						//人物面向右的时候 向右发射子弹
						bullets.members[currentBul].shoot(x+4, y, 250, 0);
					}
					//子弹已经发射，索引变成下一个的
					currentBul++;
					//求余数的运算，这样 索引就会 循环了
					currentBul %= bullets.members.length;
					
					/**  注意  **/
					//目前对 子弹 是否可以 发射，没有设置相应的属性 来进行判断
					//因此 当 按键够快，同时 子弹移动的速度 比较慢时
					//就可以明显的看到 发射出去的子弹 还没有消失
					//就被 马上 拉回来 重新发射出去
					//请同学们 自行 加入相应的判断，给个提示
					//比如给Bullet 加入一个 isShooting 的boolean 属性
				}
			}
			
			//按住 Space 键 开始飞行
			if (FlxG.keys.pressed('SPACE')) 
			{
				//播放喷气时的音效
				FlxG.play(sndJetPack);
				
				//on 这个属性，是指 粒子发射器 是否正在发射粒子。
				//这里判断 当 没有发射粒子时
				if (!jetPack.on) 
				{
					//粒子开始发射，
					//参数1：设置false，这样粒子就不会 一次性全部 发射完,而是一个接一个发射，并且会无限发射
					//参数2：设置0.02，每个粒子的发射间隔为 0.02秒
					jetPack.start(false, 0.02);
				}
					
				//将player 的 y 轴 加速度 设置为 这个值，方向向上
				this.acceleration.y = -JUMP_ACCELERATION;
					
				//设置 jetPack 的 x 和 y 坐标，
				//就是让 发射器 实时跟随者 Player
				jetPack.x = this.x + this.width * 0.5;
				jetPack.y = this.y + this.height;
					
				//设置为 -1
				jetPackCountDown = -1;
			}
				
			//当 放开 space 按键时
			if (FlxG.keys.justReleased('SPACE')) 
			{
				//计数器 设置这个值，也就是0.5秒，即开始计时
				jetPackCountDown = COUNT_DOWN;
					
				//同时Player 的y轴加速度变为 重力值
				this.acceleration.y = GRAVITY_ACCELERATION;
			}
			
			//当计数器 不为 -1时，也就是说 开始计时
			if (jetPackCountDown != -1) 
			{
				//计时器开始计时
				//每次 update 都会减去 一个 值
				//elapsed 就是 每次 update 经过的时间
				jetPackCountDown -= FlxG.elapsed;
					
				//当 计时器 减少到 0以下时
				if (jetPackCountDown<=0) 
				{
					//计时器 设置为 -1
					jetPackCountDown = -1;
					//同时将 飞行背包 kill 掉，这样气体就会消失
					jetPack.kill();
				}
			}
			
			/*** 切记 ***/
			//这个语句一定要加上去，只要重写了update，就一定要调用 super的update
			//否则不会刷新动画。。也不会响应你在这里所设置的控制
			super.update();
		}
		
		//重写这个碰到下方的方法，主要是加一个落地声音
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void 
		{
			//为什么要 速度大于50呢？
			//首先是因为，当人物在地面的时候，会不停的检测碰撞
			//那么hitBottom会不停的检测，如果不加一个速度判断
			//那么声音会不停的 播放
			//所以加一个速度值判断 就是为了 让人物在地面的时候（地面时y速度为0）
			//不会播放落地声音。。
			if (velocity.y > 50) 
			{
				//落地声音
				FlxG.play(landSnd);
			}
			super.hitBottom(Contact, Velocity);
		}
		
		//重写一下 kill方法
		override public function kill():void 
		{
			//主要是加入一个 播放 挂掉时的音效
			FlxG.play(killSnd);
			super.kill();
		}
		
		private function addJetPack():void
		{
			jetPack = new FlxEmitter();
			//创建粒子
			//参数1：粒子素材
			//参数2：粒子的最大数量
			jetPack.createSprites(jetImg, 15);
			//将粒子发射时的 x 和 y 轴速度 设置为0，让喷射的气体位置不变
			jetPack.setXSpeed(0, 0);
			jetPack.setYSpeed(0, 0);
			//设置粒子不会旋转
			jetPack.setRotation(0, 0);
			//设置粒子不受重力影响
			jetPack.gravity = 0;
			//记得添加到state 中。。
			FlxG.state.add(jetPack);
		}
	}
	
}