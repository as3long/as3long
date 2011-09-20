package com.rush360.v
{
	import com.rush360.i.IView;
	import flash.display.Sprite;
<<<<<<< .mine
	import org.aswing.*;
	import org.aswing.ext.*;
=======
	import org.aswing.*;
	import org.aswing.ext.*;
	
>>>>>>> .r87
	/**
	 * 注册视图
	 * @author 360rush
	 */
	public class RegistView extends RushViewBase
	{
<<<<<<< .mine
		/**
		 * 注册的窗口
		 */
		private var registFrame:JFrame;
		/**
		 * 用户名
		 */
		private var nameLabel:JLabel;
		/**
		 * 密码
		 */
		private var pwdLabel:JLabel;
		/**
		 * 用户名输入
		 */
		private var nameTextField:JTextField;
		/**
		 * 密码输入
		 */
		private var pwdTextField:JTextField;
		/**
		 * 第二次密码
		 */
		private var secondPwdLabel:JLabel;
		/**
		 * 第二次密码输入
		 */
		private var secondPwdTextField:JTextField;
		/**
		 * 邮箱
		 */
		private var emailLabel:JLabel;
		/**
		 * 邮箱输入
		 */
		private var emailTextField:JTextField;
=======
		private var registFrame:JFrame;
		private var nameLabel:JLabel;
		private var pwdLabel:JLabel;
		public var nameTextField:JTextField;
		public var pwdTextField:JTextField;
>>>>>>> .r87
		
<<<<<<< .mine
		private var registForm:Form;
		
		public function RegistView() 
=======
		public var registForm:Form;
		
		public function RegistView()
>>>>>>> .r87
		{
			init();
		}
		
		override public function init():void
		{
<<<<<<< .mine
			registForm = new Form();
			registFrame = new JFrame(this, "注册");
			
=======
			registFrame = new JFrame(this, "注册");
			registForm = new Form();
			//registFrame.
>>>>>>> .r87
			nameLabel = new JLabel("用户名:");
			nameTextField = new JTextField("", 8);
			registForm.addRow(nameLabel, nameTextField);
			
			pwdLabel = new JLabel("密码:");
			pwdTextField = new JTextField("", 8);
			registForm.addRow(pwdLabel, pwdTextField);
			
			secondPwdLabel = new JLabel("确认密码:");
			secondPwdTextField = new JTextField("", 8);
			registForm.addRow(secondPwdLabel, secondPwdTextField);
			
			emailLabel = new JLabel("邮箱:");
			emailTextField = new JTextField("", 8);
			registForm.addRow(emailLabel, emailTextField);
			
			registFrame.setContentPane(registForm);
			registFrame.setResizable(false);
			registFrame.pack();
			registFrame.show();
		}
	
	}

}