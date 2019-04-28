<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/3/28/028
  Time: 14:09
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>角色列表</title>
    <script type="text/javascript" src="/js/jquery-3.0.0.js"></script>
    <script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/js/jquery.ztree.all.js"></script>
    <link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/zTreeStyle/zTreeStyle.css" type="text/css">
</head>
<body>
<div class="container">
    <table class="table">
        <tr>
            <td>ID</td>
            <td>角色</td>
            <td>操作</td>
        </tr>
        <c:forEach var="role" items="${list}">
            <tr>
                <td>${role.id}</td>
                <td>${role.name}</td>
                <td>
                    <shiro:hasAnyRoles name="manager,admin">
                        <button class="btn btn-warning"
                                onclick="update(${role.id})">修改
                        </button>
                    </shiro:hasAnyRoles>
                    <shiro:hasRole name="admin">
                        <button class="btn btn-danger"  onclick="warning()">删除</button>
                    </shiro:hasRole>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
<div id="myModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <h4>权限修改</h4>
            </div>
            <div class="modal-body">
                <ul id="tree" class="ztree" style="width: 230px; overflow: auto;"></ul>
            </div>
            <div class="modal-footer">
                <%-- //获取当前roleid--%>
                <div hidden="hidden" class="roleid"></div>
                <button type="button" class="btn btn-success" data-dismiss="modal" onclick="confirm()">确认
                </button>
                <button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<div>
    <a href="/loginToCms">返回</a>
</div>
</body>
<script type="text/javascript">

    function update(roleId) {
        $(".roleid").text(roleId);
        $("#myModal").modal("show");
        //Ztree  展示数据
        var zTreeObj,
            setting = {
                view: {
                    selectedMulti: false
                },
                check: {
                    enable: true
                },
                data: {
                    simpleData: {
                        enable: true,
                        idKey: "id",
                        pIdKey: "pId",
                        rootPId: 0
                    }
                }
            },
            zTreeNodes = [];
            var data = {};
            data.id = roleId;
        //查询回填 数据
        $.ajax({
            type: 'get',
            url: '/queryAllPermission',
            cache: false,
            data: data,
            sync: true,
            success: function (jsonData) {
                var json = JSON.parse(jsonData);
                if (json.status == 200) {
                //数据回填
                    $.each(json.list, function (i, obj) {
                        zTreeNodes.push({"id": obj.id, "pId": obj.parentid, "name": obj.name});
                    })
                    //初始化ztree
                    zTreeObj = $.fn.zTree.init($("#tree"), setting, zTreeNodes);
                    var treeObj = $.fn.zTree.getZTreeObj("tree");
                    //遍历传来的list，回填ztree
                    $.each(json.choseList, function (i, obj) {
                        var nodes = treeObj.getNodesByParam("id", obj.id, null);
                        treeObj.checkNode(nodes[0], true, false);
                    })
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

    function confirm() {
        var id = $(".roleid").text();

        var treeObj = $.fn.zTree.getZTreeObj("tree");

        var nodes = treeObj.getCheckedNodes(true);
        var rolePermissions = [];
        for (var n of nodes) {
            rolePermissions.push(n.id)
        }
        $.ajax({
            type: "post",
            url: "/updateRolePermissions",
            dataType: "json",
            cache: false,
            sync: true,
            /*  传递数组到后台 后台处理为list */
            data: {"list": JSON.stringify(rolePermissions), "id": id},
            success: function (data) {
                //返回的数据本身已经是json格式
                alert(data.msg)
            },
            error: function () {
                alert("请求失败!");
            }
        });
    }
    function warning() {
        alert("请慎重选择");
    }
</script>


