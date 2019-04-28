<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/3/28/028
  Time: 14:08
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<html>

<head>
    <title>权限展示</title>
    <script type="text/javascript" src="/js/jquery-3.0.0.js"></script>
    <script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
</head>
<div class="container">
    <div style="height: 500px;">
        <div class="col-lg-4">
            <div class="text-center"><kbd>一级权限</kbd></div>
            <c:forEach items="${parentList}" var="permission">
                <div hidden="hidden">${permission.id}</div>
                <a class="list-group-item text-center active" onmouseover="showbtn(this)" onmouseout="hidebtn(this)"
                   onclick="showMsg(this)">
                        ${permission.name}
                    <div style="float: right;" hidden="hidden">
                            <button type="button" class="btn btn-warning btn-xs" onclick="addPermission(${permission.id},this)">
                                <span class="glyphicon glyphicon-pencil"></span> 增加
                            </button>
                            <button type="button" class="btn btn-warning btn-xs" data-toggle="modal"
                                    data-target="#modal"
                                    onclick="updatePermission(${permission.id},'${permission.name}')">
                                <span class="glyphicon glyphicon-pencil"></span> 修改
                            </button>
                            <button type="button" class="btn btn-danger btn-xs"
                                    onclick="deletePermission(${permission.id})">
                                <span class="glyphicon glyphicon-remove"></span> 删除
                            </button>
                    </div>
                </a>
            </c:forEach>


        </div>

        <div class="col-lg-4 col-lg-push-0">
            <div class="text-center"><kbd>二级权限</kbd></div>

        </div>
        <div class="col-lg-4 col-lg-push-0">
            <div class="text-center"><kbd>三级权限</kbd></div>
        </div>
    </div>
    <%--修改的模态框--%>
    <div id="modal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header text-center">
                    <h4>权限修改</h4>
                </div>
                <div hidden="hidden" id="pid"></div>
                <div class="modal-body">
                    <label>权限名：</label><input id="permissionName" type="text" value="">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="submitChange()">确认
                    </button>
                    <button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>

    <%--增加的模态框--%>
    <div id="myModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header text-center">
                    <h4>增加权限</h4>
                </div>
                <div hidden="hidden" id="parentid"></div>
                <div class="modal-body">
                    <label>权限名：</label><input id="addName" type="text" value="">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="submitAdd()">确认</button>
                    <button type="button" class="btn btn-warning" onclick="hideModal()">取消</button>
                </div>
            </div>
        </div>
    </div>

    <%--认证--%>
    <div class="container text-center">
       <h2>欢迎<shiro:principal></shiro:principal>用户</h2>
        <shiro:hasAnyRoles name="manager,admin">
            <button id="addPermission" class=" btn btn-danger"onclick="addPermission(0,this)">添加一级权限</button>
        </shiro:hasAnyRoles>
        <button id="rolemange" class=" btn bg-danger"> <a href="/showRole"/>角色管理</button>
        <button id="usermanage" class="btn bg-danger"><a href="/showUser?pageSize=3&pageNum=1"/> 用户管理</button>
    </div>
</div>

<div>
    <a href="/login.jsp">返回登录页面</a>
</div>


</body>
<script type="application/javascript">
    function showbtn(obj) {
        $(obj).find("div").removeAttr("hidden")
    }

    function hidebtn(obj) {
        $(obj).find("div").attr("hidden", "hidden")
    }

    function showMsg(obj) {
        $(obj).parent().find("a").removeClass("active")
        $(obj).addClass("active")
        //先将生成的二级三级权限清空
        $(obj).parent().next().find("a").remove();
        $(obj).parent().next().next().find("a").remove();
        //展示子权限的div
        var $parDiv = $(obj).parent().next();
        var data = {};
//获取当前权限的id
        data.id = $(obj).prev().text();
//查询子权限
        $.ajax({
            type: 'get',
            url: '/queryPermission',
            data: data,
            cache: false,
            sync: true,
            success: function (data) {
                var json = JSON.parse(data);
                if (json.status == 200) {
//把查得的子权限添加上
                    for (var permission of json.list) {
                        var $div = $("<div>", {
                            hidden: "hidden",
                            text: permission.id
                        })
                        var $a = $("<a>", {
                            class: "list-group-item text-center",
                            onmouseover: "showbtn(this)",
                            onmouseout: "hidebtn(this)",
                            onclick: "showMsg(this)",
                            html: permission.name
                        })
                        var $div1 = $("<div>", {
                            hidden: "hidden",
                            style: "float:right",
                        });
                        var $btn1 = $("<button>", {
                            type: "button",
                            class: "btn btn-warning btn-xs ",
                            onclick: "updatePermission(" + permission.id + ',' + '"' + permission.name + '"' + ")",
                            text: "修改 ",
                        })
                        var $span1 = $("<span>", {
                            class: "glyphicon glyphicon-pencil",

                        })
                        var $btn2 = $("<button>", {
                            type: "button",
                            class: "btn btn-danger btn-xs",
                            onclick: "deletePermission(" + permission.id + ")",
                            text: "删除 "
                        })
                        var $span2 = $("<span>", {
                                class: "glyphicon glyphicon-remove",
                            }
                        )
                        var $btn3 = $("<button>", {
                            type: "button",
                            class: "btn btn-warning btn-xs",
                            onclick: "addPermission(" + permission.id + ",this)",
                            text: "增加 "
                        })
                        var $span3 = $("<span>", {
                            class: "glyphicon glyphicon-pencil",
                        })
                  $("<shiro>")
                        $btn1.attr("data-toggle", "modal");
                        $btn1.attr("data-target", "#modal");
                        $btn1.append($span1);
                        $btn2.append($span2);
                        $btn3.append($span3);
                        $div1.append($btn3).append($btn1).append($btn2);
                        $a.append($div1)
                        $parDiv.append($div);
                        $parDiv.append($a);
                    }
                }
                else {
                    alert(json.msg);
                }
            },
            error: function () {
                alert("请求失败!");
            }
        });
    }
//删除权限
    function deletePermission(id) {
        var data = {};
        data.id = id;
        $.ajax({
            type: 'get',
            url: '/deletePermission',
            data: data,
            cache: false,
            sync: true,
            success: function (data) {
                var json = JSON.parse(data);
                if (json.status == 200) {
                    alert(json.msg);
                    window.location.href = "/loginToCms"
                }
                else {
                    alert(json.msg);
                }
            },
            error: function () {
                alert("请求失败!");
            }
        });
    }

    //修改权限名称
    function updatePermission(id, a) {
        $("#permissionName").val(a);
        $("#pid").text(id);

    }

    //修改确认
    function submitChange() {
        var id = $("#pid").text();
        var name = $("#permissionName").val();
        var data = {};
        data.id = id;
        data.name = name;
        console.log(data.name);
        $.ajax({
            type: 'post',
            url: '/updatePermission',
            data: data,
            cache: false,
            sync: true,
            success: function (data) {
                var json = JSON.parse(data);
                if (json.status == 200) {
                    alert(json.msg);
                    window.location.href = "/loginToCms"
                }
                else {
                    alert(json.msg);
                }
            },
            error: function () {
                alert("请求失败!");
            }
        });
    }

    //增加权限
    function addPermission(id,obj) {
     var  $father= $(obj).parent().parent().parent();
        var name=  $father.children(":first").text();
        console.log(name)
        if( name==("三级权限") ){
            alert("三级权限不能添加子权限");
            return
        }
        $("#myModal").toggle();
        $("#parentid").text(id);
        $("#addName").val("");
        // $("#myModal").show();
    }

    //确认增加
    function submitAdd() {
        var parentid = $("#parentid").text();

        var addname = $("#addName").val();

        if ("" == addname || undefined == addname) {
            alert("用户不能为空");
            return;
        }
        var data = {};
        data.name = addname;
        data.parentid = parentid;
        $.ajax({
            type: 'post',
            url: '/addPermission',
            data: data,
            cache: false,
            sync: true,
            success: function (data) {
                var json = JSON.parse(data);
                alert(json.msg);
                $("#myModal").hide();
                window.location.href = "/loginToCms"
            },
            error: function () {
                alert("请求失败!");
            }
        });
    }
    //关闭增加权限的模态框
    function hideModal() {
        $("#myModal").hide();
    }
</script>


</html>
