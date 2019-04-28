package net.wanho.controller;

import com.alibaba.fastjson.JSONObject;
import net.wanho.entity.Permission;
import net.wanho.service.PermissionServiceI;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
public class PermissionController {
    @Resource
    PermissionServiceI permissionServiceI;

    @RequestMapping("/queryPermission")
    @ResponseBody
    //点击查询子权限
    public String queryPermissionByParentId(@RequestParam("id") int id) {
        List<Permission> list = null;
        JSONObject jsonObject = new JSONObject();
        try {

            list = permissionServiceI.queryPermissionByParentId(id);
            jsonObject.put("list", list);
            jsonObject.put("status", 200);

        } catch (Exception e) {
            jsonObject.put("status", 100);
            jsonObject.put("msg", "query error");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    @RequestMapping("/queryAllPermission")
    @ResponseBody
    //点击查询权限
    public String queryPermissionByRoleId(@RequestParam("id") int id) {
        //全部的
        List<Permission> list = null;
        //被选中的
        List<Permission> choseList = null;
        JSONObject jsonObject = new JSONObject();
        try {
            choseList = permissionServiceI.queryPermissionByRoleId(id);
            list = permissionServiceI.queryAllPermission();
            jsonObject.put("list", list);
            jsonObject.put("choseList", choseList);
            jsonObject.put("status", 200);
        } catch (Exception e) {
            jsonObject.put("status", 100);
            jsonObject.put("msg", "query error");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    //
    @RequestMapping("/deletePermission")
    @ResponseBody
    //点击查询权限
    public String deletePermissionById(@RequestParam("id") int id) {
        Subject subject = SecurityUtils.getSubject();
        JSONObject jsonObject = new JSONObject();
        try {
            if (subject.hasRole("admin")) {
                if (permissionServiceI.queryPermissionByParentId(id).size() == 0) {
                    permissionServiceI.deletePermission(id);
                    jsonObject.put("msg", "删除成功");
                } else {
                    jsonObject.put("msg", "请先删除子节点");
                    jsonObject.put("status", 100);
                }
            } else {
                jsonObject.put("msg", "权限不足");
            }
            jsonObject.put("status", 200);
        } catch (Exception e) {
            jsonObject.put("status", 100);
            jsonObject.put("msg", "query error");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    //修改权限
    @RequestMapping("/updatePermission")
    @ResponseBody
    //点击查询权限名
    public String updatePermission(Permission permission) {
        JSONObject jsonObject = new JSONObject();
        //检察权限
        Subject subject = SecurityUtils.getSubject();
        try {
            //判断权限
            if (subject.hasRole("manager")) {
                //判断是否为父节点
                permissionServiceI.updatePermission(permission);
                jsonObject.put("msg", "修改成功");
                jsonObject.put("status", 200);
            } else {
                jsonObject.put("msg", "权限不足");
                jsonObject.put("status", 100);
            }
        } catch (Exception e) {
            jsonObject.put("status", 100);
            jsonObject.put("msg", "query error");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    @RequestMapping("/addPermission")
    @ResponseBody
    //点击查询权限名
    public String addPermission(Permission permission) {
        JSONObject jsonObject = new JSONObject();
        Subject subject = SecurityUtils.getSubject();
        try {
            if (subject.hasRole("manager")) {
                Permission p = permissionServiceI.queryPermissionByName(permission.getName());
                if (p == null) {
                    permissionServiceI.addPermission(permission);
                    jsonObject.put("status", 200);
                    jsonObject.put("msg", "增加成功");
                } else {
                    jsonObject.put("status", 100);
                    jsonObject.put("msg", "增加 error");
                }
            } else {
                jsonObject.put("msg", "权限不足");
            }
        } catch (Exception e) {
            jsonObject.put("status", 100);
            jsonObject.put("msg", "增加 error");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

}
