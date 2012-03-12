package ghostcat.operation
{
	import ghostcat.events.OperationEvent;
	import ghostcat.util.Util;
	
	[Event(name="child_operation_start",type="ghostcat.events.OperationEvent")]
	[Event(name="child_operation_complete",type="ghostcat.events.OperationEvent")]
	[Event(name="child_operation_error",type="ghostcat.events.OperationEvent")]
	/**
	 * 同时处理多个操作，用于不需要排队的情况
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GroupOper extends Oper implements IQueue
	{
		/**
		 * 子对象数组 
		 */
		public var children:Array = [];
		/**
		 * 完成数量
		 */
		public var finishCount:int = 0;
		
		public function GroupOper(children:Array=null,holdInstance:Boolean = false)
		{
			super();
			
			if (!children)
				children = [];
				
			this.holdInstance = holdInstance;
			
			for (var i:int = 0;i < children.length;i++)
				commitChild(children[i] as Oper);
		}
		
		/**
		 * 推入队列
		 * 
		 */			
		public function commitChild(obj:Oper):void
		{
			obj.queue = this;
			obj.step = Oper.WAIT;
			
			children.push(obj);
		}
		
		/**
		 * 移出队列
		 * 
		 */
		public function haltChild(obj:Oper):void
		{
			obj.queue = null;
			obj.step = Oper.NONE;
			
			Util.remove(children,obj);
			if (children.length==0)
				result();
		}
		
		public override function execute():void
		{
			super.execute();
			
			finishCount = 0;
			
			for (var i:int = 0; i < children.length; i++)
			{
				var oper:Oper = children[i] as Oper;
				oper.addEventListener(OperationEvent.OPERATION_START,childStarthandler);
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,childCompleteHandler);
				oper.addEventListener(OperationEvent.OPERATION_ERROR,childCompleteHandler);
				oper.execute();
			}
		}
		
		private function childStarthandler(event:OperationEvent):void
		{
			var oper:Oper = event.currentTarget as Oper;
			oper.removeEventListener(OperationEvent.OPERATION_START,childStarthandler);
			
			var e:OperationEvent = new OperationEvent(OperationEvent.CHILD_OPERATION_START);
			e.oper = this;
			e.childOper = oper;
			dispatchEvent(e);
		}
		
		private function childCompleteHandler(event:OperationEvent):void
		{
			var oper:Oper = event.currentTarget as Oper;
			
			if (oper.continueWhenFail || event.type == OperationEvent.OPERATION_COMPLETE)
				endOperation(oper);
			else
				fault(event);
		
			var e:OperationEvent = new OperationEvent(event.type == OperationEvent.OPERATION_COMPLETE ? OperationEvent.CHILD_OPERATION_COMPLETE : OperationEvent.CHILD_OPERATION_ERROR);
			e.oper = this;
			e.childOper = oper;
			e.result = event.result;
			dispatchEvent(e);
		}
		
		private function endOperation(oper:Oper):void
		{
			oper.removeEventListener(OperationEvent.OPERATION_START,childStarthandler);
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,childCompleteHandler);
			oper.removeEventListener(OperationEvent.OPERATION_ERROR,childCompleteHandler);
			finishCount++;
			
			if (children.length == finishCount)
				result();
		}

	}
}