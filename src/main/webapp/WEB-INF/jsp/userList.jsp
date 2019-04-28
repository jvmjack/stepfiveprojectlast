<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/3/28/028
  Time: 14:09
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <title>用户列表</title>
    <script type="text/javascript" src="/js/jquery-3.0.0.js"></script>
    <script type="text/javascript" src="/js/jqPaginator.js"></script>
    <script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/css/bootstrap.css">
</head>

<body>
<div class="container">
    <table class="table">
        <tr>
            <td>ID</td>
            <td>用户</td>
            <td>操作</td>
        </tr>
        <c:forEach var="user" items="${pageInfo.list}">
            <tr>
                <td>${user.id}</td>
                <td>${user.userName}</td>
                <td><shiro:hasAnyRoles name="manager,admin">
                    <button onclick="showRole(this)" class="btn btn-warning" data-toggle="modal" data-target="#myModal">
                        修改
                    </button>
                </shiro:hasAnyRoles>

                    <shiro:hasAnyRoles name="admin">
                        <button onclick="deleteUser(${user.id})" class="btn btn-danger">删除</button>
                    </shiro:hasAnyRoles>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
<div id="myModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header text-center">
                <h4>角色修改</h4>
            </div>
            <div class="modal-body">
                <c:forEach items="${rolelist}" var="role">
                    <div>
                        <label>
                            <input class="checkbox" type="checkbox" value="${role.id}">${role.name}角色
                        </label>
                    </div>
                </c:forEach>
            </div>
            <div class="modal-footer">
                <%-- //获取当前userid--%>
                <div hidden="hidden" class="userid"></div>
                <button type="button" class="btn btn-success" data-dismiss="modal" onclick="updateUser()">确认</button>
                <button type="button" class="btn btn-warning" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>


</div>
<div class="pagination-layout">
    <div class="pagination">
        <ul class="pagination" total-items="pageInfo.totalRows" max-size="10" boundary-links="true">

        </ul>
    </div>
</div>

<div>
    <a href="/loginToCms">返回</a>
</div>
</body>
<script type="text/javascript">
    //获取回填数据
    function showRole(o) {
        var data = {};
        //找爸爸
        data.uid = $(o).parent().prev().prev().text();
        //模态框中取到当前userid
        $(".userid").text(data.uid);
        $.ajax({
            type: 'get',
            url: '/getRoleByUid',
            data: data,
            cache: false,
            sync: true,
            success: function (data) {
                var json = JSON.parse(data);
                if (json.status == 200) {
                //checkbox的数据回填
                    $(".checkbox").each(function (i, obj) {
                        obj.checked = false;
                        for (var r of  json.list) {
                            if (r.id == (obj.value)) {
                                obj.checked = true;
                            }
                        }
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

    $(function () {
        //分页
        var is_firstTime = true;
        $(".pagination")
            .jqPaginator(
                {
                    first: '<li class="first"><a href="javascript:;">首页</a></li>',
                    prev: '<li class="prev"><a href="javascript:;">上一页</a></li>',
                    next: '<li class="next"><a href="javascript:;">下一页</a></li>',
                    last: '<li class="last"><a href="javascript:;">尾页</a></li>',
                    page: '<li class="page"><a href="javascript:;">{{page}}</a></li>',
                    totalPages: ${pageInfo.pages},
                    pageSize: 3,
                    currentPage: ${pageInfo.pageNum},
                    visiblePages: 10,
                    disableClass: 'disabled',
                    activeClass: 'active',
                    onPageChange: function (i) {
                        if (is_firstTime) {
                            is_firstTime = false;
                        } else {
                            var href = window.location.href.split("?")[0];
                            href = href + "?pageSize=3&pageNum=" + i;
                            window.location.href = href;
                        }
                    }
                });
    })

    //删除的api
    function deleteUser(i) {
        var data = {};
        data.uid = i;
        console.log(data.uid)
        $.ajax({
            type: 'get',
            url: '/deleteUser',
            data: data,
            cache: false,
            sync: true,
            success: function (data) {
                var json = JSON.parse(data);
                if (json.status == 200) {
                    alert(json.msg);
                    window.location.href = "/showUser?pageSize=3&pageNum=1"
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

    //修改用户
    function updateUser() {
        var id = $(".userid").text();
        var data = {};
        data.uid = id;
        data.datas = [];
        //获取所有被选中role 的id 放入数组
        for (var btn of $("input:checked")) {
            console.log($(btn).val())
            data.datas.push($(btn).val());
        }
        console.log(data.datas)
        $.ajax({
            type: 'get',
            url: '/updateUserRole',
            data: data,
            cache: false,
            sync: true,
            success: function (data) {
                var json = JSON.parse(data);
                alert(json.msg);
                // window.location.href ="/showUser?pageSize=3&pageNum=1"
            },
            error: function () {
                alert("请求失败!");
            }
        });

    }

</script>


</html>
