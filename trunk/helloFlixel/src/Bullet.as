package 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author zb
	 */
	public class Bullet extends FlxSprite 
	{
		[Embed(source = 'media/bullet.png')]
		protected var bulImg:Class;
		
		//发射子弹的声音
		[Embed(source = 'media/shoot.mp3')]
		protected var shootSnd:Class;
		//子弹碰到障碍物的声音
		[Embed(source = 'media/hit.mp3')]
		protected var hitSnd:Class;
		public function Bullet():void 
		{
			//记得每个FlxSprite的子类构造方法这里 都顺手写一个这个哦
			super(0, 0);
			
			//加载子弹的素材
			loadGraphic(bulImg, true, false, 8, 8);
			
			//设置子弹的动画
			//向上发射
			addAnimation('shootUp', [0]);
			//向下
			addAnimation('shootDown', [1]);
			//向左
			addAnimation('shootLeft', [2]);
			//向右
			addAnimation('shootRight', [3]);
			//爆炸动画，最后一个参数设置false，表示动画播不会循环播放
			addAnimation('BulBoom', [4, 5, 6, 7], 50, false);
			
			//exists,是所有flxObject的一个属性，表示该object是否存在
			//false,说明改物体不存在,flixel不会对他进行任何操作（碰撞检测等）
			//true，则说明改物体存在
			//当子弹没有发射出去的时候，自然不需要检测碰撞，所以设置 false
			exists = false;
		}
		
		/**
		 * 这个是子弹的发射方法
		 * @param	sPosX 子弹发射时的初始 x 坐标
		 * @param	sPosY 子弹发射时的初始 y 坐标
		 * @param	velX 设置子弹发射的 x轴 速度
		 * @param	velY 设置子弹发射的 y轴 速度
		 */
		public function shoot(sPosX:Number,sPosY:Number,velX:Number,velY:Number):void 
		{
			//reset方法，是将该object的一些属性重置
			//重置 exist 为 true ，dead（是否死亡）为 false
			//参数1：要将该object 重置到的 x坐标
			//参数2：要将该object 重置到的 y坐标
			reset(sPosX, sPosY);
			
			//将参数中的速度赋值给 子弹
			velocity.x = velX;
			velocity.y = velY;
			
			//根据速度判断子弹需要 播放哪个方向的动画
			if (velY < 0) 
			{
				//y速度小于 0，向上发射
				play('shootUp');
			}else if (velY > 0) 
			{
				//y速度大于 0，向下发射
				play('shootDown');
			}else if (velX < 0) 
			{
				//x速度小于0，向左发射
				play('shootLeft');
			}else if (velX > 0) 
			{
				//x速度大于0，向右发射
				play('shootRight');
			}
			
			//播放发射时的声音
			FlxG.play(shootSnd);
		}
		
		//当发射出去的子弹碰到障碍物之后，就会爆炸
		//所以重写碰撞方位的方法，加上hurt 方法，
		//这样碰到障碍物后，子弹会触发hurt方法，hurt是指本object受到伤害。
		/**
		 * 重写的 碰撞 物体 左边 和 右边 的方法
		 * @param	Contact 碰撞的对象，也就是 与 谁 发生了碰撞
		 * @param	Velocity 发生碰撞后，本 objcet 获得的一个 速度
		*/
		override public function hitSide(Contact:FlxObject, Velocity:Number):void 
		{
			//参数：该object 受到的伤害值，注意是本objcet，从 health值上减少
			//受到0点伤害，因为默认的health（生命值） 是1，所以填 0 子弹就不会受到伤害，
			//因为 health <= 0 的时候，就会触发 kill 方法，
			//而kill方法会设置 exist 会设置为 false，那么子弹就会马上消失
			//这不是我们想看到的，因为 子弹 爆炸的动画还没播放呢。。
			hurt(0); 
			
			//别忘了 重写以后 要 加上。。。
			super.hitSide(Contact,Velocity);
		}
		
		//这个是重写 碰到本object 上方时的方法
		override public function hitTop(Contact:FlxObject, Velocity:Number):void 
		{
			hurt(0);
			super.hitTop(Contact,Velocity);
		}
		
		//重写 碰到本object底部时的方法
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
		{
			hurt(0);
			super.hitBottom(Contact, Velocity);
		}
		
		//重写一下 hurt 方法,因为需要在 碰到障碍物的时候要设置些东东
		//比如 子弹速度 以及 播放爆炸的动画
		//参数：本objcet 所受到的 伤害值
		override public function hurt(Damage:Number):void 
		{
			//如果子弹已经dead了，那么就不在做 hurt 的操作
			//为什么不是 判断 exist ，因为 exist为 false 已经消失，不会受到任何渲染
			//而 dead 为 true时，虽然是死亡了，但是 仍然 被渲染，
			//我们需要的是，子弹 虽然 已经 死亡，但 仍然 可以看到 爆炸动画
			if (dead) 
			{
				return;
			}
			
			//子弹被碰一次直接设置dead为true，否则会不停调用该方法
			//同时也是为了在GameState中检测子弹与敌人触碰(不是碰撞检测，而是叠加检测)不发生连续伤害
			dead = true;
			
			//速度设置为0，因为碰撞后子弹爆炸是在 原地的
			//所以不需要移动了，当然如果你喜欢继续移动的爆炸的话。。。
			velocity.x = 0;
			velocity.y = 0;
			
			//播放爆炸动画了
			play('BulBoom');
			
			//至于为什么 不用 使用 super的 hurt 方法
			//因为本教程的子弹 碰撞后 是受到 0 伤害的
			//只要 完成 上面的几个语句就足够了
			//当然 加上也无妨，同学们可以看看 super 的hurt 方法的内容
			//就知道为什么这里可以不加了
			//super.hurt(Damage);
			
			//播放碰到障碍物时爆炸的声音
			FlxG.play(hitSnd);
		}
		
		override public function update():void 
		{
			//使用 dead 是判断子弹是否碰到障碍物而'死掉'，
			//使用 finish 是为了判断子弹的爆炸动画是否完成，
			//2个一起 就说明子弹完成动画并且'死掉'，这样子弹就消失了
			//至于为什么 super的update 只放在 else 里面
			//因为 子弹消失后 没必要再 update 了,还能省点CPU资源....
			//还是那句话，要也无妨。。。
			if (dead && finished) 
			{
				exists = false;
			}else 
			{
				super.update();
			}
		}
	}
	
}