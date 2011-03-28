/*
MySQL Data Transfer
Source Host: localhost
Source Database: rush360
Target Host: localhost
Target Database: rush360
Date: 2011-3-28 18:43:58
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for users
-- ----------------------------
CREATE TABLE `users` (
  `userid` int(11) NOT NULL auto_increment,
  `uName` varchar(200) collate utf8_bin default NULL,
  `userAppId` int(11) default NULL,
  `userAppName` varchar(200) collate utf8_bin default NULL,
  `uSex` varchar(10) collate utf8_bin default NULL,
  `uPicUrl` varchar(500) collate utf8_bin NOT NULL,
  PRIMARY KEY  (`userid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `users` VALUES ('1', '测试', '200611175', '健康环跑', '男', '123');
INSERT INTO `users` VALUES ('2', '123', '123', '123', '女', '123');
