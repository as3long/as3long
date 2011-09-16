package com.rush360.v 
{
	import com.rush360.i.IView;
	import org.aswing.border.EmptyBorder;
	import org.aswing.BorderLayout;
	import org.aswing.EmptyLayout;
	import org.aswing.ext.Form;
	import org.aswing.ext.FormRow;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JTextField;
	import flash.display.Sprite;
	
	/**
	 * 登录视图
	 * @author 360rush
	 */
	public class LoginView extends Sprite implements IView 
	{
		private var loginFrame:JFrame;
		private var nameLabel:JLabel;
		private var pwdLabel:JLabel;
		private var nameTextField:JTextField;
		private var pwdTextField:JTextField;
		
		private var  loginButton:JButton;
		
		private var loginForm:Form;
		
		public function LoginView() 
		{
			init();
		}
		
		private function init():void
		{
			loginForm = new Form();
			//loginForm.setBorder(new EmptyBorder(null, new Insets(2, 2, 2, 2)));
			loginFrame = new JFrame(this, "登录");
			nameLabel = new JLabel("用户名:");
			nameTextField = new JTextField("",8);
			loginForm.addRow(nameLabel, nameTextField);
			
			pwdLabel = new JLabel("密码:");
			pwdTextField = new JTextField("",8);
			loginForm.addRow(pwdLabel, pwdTextField);
			
			loginButton = new JButton("登录");
			loginForm.addRow(null,loginButton);
			
			loginFrame.setContentPane(loginForm);
			loginFrame.pack();
			loginFrame.show();
			loginFrame.setClosable(false);
			loginFrame.setResizable(false);
			loginFrame.setLocationXY(620,0);
		}
	}

}