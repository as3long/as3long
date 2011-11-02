package 
{
	import com.rush360.manage.MManage;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author zb
	 */
	public class GameState extends FlxState 
	{
		//人物。。懂的
		protected var player:Player;
		
		//一个地图块，没地板就要进入黑洞了。。
		//地图素材
		[Embed(source='media/tech_tiles.png')]
		protected var tileImg:Class;
		//地图块
		protected var groundTile:FlxTileblock;
		
		//子弹组，在这里也加个，方便使用哈
		private var bullets:FlxGroup;
		
		//地图制作用
		//地图宽度
		static public const MAP_WIDTH:Number = 640;
		//地图高度
		static public const MAP_HEIGHT:Number = 480;
		
		//素材中每个小砖块的宽度
		static private const TILE_BLOCK_WIDTH:Number = 8;
		//随机地图中一个矩形平台一个方向(水平方向或垂直方向)的最大的砖块数量
		//比如 最大的一个平台的砖块数 是 4*4=16
		static private const MAX_TILE_BLOCK_NUM:uint = 4;
		///随机地图中一个矩形平台一个方向(水平方向或垂直方向)的最大的砖块数量
		static private const MIN_TILE_BLOCK_NUM:uint = 2;
		//每次进行随机平台生成的时候，重复的次数，用法见下面算法中解释
		static private const RANDOM_LOOP_COUNT:int = 5;
		//我们用一个 flxGroup来储存 生成的 随机平台
		protected var levels:FlxGroup;
		
		//敌人组
		private var enemyGroup:FlxGroup;
		//最大生成敌人数量
		static public const ENEMY_COUNT:int = 10;
		
		//背景音乐
		[Embed(source = 'media/mode.mp3')]
		protected var bgMusic:Class;
		
		//敌人计数器
		private var enemyCounter:FlxText;
		
		//金币组
		private var coinGroup:FlxGroup;
		
		public var coinNum:int = 0;
		override public function create():void 
		{
			//本来打酱油的 hello flixel 文本 可以丢掉了
			//add(new FlxText(50, 100, 200, 'Hello Flixel !!'));
			
			//在添加人物前，先建立一个地板。。。
			//先看此方法
			//addGround();
			
			//这个是添加人物
			//看完地图建立后，看这里
			addPlayer();
			
			//下面是一些游戏功能的东东，很有用的
			addStateFuntion();
			
			//添加子弹
			//addBullets();
			
			//加入随机地图
			//addRandomMap();
			
			//加入敌人
			//addEnemies();
			
			//添加背景音乐
			addBackGroundMusic();
			
			//加入敌人计数器
			//addEnemyCounter();
			
			//加入移动平台
			addMovingPlatForms();
			
			//加入可以拾取的金币
			addCoins();
		}
		
		private function addGround():void
		{
			//新建地图块实例
			//参数1：该地图块的x 坐标
			//参数2：该地图块的y 坐标
			//参数3：该地图块的宽度
			//参数4：该地图块的高度
			groundTile = new FlxTileblock(0, 200, 640, 20);
			
			//加载地图素材
			//参数1：图片素材的类
			//参数2：素材中每一个小块的宽度
			//参数3：素材中每一个小块的高度
			//参数4：构建地图块的时候，设置空白格子的数量
			/**  注意  **/
			//这里参数 2，3 都填了0（默认为 0），是因为引擎的自己的默认算法，
			//具体算法是不是默认为宽高均为8就不清楚了
			//参数4这里也填0（默认为 0），空白数量是根据填的 按一个比例算法进行的
			//各位同学可以自己试着改改参数看看效果。。
			groundTile.loadTiles(tileImg, 0, 0, 0);
			
			//这里讲 groundTile  add到 state中了
			add(groundTile);
			
		}
		
		private function addPlayer():void
		{
			player = new Player(100, 50);
			add(player);
		}
		
		private function addStateFuntion():void
		{
			//镜头追踪
			//想要屏幕跟随人物的移动就靠他了
			//参数1：追踪的对象
			//参数2：镜头移动的缓动系数
			FlxG.follow(player,2.5);
			
			//追踪缓动参数设置
			//这个是对follow 的系数进一调整
			//参数1：x轴的缓动的比例系数,当做是翻译理解吧。。
			//参数2：y轴的缓动的比例系数
			/** 注意 **/
			//可能有同学对系数这概念不好理解，但是自己试下改改参数的值就明白了
			FlxG.followAdjust(0.5, 0.0);
			
			//追踪镜头的移动范围
			//应该很好理解的，就是一个矩阵范围
			FlxG.followBounds(0, 0, 640, 480);
			
			//设置地图边界
			//边界设置，超过边界的东东即便显示，也不会进行碰撞检测等
			//可以试试将640 改为200，然后人物向右边移动就明白了
			//不设置会默认无限大
			//看清楚 是  FlxU 类哦！！！
			/**  注意  **/
			//对于 FlxG 和 FlxU 到底都有什么功能，直接看官方的 API吧，包里面有文档
			FlxU.setWorldBounds(0, 0, 640, 480);
		}
		
		private function addBullets():void
		{
			//建立bullets 的组
			bullets = new FlxGroup();
			
			//单个 子弹，循环生成使用
			var bul:Bullet;
			
			//生成 10个子弹，可以根据实际情况来改变生成的 子弹数量
			//这么做的目的，是为了 子弹可以重复利用。。。
			//要不然 不停的 add 岂不是浪费了。。
			for (var i:int = 0; i < 10; i++) 
			{
				bul = new Bullet();
				//将子弹 加入到 bullets 这个组里面，用 add 方法
				bullets.add(bul);
			}
			//同时将 bullets  add 到 state 中，这样就可以显示子弹了
			add(bullets);
			
			//将生成好的 bullets 放进 player 的里面
			player.bullets = bullets;
		}
		
		private function addRandomMap():void
		{
			levels = new FlxGroup();
			//生成地图边界
			var tile:FlxTileblock;
			//地图的左边界
			tile = new FlxTileblock(0, 0, 8, MAP_HEIGHT);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//地图的下边界
			tile = new FlxTileblock(0, MAP_HEIGHT-8, MAP_WIDTH, 8);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//地图的右边界
			tile = new FlxTileblock(MAP_WIDTH-8, 0, 8, MAP_HEIGHT);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//地图的上边界
			tile = new FlxTileblock(0, 0, MAP_WIDTH, 8);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//将levels 组加入到显示列表中
			//注意，只要 flxGroup 被添加进入了 显示列表，
			//后面 再 加入组的 object 也会自动加入显示列表中
			add(levels);
			
			//下面就是生成随机平台了，这里生成 150 个平台
			for (var i:int = 0; i < 150; i++) 
			{
				addRandomTile();
			}
		}
		
		private function addRandomTile():void
		{
			//随机矩形平台的实例
			var newTile:FlxTileblock;
			//随机矩形平台的宽度
			var blockWidth:Number;
			//随机矩形平台的高度
			var blockHeight:Number;
			//随机平台的 x 坐标
			var blockX:Number;
			//随机平台的 y 坐标
			var blockY:Number;
			
			//这个是用来判断 这次新生成的 平台，是否与 之前的平台 重叠
			var newTileIsOverlapOthers:Boolean = false;
			//重新生成随机平台的重复次数，用在 当与之前的 平台重叠时
			//取消并重新生成一个新的平台，再进行 重叠判断
			//当 重复次数 超过规定的 最大重复 次数时，则取消本次 随机平台的生成
			var loopCount:int = 0;
			
			//进行本次随机平台的生成与重叠判断循环
			do {
				//计算随机平台的宽度
				// int(Math.random() * (MAX_TILE_BLOCK_NUM - MIN_TILE_BLOCK_NUM) + MIN_TILE_BLOCK_NUM)
				// 上面这个是 水平方向的 砖块数量
				// * TILE_BLOCK_WIDTH ，然后 砖块数量 乘上 砖块的 宽度，
				//就是平台的宽度了 
				blockWidth = int(Math.random() * (MAX_TILE_BLOCK_NUM - MIN_TILE_BLOCK_NUM) + MIN_TILE_BLOCK_NUM) * TILE_BLOCK_WIDTH;
				
				//计算随机平台的高度
				//因为 这里素材中 砖块的高度和宽度 都是 8，所以就不再额外加入 高度的静态值了
				blockHeight = int(Math.random() * (MAX_TILE_BLOCK_NUM - MIN_TILE_BLOCK_NUM) + MIN_TILE_BLOCK_NUM) * TILE_BLOCK_WIDTH;
				
				//计算平台的 x 坐标位置
				//MAP_WIDTH / TILE_BLOCK_WIDTH，这个是先计算出 地图的宽度 相当于多少个小砖块的数量
				//使用 random ，得到一个 砖块数的 随机值
				// - MAX_TILE_BLOCK_NUM，接着减去一个 每个随机平台的 最大数量，
				//就可以保证 平台的位置 不会超过 地图边界
				// * TILE_BLOCK_WIDTH，最后乘上小砖块的宽度，算出平台的 x 坐标
				blockX = int(Math.random() * MAP_WIDTH / TILE_BLOCK_WIDTH - MAX_TILE_BLOCK_NUM) * TILE_BLOCK_WIDTH;
				//同样算出 y 坐标
				blockY = int(Math.random() * MAP_HEIGHT / TILE_BLOCK_WIDTH - MAX_TILE_BLOCK_NUM) * TILE_BLOCK_WIDTH;
				
				//这里就生成一个 随机的砖块了
				newTile = new FlxTileblock(blockX, blockY, blockWidth, blockHeight);
				newTile.loadTiles(tileImg);
				
				//遍历levels 组中的 平台
				for each (var existTile:FlxTileblock in levels.members) 
				{
					//当 新生成的 平台 与 之前的平台 重叠的话
					//就会返回 true
					//overlaps方法，判断 本object 是否与 参数中的 object 重叠
					newTileIsOverlapOthers = newTile.overlaps(existTile);
					
					//如果 发生重叠了 ，就停止遍历
					if (newTileIsOverlapOthers) 
					{
						break;
					}
				}
				
				//重复次数 增加 1
				++loopCount;
				
				//当 发现 重叠 并且 重复次数 小于 最大重复次数时
				//回到循环，并重新 生成一个新的 随机平台
				//再与 之前 的平台 进行 重叠 判断
				//最大重复 次数 为 RANDOM_LOOP_COUNT
				//如果 不重叠，或者 重复次数 超过 最大重复次数
				//结束循环
			}while (newTileIsOverlapOthers && loopCount < RANDOM_LOOP_COUNT)
			
			//不管 本次生成的 随机平台 是否与之前的 重叠
			//都会加入到 平台 组中
			//由于 有 一定的 重复机会
			//所以 不重叠的 概率 也有 一定保证
			levels.add(newTile);
		}
		
		private function addEnemies():void
		{
			enemyGroup = new FlxGroup();
			//
			var enemyCount:int = 0;
			var enemy:Enemy;
			//这里判断生成 敌人的 方法 和 生成随机平台的 方法类似
			//首先一个个遍历平台，然后判断其他平台是否与当前平台的敌人初始位置重叠
			//重叠的话 就跳到下一个 平台来判断
			//没有重叠到初始位置的话，就在该平台上添加敌人
			//具体算法就不解释了。。比较麻烦。。
			for each (var tile1:FlxTileblock in levels.members) 
			{
				var enemyStartX:Number = tile1.x;
				var enemyStartY:Number = tile1.y;
				var collides:Boolean = false;
				
				if (enemyStartX<=0 || enemyStartY<=0) 
				{
					continue;
				}
				
				for each (var tile2:FlxTileblock in levels.members) 
				{
					var collideX:Number = enemyStartX;
					var collideX2:Number = collideX + TILE_BLOCK_WIDTH;
					var collideY:Number = enemyStartY - TILE_BLOCK_WIDTH;
					var collideY2:Number = enemyStartY;
					
					if (tile1 != tile2 && (tile2.overlapsPoint(collideX, collideY) ||
					tile2.overlapsPoint(collideX, collideY2) ||
					tile2.overlapsPoint(collideX2, collideY) ||
					tile2.overlapsPoint(collideX2, collideY2) ))
					{
						collides = true;
						break;
					}
				}
				if (!collides) 
				{
					//生成一个敌人，并加入 敌人组
					enemy = new Enemy(enemyStartX, enemyStartY, tile1.width);
					enemyGroup.add(enemy);
					enemyCount++;
					//trace(enemy.x, enemy.y);
				}
				if (enemyCount == ENEMY_COUNT) 
				{
					break;
				}
			}
			//将敌人组加入 state中
			add(enemyGroup);
		}
		
		private function addMovingPlatForms():void
		{
			//这个判断主要是配合教程来做
			//如果使用了 addRandomTile 方法的话，这里就需要加个判断。。
			//为了方便查看移动平台的效果，建议 注释掉 addRandomTile 方法
			if (levels==null) 
			{
				levels = new FlxGroup();
			}
			
			//加入一个地板。。。
			var tile:FlxTileblock = new FlxTileblock(0, 470, 640, 8);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			tile= new FlxTileblock(0, 0, 8, 480);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			tile= new FlxTileblock(632,0, 8, 480);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//这个是水平和垂直方向都移动的平台
			tile = new MovingPlatform(240, 30, 8 * 20, 8,140,120,false);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//这个是水平和垂直方向都移动的平台
			tile = new MovingPlatform(140, 200, 8 * 10, 8,350,250);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//只 水平移动的平台
			tile = new MovingPlatform(100, 180, 8 * 10, 8,400,0);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			//只垂直移动的平台
			tile = new MovingPlatform(120, 0, 8 * 10, 8,0,120,false);
			tile.loadTiles(tileImg);
			levels.add(tile);
			
			add(levels);
		}
		
	    override public function update():void 
		{
			//碰撞检测，不然 人物就不会和地板发生碰撞了
			//这个也是 FlxU 类哦！！！
			FlxU.collide(player, groundTile);
			
			//当然这么碰撞判断也可以的,反过来用groundTile来使用collide方法也可以的
			//player.collide(groundTile);
			
			//检测子弹与障碍物的碰撞
			//试着 人物向下 发射子弹，就看到碰撞效果了
			//FlxU.collide(bullets, groundTile);
			
			//加入 子弹 与 现在 的 levels 碰撞检测
			FlxU.collide(bullets, levels);
			//人物与 levels 碰撞检测
			FlxU.collide(player, levels);
			
			//检测敌人与 平台的碰撞
			//FlxU.collide(enemyGroup, levels);
			
			//检测子弹与敌人的重叠
			/** 注意 **/
			//不用collide 是因为 2个运动的object 碰撞时 会被反弹
			//overlaap方法，检测重叠，参数1 和 参数2 均为检测对象，顺序随意
			//参数3：这个是检测到重叠时，执行的方法
			//一般最好加上，因为如果 执行的方法 为null 时，
			//被检测的2个object 就会 被将 exist 设置为 false。。
			//我们这里检测重叠时需要看到 子弹的爆炸动画。。
			//FlxU.overlap(bullets, enemyGroup, hitEnemy);
			
			//检查敌人数量
			//checkEnemyCount();
			
			//使用 overlap 的方法，检测 玩家与平台重叠时
			//就会将 player 挤压到 挂掉
			FlxU.overlap(player, levels, squashingthePlayer);
			
			//注意,如果 collide 方法 放在 overlap 方法之后，那么 coin 不会弹起来
			//因为如果先是 overlap 判断，然后在判断 collide 的话，顺序是
			//overlap 时，给 coin 赋值 y 的速度，但是并没有update数据，
			//接着判断 collide，此时因为 coin 与地面还是碰撞着的，
			//所以 collide 判断又把 coin 的 y 速度变为了0,
			//下面接着的update 刷新了数据，此时coin y速度为0，coin 也就不会弹起来
			FlxU.collide(coinGroup, levels);
			FlxU.overlap(player, coinGroup, getCoin);
			
			if (FlxG.keys.justPressed('R')) 
			{
				MManage.instance.gameState = new GameState();
				FlxG.state = MManage.instance.gameState;
				MManage.instance.gameStartTime = new Date();
			}
			//还是要提醒下，别忘了加上。。。
			super.update();
			
		}
		
		private function squashingthePlayer(obj1:FlxSprite,obj2:FlxSprite):void
		{
			//这里让 player 受到 1000点的伤害
			//player 默认 生命值 为 10点
			//这样 player 就会被 kill
			obj1.hurt(1000);
		}
		
		//注意参数
		//obj1 对应 overlap中的第一个参数里面的对象，
		//obj2 对应 overlap中的第二个参数里面的对象
		//如果是组，就会判断到组的具体对象
		//因此这里的 obj1 会是 bullet，obj2 就是 enemy
		private function hitEnemy(obj1:FlxObject,obj2:FlxObject):void
		{
			if (obj2.dead) 
			{
				trace('zz')
			}
			//判断 obj1（即 bullet）是否死亡
			//死亡则返回不做操作
			//这么做是因为 子弹 死亡了，还在播放爆炸动画
			//爆炸的时候就不需要 执行 敌人被 hurt 的方法
			//当然 除非你需要 制作 持续伤害的 子弹
			//根据 需要来设置吧
			if (obj1.dead) 
			{
				return;
			}
			//这里子弹执行 被 hurt 的方法，发生爆炸
			obj1.hurt(0);
			//敌人被 hurt 1点伤害
			obj2.hurt(1);
		}
		
		
		
		private function addBackGroundMusic():void
		{
			//play 和 playMusic 有什么区别？
			//区别就是在于 play 方法的 第三个参数：Looped
			//playMusic 没有这个 Looped ，是因为这个方法是播放循环音乐
			//相当于 play 方法的 Looped 参数设置为 true，默认为false
			FlxG.playMusic(bgMusic);
		}
		
		private function addEnemyCounter():void
		{
			//加入一个文本，显示敌人的数量
			enemyCounter = new FlxText(150, 20, 20, String(ENEMY_COUNT));
			
			//scrollfactory 属性
			//表示 该对象 在屏幕移动的时候
			//跟着屏幕一起移动的比例，范围 在 0 到 1 这个区间
			//0 表示 不与屏幕移动
			//1表示 完全跟着屏幕移动
			//而之间的范围 从 0 开始，越大，随着屏幕移动的距离越大
			//具体同学们可以自行设置参数理解
			//x 和 y 分表表示 对水平移动和垂直移动的比例
			enemyCounter.scrollFactor.x = 0;
			enemyCounter.scrollFactor.y = 0;
			add(enemyCounter);
		}
		
		private function checkEnemyCount():void
		{
			//计数值，刷新查看 当前敌人组中 死亡敌人的数量
			var count:int = 0;
			for each (var enemy:Enemy in enemyGroup.members) 
			{
				if (enemy.dead) 
				{
					count++;
				}
			}
			
			//这里刷新 剩余敌人数量的文本
			enemyCounter.text = String(ENEMY_COUNT - count);
			
			//当 死亡敌人的数量达到 最大敌人数的时候
			if (count==ENEMY_COUNT) 
			{
				//过渡白色 ，结束后转跳 胜利状态
				FlxG.fade.start(0xffffffff, 1, onVictroy);
			}
		}
		
		private function onVictroy():void
		{
			//停止音乐
			FlxG.music.stop();
			FlxG.state = new VictoryState;
		}
		
		private function addCoins():void
		{
			coinGroup = new FlxGroup();
			var coin:Coin;
			for (var i:int = 0; i < 15; i++) 
			{
				coin = new Coin(100 + i * 10, 20);
				coinGroup.add(coin);
			}
			add(coinGroup);
		}
		
		private function getCoin(ob1:FlxSprite,ob2:FlxSprite):void 
		{
			var coin:Coin = ob2 as Coin;
			//当金币没有被获取时，才获取金币
			if (!coin.hasGotten) 
			{
				coin.getCoin();
			}
		}
	}
	
}