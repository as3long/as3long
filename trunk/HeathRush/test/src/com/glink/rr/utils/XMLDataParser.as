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
	import com.glink.rr.data.ArrayResultData;
	import com.glink.rr.data.BooleanResultData;
	import com.glink.rr.data.NumberResultData;
	import com.glink.rr.data.RenRenData;
	import com.glink.rr.data.StringResultData;
	import com.glink.rr.data.admin.GetAllocationData;
	import com.glink.rr.data.friends.AreFriendsData;
	import com.glink.rr.data.friends.FriendsCollection;
	import com.glink.rr.data.friends.FriendsData;
	import com.glink.rr.data.friends.GetAppFriendsData;
	import com.glink.rr.data.friends.GetAppUserData;
	import com.glink.rr.data.friends.GetData;
	import com.glink.rr.data.friends.GetFriendsData;
	import com.glink.rr.data.invitations.GetInvitationInfoData;
	import com.glink.rr.data.invitations.InvitationInfoCollection;
	import com.glink.rr.data.invitations.InvitationInfoData;
	import com.glink.rr.data.users.GetInfoData;
	import com.glink.rr.data.users.RenRenUser;
	import com.glink.rr.data.users.RenRenUserCollection;
	import com.glink.rr.errors.RenRenError;
	import com.glink.rr.errors.RenRenErrorCodes;
	
	import flash.events.ErrorEvent;

	public class XMLDataParser implements IRenRenResultParser
	{
		private var xn_namespace:Namespace;
		
		public function XMLDataParser() {
			xn_namespace = new Namespace("http://api.xiaonei.com/1.0/");
		}
		
		public function parse(data:String, methodName:String):RenRenData
		{
			var result:RenRenData;
			var xml:XML = new XML(data);
		
			switch (methodName) {
				case 'auth.getSession':
//					result = new GetSessionData();
//					(result as GetSessionData).expires = RenRenXMLParserUtils.toDate(xml.fb_namespace::expires);
//					(result as GetSessionData).uid = RenRenXMLParserUtils.toStringValue(xml.fb_namespace::uid[0]);
//					(result as GetSessionData).session_key = xml.fb_namespace::session_key.toString();
//					(result as GetSessionData).secret = String(xml.fb_namespace::secret);
					break;
				case 'users.getInfo':
					result = parseGetInfo(xml); 
					break;
				case 'admin.getAllocation':
					result = parseGetAllocation(xml); break;
				case 'friends.getFriends':
					result = parseGetFriends(xml); break;
				case 'friends.getAppFriends':
					result = parseGetAppFriends(xml); break;
				case 'friends.get':
					result = parseGetFriendList(xml); break;
				case 'friends.areFriends':
					result = parseAreFriends(xml); break;
				case 'friends.getAppUsers':
					result = parseGetAppUsersData(xml); break;
				case 'invitations.getInfo':
					result = parseGetInvitationInfoData(xml); break;
				case 'notifications.sendEmail':
					result = parseSendEmail(xml); break;
				case 'users.isAppUser':
				case 'users.hasAppPermission':
				case 'feed.publishTemplatizedAction':
				case 'notifications.send':
				case 'profile.setXNML':
				case 'pay.isCompleted':
					result = new BooleanResultData();
					(result as BooleanResultData).value = RenRenXMLParserUtils.toBoolean(xml); break;
				case 'connect.getUnconnectedFriendsCount':
					result = new NumberResultData();
					(result as NumberResultData).value = RenRenXMLParserUtils.toNumber(xml); break;
				case 'connect.unregisterUsers':
				case 'connect.registerUsers':
					result = new ArrayResultData();
					(result as ArrayResultData).arrayResult = RenRenXMLParserUtils.toArray(xml); break;
				case 'auth.createToken':
				case 'users.getLoggedInUser':
				default:
					result = new StringResultData();
					(result as StringResultData).value = RenRenXMLParserUtils.toStringValue(xml);
					break;
			}
			
			result.rawResult = data;
			return result;
		}
		
		public function validateResponce(result:String):RenRenError
		{
			var error:RenRenError = null;
			var xml:XML;
			var xmlError:Error;
			
			var hasXMLError:Boolean = false;
			try {
				xml = new XML(result);
			} catch (e:*) {
				xmlError = e;
				hasXMLError = true;
			}
			
			if (hasXMLError == false) {
				if (xml.localName() == 'error_response') {
					error = new RenRenError();
					error.rawResult = result;
					error.errorCode = Number(xml.xn_namespace::error_code);
					error.errorMsg = xml.xn_namespace::error_msg;
					error.requestArgs = RenRenXMLParserUtils.xmlToUrlVariables(xml..arg);
				}
				
				return error;
			}
			
			if (hasXMLError == true) {
				error = new RenRenError();
				error.error = xmlError;
				error.errorCode = -1;
			}
			
			return error;
		}
		
		protected function parseGetInfo(xml:XML):GetInfoData {
			var collection:RenRenArrayCollection = new RenRenArrayCollection();
			var users:XMLList = xml.xn_namespace::user;
			var l:uint = users.length();
			for (var i:uint = 0;i<l;i++) {
				var user:RenRenUser = RenRenUserXMLParser.createUser(users[i], xn_namespace);
				collection.addItem(user);
			}
			var data:GetInfoData = new GetInfoData();
			data.userCollection = collection;
			return data;
		}
		
		public function createRenRenError(p_error:Object, p_result:String):RenRenError {
			var error:RenRenError = new RenRenError();
			error.rawResult = p_result;
			error.errorCode = RenRenErrorCodes.SERVER_ERROR;
			
			if (p_error is Error) {
				error.error = p_error as Error;
			} else {
				error.errorEvent = p_error as ErrorEvent;
			}
			return error;
		}
		
		protected function parseGetFriends(xml:XML):GetFriendsData {
			var getFriendsData:GetFriendsData = new GetFriendsData();
			var myFriends:RenRenUserCollection = new RenRenUserCollection();
			
			for each(var friend:* in xml.xn_namespace::friend) {
				var user:RenRenUser = new RenRenUser();
				user.uid = friend.xn_namespace::uid;
				user.name = friend.xn_namespace::name;
				user.tinyurl = friend.xn_namespace::tinyurl;
				user.headurl = friend.xn_namespace::headurl;
				myFriends.addItem(user);
			} 
			
			getFriendsData.friends = myFriends;
			return getFriendsData;
		}
		
		protected function parseGetAppFriends(xml:XML):GetAppFriendsData {
			var getAppFriendsData:GetAppFriendsData = new GetAppFriendsData();
			var myFriends:RenRenUserCollection = new RenRenUserCollection();
			
			var app_friends:XMLList = xml.xn_namespace::app_friend;
			if (app_friends != null) {
				for each(var friend:* in xml.xn_namespace::app_friend) {
					var user:RenRenUser = new RenRenUser();
					user.uid = friend.xn_namespace::uid;
					user.name = friend.xn_namespace::name;
					user.tinyurl = friend.xn_namespace::tinyurl;
					user.headurl = friend.xn_namespace::headurl;
					myFriends.addItem(user);
				} 
			} else {
				for each(var uid:* in xml.xn_namespace::uid) {
					var user2:RenRenUser = new RenRenUser();
					user2.uid = RenRenXMLParserUtils.toNumber(uid);
					myFriends.addItem(user2);
				} 
			}
			
			getAppFriendsData.friends = myFriends;
			return getAppFriendsData;
		}
		
		protected function parseGetFriendList(xml:XML):GetData {
			var uids:Array = RenRenXMLParserUtils.toUIDArray(xml);
			var getData:GetData = new GetData();
			getData.uids = uids;
			
			return getData;
		}
		
		protected function parseAreFriends(xml:XML):AreFriendsData {
			var areFriendsData:AreFriendsData = new AreFriendsData();
			var friendsCollection:FriendsCollection = new FriendsCollection();
			for each(var friend:* in xml.xn_namespace::friend_info) {
				var friendData:FriendsData = new FriendsData();
				friendData.uid1 = friend.xn_namespace::uid1;
				friendData.uid2 = friend.xn_namespace::uid2;
				friendData.are_friends = RenRenXMLParserUtils.toBoolean(XML(friend.xn_namespace::are_friends));
				friendsCollection.addItem(friendData);
			}
			areFriendsData.friendsCollection = friendsCollection;
			return areFriendsData;
		}
		
		protected function parseGetInvitationInfoData(xml:XML):GetInvitationInfoData {
			var getInvitationInfoData:GetInvitationInfoData = new GetInvitationInfoData();
			var invitationInfoCollection:InvitationInfoCollection = new InvitationInfoCollection();
			for each(var invitation:* in xml.xn_namespace::invitation_info) {
				var invitationInfoData:InvitationInfoData = new InvitationInfoData();
				invitationInfoData.type = invitation.xn_namespace::type;
				invitationInfoData.inviter_uid = invitation.xn_namespace::inviter_uid;
				invitationInfoData.invite_time = invitation.xn_namespace::invite_time;
				invitationInfoData.invitee_uid = invitation.xn_namespace::invitee_uid;
				invitationInfoCollection.addItem(invitationInfoData);
			}
			getInvitationInfoData.invitationInfoCollection = invitationInfoCollection;
			return getInvitationInfoData;
		}
		
		protected function parseGetAppUsersData(xml:XML):GetAppUserData {
			var uids:Array = RenRenXMLParserUtils.toUIDArray(xml);
			var appUserData:GetAppUserData = new GetAppUserData();
			appUserData.uids = uids;
			return appUserData;
		}
		
		protected function parseGetAllocation(xml:XML):GetAllocationData {
			var data:GetAllocationData = new GetAllocationData();
			data.notifications_per_day = Number(xml.xn_namespace::notifications_per_day.toString());
			data.requests_per_day = Number(xml.xn_namespace::requests_per_day.toString());
			return data;
		}
		
		protected function parseSendEmail(xml:XML):ArrayResultData {
			var arr:ArrayResultData = new ArrayResultData();
			arr.arrayResult = RenRenXMLParserUtils.toArray(xml);
			return arr;
		}
	}
}