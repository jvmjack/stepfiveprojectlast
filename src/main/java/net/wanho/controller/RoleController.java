package net.wanho.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import net.wanho.entity.Role;
import net.wanho.service.RoleServiceI;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class RoleController {
    @Resource
    RoleServiceI roleServiceI;
    @RequestMapping("/showRole")
    public ModelAndView queryRole(){
        ModelAndView modelAndView=new ModelAndView("roleList");
        List<Role> list=null;
        try {
            list= roleServiceI.queryRole();
            modelAndView.addObject("status","200");
            modelAndView.addObject("list",list);
        } catch (Exception e) {
            modelAndView.addObject("status","100");
            modelAndView.addObject("msg","query error");
            e.printStackTrace();
        }
        return modelAndView;
    }

    @RequestMapping("/getRoleByUid")
    @ResponseBody
    public String queryRoleByUid(@RequestParam("uid") int uid){

        JSONObject jsonObject=new JSONObject();
        List<Role> list=null;
        try {
            list= roleServiceI.queryRoleByUid(uid);
            jsonObject.put("status","200");
            jsonObject.put("list",list);
        } catch (Exception e) {
            jsonObject.put("status","100");
            jsonObject.put("msg","查询失败");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }
    @RequestMapping("/updateRolePermissions")
    @ResponseBody
    public String updateRolePermissions(@RequestParam("id") int id,@RequestParam("list") String list){
        JSONObject jsonObject=new JSONObject();
        List<Integer> permissions= JSON.parseArray(list,Integer.class);
        try {
            roleServiceI.updateRolePermisson(id,permissions);
            jsonObject.put("status","200");
            jsonObject.put("msg","修改成功");
        } catch (Exception e) {
            jsonObject.put("status","100");
            jsonObject.put("msg","修改出错");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

}
