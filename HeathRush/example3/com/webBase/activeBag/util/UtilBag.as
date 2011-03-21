package com.webBase.activeBag.util 
{
	import com.webBase.activeBag.util.objectString.Object2String;
	
	/**
	 * ...
	 * @author WZH(shch8.com)
	 */
	public class UtilBag 
	{
		/**
		 * 将对象转为字符串，转化后，可以用toObject还原成Object类型
		 * @param	obj 需要转化的对象
		 * @return
		 */
		public function toString(obj:Object):String {
			return Object2String.encode(obj);
		}
		/**
		 * 将经过toString()转化的字符串还原成对象
		 * @param	str	需要还原的字符串
		 * @return
		 */
		public function toObject(str:String):Object {
			return Object2String.decode(str);
		}
		 /**
		  * 字符省略，截取所定字符长度省略显示
		  * @param	str			原字符串
		  * @param	str_limt	限制长度
		  * @param	moreStr		省略时替加字符
		  * @return
		  */
		public function strLime(str:String,str_limt:int,moreStr:String=".."):String {
			if (str.length>str_limt) {//字符过长截取
				return str.substring(0,str_limt) + moreStr;
			}
			return str;
		}
		/**
		 * XML格式效正字符,用于XML表中因该禁用的字符: " ' < > &
		 * @param	char
		 * @return Boolean
		 */
		public  function checkSen(char:String):Boolean {
			var pattern:RegExp = /.\"|.\'|.<|.>|.&/;
			return ! pattern.test(char);
		}
		/**
		 * 字符型转布尔型
		 * @param	char
		 * @return
		 */
		public  function strToBoolean(char:String):Boolean {
			if (char == "true") {
				return true;
				}
			if (char == "true") {
				return false;
				}
			return false;
		}
		/**
		 * 数组顺序找法;
			从arr数组中查找数据key, 返回数组下标;
		 * @param	arr		数组
		 * @param	key		需查找的
		 * @return
		 */
		public  function orderSearch(arr:Array, key:*):int {
			arr.forEach(callback);
			var n:int;
			function callback(element:*, i:int, arr:Array):void {
				if (element == key) {
					n = i + 1;
					return;
				}
			}
			return (n > 0) ? n - 1 : -1;
		}
		/**
		 * 数组随机排序算法;
		 * @param	targetArray
		 * @return
		 */
		public  function arrayRandSort(targetArray:Array):Array {
			var arrayLength:Number=targetArray.length;
			//先创建一个正常顺序的数组
			var tempArray1:Array=[];
			for (var i:uint=0; i<arrayLength; i++) {
				tempArray1[i]=i;
			}
			//再根据上一个数组创建一个随机乱序的数组
			var tempArray2:Array=[];
			for (var j:uint=0; j<arrayLength; j++) {
				//从正常顺序数组中随机抽出元素
				tempArray2[j]=tempArray1.splice(Math.floor(Math.random() * tempArray1.length),1);
			}
			//最后创建一个临时数组存储 根据上一个乱序的数组从targetArray中取得数据
			var tempArray3:Array=[];
			for (var k:uint=0; k<arrayLength; k++) {
				tempArray3[k]=targetArray[tempArray2[k]];
			}
			//返回最后得出的数组
			return tempArray3;
		}
		/**
		 * 数组去除从复的,保留第一次出现的值;
		 * @param	arr
		 * @return
		 */
		public  function runSingle(arr:Array):Array{
			for (var i:uint; i < arr.length-1; i++ ) {
				for (var j:uint = i+1; j < arr.length; j++ ) {
					if (arr[i] == arr[j]) {
						arr.splice(j, 1);
						i = 0;
						}
					}
				}
				return arr;
		}
		/**
		 * 两个数组绝对比较是否相同
		 * @param	arr1
		 * @param	arr2
		 * @return
		 */
		public  function some(arr1:Array, arr2:Array):Boolean {
			if (arr1.length != arr2.length) return false;
			for (var i:uint; i < arr1.length; i++ ) {
				if (arr1[i] != arr2[i]) return false;
				}
				return true;
		}
		/**
		 * 查看数组中最大或最小的数
		 * @param	arr			数组
		 * @param	getMax		是否查找最大值，默认为是
		 * @return
		 */
		public  function getNumSearch(arr:Array,getMax:Boolean=true):Number{
			var low:int, maxNum:Number=0,getNum:*;
			low = 0;
			while (low < arr.length) {
				getNum=Number(arr[low])
				if(getNum*0==0){//是否为数字
				if (getMax) {
					if(getNum > maxNum) {
					  maxNum=getNum
					}
				 }else {
					 if(getNum <maxNum) {
					maxNum=getNum
					 }
				   }
				}
				low++
			}
			return maxNum;
		}
		/**
		 * 使用转意字符,为了在XML文档中使用,转成XMIFF替换符,请过滤(&)符再替换:" ' < >
		 * @param	string  需处理的字符
		 * @return  String
		 */
		public  function replyXmlStr(string:String):String {
			//tag1是双引号,tag2是单引号,tag3是&号
			replay("&","&amp;");
			replay("<","&lt;");
			replay(">","&gt;");
			replay("\"","&quot;");
			replay("\'","&apos;");
			function replay(restr:*,endstr:*):void {
				var end:*;
				var font:*;
				var usestr:String="";
				var pattern:RegExp=new RegExp("."+restr);
				while (pattern.test(string)) {//先过替换掉&符号
					end=string.indexOf(restr);
					font =string.substring(0, end);
					end = string.substring(end+1);
					usestr += font+endstr;
					string=end;
				}
				string=usestr+end;
			}
			return string;
		}
		/**
		 * 忽略大小字母比较字符是否相等;
		 * @param	char1	比较字符一
		 * @param	char2	比较字符一
		 * @return
		 */
		public  function equalsIgnoreCase(char1:String,char2:String):Boolean {
			return char1.toLowerCase() == char2.toLowerCase();
		}
		/**
		 * 判断是否为Email地址
		 * @param	char  判断字符
		 * @return
		 */
		public  function isEmail(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 判断是否是数值字符串;
		 * @param	char 判断字符
		 * @return
		 */
		public  function isNumber(char:String):Boolean {
			if (char == null) {
				return false;
			}
			return ! isNaN(Number(char));
		}
		/**
		 * 是否为Double型数据;
		 * @param	char 判断字符
		 * @return
		 */
		public  function isDouble(char:String):Boolean {
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否为整型
		 * @param	char
		 * @return
		 */
		public  function isInteger(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否为纯英文字符
		 * @param	char
		 * @return
		 */
		public  function isEnglish(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[A-Za-z]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否为中文字符
		 * @param	char
		 * @return
		 */
		public  function isChinese(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[\u0391-\uFFE5]+$/; ;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否为双字节符
		 * @param	char
		 * @return
		 */
		public  function isDoubleChar(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[^\x00-\xff]+$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否含有中文字符
		 * @param	char
		 * @return
		 */
		public  function hasChineseChar(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /[^\x00-\xff]/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 支持英文与数字注册字符;
		 * @param	char
		 * @param	len
		 * @return
		 */
		public  function hasAccountChar(char:String,len:uint=15):Boolean {
			if (char == null) {
				return false;
			}
			if (len < 10) {
				len = 15;
			}
			char = trim(char);
			var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,"+len+"}$", "");
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * URL地址;
		 * @param	char
		 * @return
		 */
		public  function isURL(char:String):Boolean {
			if (char == null) {
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
			var result:Object = pattern.exec(char);
			if (result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否为空白字符;
		 * @param	char
		 * @return
		 */
		public  function isWhitespace(char:String):Boolean {
			switch (char) {
				case " " :
					return true;
				case "\t" :
					return true;
				case "\r" :
					return true;
				case "\n" :
					return true;
				case "\f" :
					return true;
				default :
					return false;
			}
		}
		/**
		 * 清除换行符
		 * @param	char
		 * @return
		 */
		public  function clearLine(char:String):String {
			var pattern:RegExp = /\n/; 
			for (var i:uint=0; i<500; i++) {
				if (pattern.test(char)) {
					char=char.replace(pattern,"");
					
				} else {
					return char;
				}
			}
			return char;
		}
		/**
		 * 清除空格符;
		 * @param	char
		 * @return
		 */
		public  function clearSpace(char:String):String {
			var pattern:RegExp = /\s/; 
			for (var i:uint=0; i<500; i++) {
				if (pattern.test(char)) {
					char=char.replace(pattern,"");
					
				} else {
					return char;
				}
			}
			return char;
		}
		/**
		 * 去左右空格;
		 * @param	char
		 * @return
		 */
		public  function trim(char:String):String {
			if (char == null) {
				return null;
			}
			return rtrim(ltrim(char));
		}
		/**
		 * 去左空格; 
		 * @param	char
		 * @return
		 */
		public  function ltrim(char:String):String {
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /^\s*/;
			return char.replace(pattern,"");
		}
		/**
		 * 去右空格;
		 * @param	char
		 * @return
		 */
		public  function rtrim(char:String):String {
			if (char == null) {
				return null;
			}
			var pattern:RegExp = /\s*$/;
			return char.replace(pattern,"");
		}
		/**
		 * 是否为前缀字符串;
		 * @param	char
		 * @param	prefix
		 * @return
		 */
		public  function beginsWith(char:String, prefix:String):Boolean {
			return prefix == char.substring(0,prefix.length);
		}
		/**
		 * 是否为后缀字符串;
		 * @param	char
		 * @param	suffix
		 * @return
		 */
		public  function endsWith(char:String, suffix:String):Boolean {
			return (suffix == char.substring(char.length - suffix.length));
		}
		/**
		 * 去除指定字符串;
		 * @param	char
		 * @param	remove
		 * @return
		 */
		public  function remove(char:String,remove:String):String {
			return replace(char,remove,"");
		}
		/**
		 * 字符串替换;
		 * @param	char
		 * @param	replace
		 * @param	replaceWith
		 * @return
		 */
		public  function replace(char:String, replace:String, replaceWith:String):String {
			return char.split(replace).join(replaceWith);
		}
		/**
		 * utf16转utf8编码;
		 * @param	char
		 * @return
		 */
		public  function utf16to8(char:String):String {
			var out:Array = new Array();
			var len:uint = char.length;
			for (var i:uint=0; i<len; i++) {
				var c:int = char.charCodeAt(i);
				if (c >= 0x0001 && c <= 0x007F) {
					out[i] = char.charAt(i);
				} else if (c > 0x07FF) {
					out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),
					 0x80 | ((c >>  6) & 0x3F),
					 0x80 | ((c >>  0) & 0x3F));
				} else {
					out[i] = String.fromCharCode(0xC0 | ((c >>  6) & 0x1F),
					 0x80 | ((c >>  0) & 0x3F));
				}
			}
			return out.join('');
		}
		/**
		 * utf8转utf16编码;
		 * @param	char
		 * @return
		 */
		public  function utf8to16(char:String):String {
			var out:Array = new Array();
			var len:uint = char.length;
			var i:uint = 0;
			var char2:int,char3:int;
			while (i<len) {
				var c:int = char.charCodeAt(i++);
				switch (c >> 4) {
					case 0 :
					case 1 :
					case 2 :
					case 3 :
					case 4 :
					case 5 :
					case 6 :
					case 7 :
						// 0xxxxxxx
						out[out.length] = char.charAt(i-1);
						break;
					case 12 :
					case 13 :
						// 110x xxxx   10xx xxxx
						char2 = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
						break;
					case 14 :
						// 1110 xxxx  10xx xxxx  10xx xxxx
						char2 = char.charCodeAt(i++);
						char3 = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |
						((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
						break;
				}
			}
			return out.join('');
		}
		
	}
	
}