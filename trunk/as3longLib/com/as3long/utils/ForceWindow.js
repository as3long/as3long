/**
 * ...
 * @author 黄龙
 */

/**
 * 定义ForceWindow类构造函数
 * 无参数
 * 无返回值
 */
function ForceWindow ()
{
  this.r = document.documentElement;
  this.f = document.createElement("FORM");
  this.f.target = "_blank";
  this.f.method = "post";
  this.r.insertBefore(this.f, this.r.childNodes[0]);
}

/**
 * 定义open方法
 * 参数sUrl：字符串，要打开窗口的URL。
 * 无返回值
 */
ForceWindow.prototype.open = function (sUrl)
{
  this.f.action = sUrl;
  this.f.submit();
}

/**
 * 实例化一个ForceWindow对象并做为window对象的一个子对象以方便调用
 * 定义后可以这样来使用：window.force.open("URL");
 */
window.force = new ForceWindow();