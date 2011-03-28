<?php

/**
 * 数据库测试类主要测试数据查询功能的完整性
 */

class dbTest extends spController {

   public function action() {
        $user = spClass("users");
        $userAppId = $this->spArgs("userAppId", 123);
        $sql = "select * from users where users.userAppId=" . $userAppId;
        $result = $user->findSql($sql);                                         // 执行查找
        //dump($result);                                                        //输出数组
        $json_Str = json_encode($result);
        if ($json_Str != "false") {
            echo $json_Str;
        }
    }

}