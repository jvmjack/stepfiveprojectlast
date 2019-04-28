<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/3/28/028
  Time: 13:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Title</title>
    <meta name="description" content=""/>
    <meta name="viewport" content="initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width"/>
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="css/login.css"/>
    <script type="text/javascript" src="js/jquery-3.0.0.js"></script>
    <script src="js/jquery-ui.js"></script>
    <script type="text/javascript"src="js/bootstrap.js"></script>
    <script type="text/javascript"src="js/jqPaginator.js"></script>

</head>
<body>
<div class="form_login  container">
    <div class="form_logo">
        <h1>用户登录</h1>
    </div>
    <form method="post" id="formlogin" action="/loginToCms">
        <div class="form-group">
            <i class="fa fa-user"></i> <input type="text" class="form-control"name="username" id="username1" placeholder="输入角色名" value="nick">
        </div>
        <div class="form-group">
            <i class="fa fa-key"></i> <input type="password"class="form-control" name="password" id="password"placeholder="输入密码" value="123">
        </div>
    </form>
    <%--注册--%>
    <div id="myModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header text-center">
                    <h4>注册用户</h4>
                </div>
                <div class="modal-body" style="">
                    <form>
                        <div><label>用&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;户:</label><input id="username" type="text" name="userName" placeholder="请输入用户名"/>
                        </div>
                        <div><label>密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码:</label><input id="pwd" type="password" name="password" placeholder="请输入密码"/>
                        </div>
                        <div><label>确认密码:</label><input id="repwd" type="password" placeholder="请再次输入密码"/></div>
                    </form>
                </div>
                <div class="modal-footer">
                    <%--&lt;%&ndash; //获取当前roleid&ndash;%&gt;--%>
                    <%--<div hidden="hidden" class="roleid" ></div>--%>
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="addUser()">确认</button>
                    <button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>
    <div>
        <button type="button"class="btn btn-info" onclick="mylogin()">登录
        </button>
        <button type="button" id="adduser" data-toggle="modal" data-target="#myModal"
                class="btn btn-success " onclick="clearModal()">注册
        </button>
    </div>

</div>


</body>
<script type="text/javascript">
    function mylogin() {
        var username = $("#username1").val();
        var password = $("#password").val();
        if ("" == username || undefined == username) {
            alert("角色不能为空");
            return;
        }
        if ("" == password || undefined == password) {
            alert("密码不能为空");
            return;
        }
        var data = {};
        data.username = username;
        data.password = password;
        $.ajax({
            type: 'get',
            url: '/loginCheck',
            data: data,
            cache: false,
            sync: true,
            success: function (json) {
                console.log(json.code)
                if (json.status == 200) {
                    if (0 == json.code) {
                        alert("角色名或密码错误");
                        return;
                    } else {
                        //alert("登陆成功");
                        $("#formlogin").submit();
                    }
                }
                else {
                    alert("系统错误");
                }
            },
            error: function () {
                alert("请求失败!");
            }
        });
    }

    function clearModal() {
        $("#username").val("");
        $("#pwd").val("");
        $("#repwd").val("");
    }


    //新增用户
    function addUser() {
        var username = $("#username").val();
        var password = $("#pwd").val();
        var repassword = $("#repwd").val();
        /*非空判断*/
        if ("" == username || undefined == username) {
            alert("角色名不能为空");
            return;
        }
        if ("" == password || undefined == password) {
            alert("密码不能为空");
            return;
        }
        if ("" == repassword || undefined == repassword) {
            alert("密码不能为空");
            return;
        }
        if (password != repassword) {
            alert("两次密码不一致");
            return;
        }

        var data = {};
        data.userName = username;
        data.password = password;
        //模态框中取到当前userid
        $.ajax({
            type: 'post',
            url: '/addUser',
            data: data,
            cache: false,
            sync: true,
            success: function (json) {

                alert(json.msg)
            },
            error: function () {
                alert("请求失败!");
            }
        });


    }
</script>

</html>
