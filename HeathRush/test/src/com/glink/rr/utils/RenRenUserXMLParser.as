/*
  Copyright (c) 2010, Global Link Software Technology Centre
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Global Link Software Technology Centre nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.glink.rr.utils
{
	import com.glink.rr.data.RenRenEducationInfo;
	import com.glink.rr.data.RenRenHighSchoolInfo;
	import com.glink.rr.data.RenRenWorkInfo;
	import com.glink.rr.data.users.RenRenUser;
	
	public class RenRenUserXMLParser
	{
		public static function createUser(userProperties:XML, ns:Namespace):RenRenUser {
			var rrUser:RenRenUser = new RenRenUser();
			
			var props:XMLList = userProperties.children();
			var l:uint = props.length();
			var userNode:XML;
			var localName:String;
			
			for (var i:uint=0; i<l; i++) {
				userNode = props[i];
				localName = userNode.localName().toString();
				switch (localName) {
					//Custom Parsing
					case 'sex':
						rrUser[localName] = userNode.toString() == "1" ? "male" : "female"; break;
					case 'hometown_location':
						rrUser[localName] = RenRenXMLParserUtils.createLocation(userNode, ns); 
						break;
					case 'birthday':
						rrUser[localName] = userNode.toString();
						rrUser['birthdayDate'] = RenRenDataUtils.formatDate(userNode.toString()); 
						break;
					case 'hs_history':
						rrUser[localName] = parseHighSchoolHistory(userNode, ns); 
						break;
					case 'university_history':
						rrUser[localName] = parseEducationHistory(userNode, ns); 
						break;
					case 'work_history':
						rrUser[localName] = parseWorkHistory(userNode, ns); 
						break;
						
					//Number parsing
					case 'star':
					case 'vip':
						rrUser[localName] = uint(userNode.toString()); break;
						
					//Boolean parsing
					case 'zidou':
						rrUser[localName] = RenRenXMLParserUtils.toBoolean(userNode); break;
					
					//Default everything else to a String
					default:
						if (localName in rrUser) { //Check to make sure this isn't a new or un-supported property.
							rrUser[localName] = String(userNode);
						}
				}
			}
			
			return rrUser;
		}
		
		protected static function parseWorkHistory(xml:XML, ns:Namespace):Array {
			var work_history:Array = [];
			var xList:XMLList = xml.children();
			
			for each (var xWorkInfo:Object in xList) {
				var workInfo:RenRenWorkInfo = new RenRenWorkInfo();
				
				workInfo.company_name = String(xWorkInfo.ns::company_name);
				workInfo.description = String(xWorkInfo.ns::description);
				workInfo.start_date = RenRenDataUtils.formatDate(xWorkInfo.ns::start_date);
				workInfo.end_date = RenRenDataUtils.formatDate(xWorkInfo.ns::end_date);
				work_history.push(workInfo);
			}
			
			return work_history;
		}
		
		protected static function parseHighSchoolHistory(xml:XML, ns:Namespace):Array {
			var hs_history:Array = [];
			var xList:XMLList = xml.children();
			
			for each (var e:Object in xList) {
				var hsInfo:RenRenHighSchoolInfo = new RenRenHighSchoolInfo();
				hsInfo.name = String(e.ns::name);
				hsInfo.grad_year = String(e.ns::grad_year);
				hs_history.push(hsInfo);
			}
			
			return hs_history;
		}
		
		protected static function parseEducationHistory(xml:XML, ns:Namespace):Array {
			var education_history:Array = [];
			var xList:XMLList = xml.children();
			
			for each (var e:Object in xList) {
				var educationInfo:RenRenEducationInfo = new RenRenEducationInfo();
				educationInfo.name = String(e.ns::name);
				educationInfo.year = String(e.ns::year);
				educationInfo.department = String(e.ns::department);
				education_history.push(educationInfo);
			}
			
			return education_history;
		}
		
		protected static function toArray(xml:XML, ns:Namespace):Array {
			var arr:Array = [];
			var children:XMLList = xml.children();
			var l:uint = children.length();
			for (var i:uint=0;i<l;i++) {
				arr.push(children[i].toString());
			}
			
			return arr;
		}

	}
}