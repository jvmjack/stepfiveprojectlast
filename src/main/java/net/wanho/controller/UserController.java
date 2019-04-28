package net.wanho.controller;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import net.wanho.entity.Role;
import net.wanho.entity.User;
import net.wanho.service.RoleServiceI;
import net.wanho.service.UserServiceI;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;
import java.util.UUID;

@Controller
public class UserController {
    @Resource
    UserServiceI userServiceI;
    @Resource
    RoleServiceI roleServiceI;
    @RequestMapping("/showUser")
    public ModelAndView queryUser(@RequestParam("pageNum") int pageNum, @RequestParam("pageSize") int pageSize){
        ModelAndView modelAndView=new ModelAndView("userList");
        List<User> list=null;
        List<Role> roleList=null;
        try {
            PageHelper.startPage(pageNum,pageSize);
            list= userServiceI.queryUser();
            roleList=roleServiceI.queryRole();
            PageInfo<User> pageInfo = new PageInfo<User>(list);
            modelAndView.addObject("pageInfo",pageInfo);
            modelAndView.addObject("rolelist",roleList);
            modelAndView.addObject("status","200");

        } catch (Exception e) {
            modelAndView.addObject("status","100");
            modelAndView.addObject("msg","query error");
            e.printStackTrace();
        }
        return modelAndView;
    }
    @RequestMapping("/deleteUser")
    @ResponseBody
    public String deleteUserById(@RequestParam("uid") int id){
        JSONObject jsonObject=new JSONObject();
        try {
            userServiceI.deleteUserById(id);
            jsonObject.put("status","200");
            jsonObject.put("msg","删除成功");
        } catch (Exception e) {
            jsonObject.put("status","100");
            jsonObject.put("msg","删除出错");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }
    @RequestMapping("/updateUserRole")
    @ResponseBody
    public String updateUserRole(@RequestParam("uid") int uid,@RequestParam(value = "datas[]") int[] roles){
        JSONObject jsonObject=new JSONObject();
        try {
            userServiceI.updateUserRole(uid,roles);
            jsonObject.put("status","200");
            jsonObject.put("msg","修改成功");
        } catch (Exception e) {
            jsonObject.put("status","100");
            jsonObject.put("msg","修改出错");
            e.printStackTrace();
        }
        return jsonObject.toString();
    }
    //注册
    @RequestMapping("/addUser")
    @ResponseBody
    public JSONObject addUser(User user){
        JSONObject jsonObject=new JSONObject();
        //获取uuid
         String salt=UUID.randomUUID().toString();
         //md5加密
        String password = DigestUtils.md5Hex(user.getPassword()+salt);
        user.setSalt(salt);
        user.setPassword(password);
        try {
           User u= userServiceI.queryUserByUsername(user.getUserName());
            if(u!=null){
                jsonObject.put("status","100");
                jsonObject.put("msg","账号已存在");
            }
            else{
                userServiceI.addUser(user);
                jsonObject.put("status","200");
                jsonObject.put("msg","注册成功");
            }
        } catch (Exception e) {
            jsonObject.put("status","100");
            jsonObject.put("msg","注册失败");
            e.printStackTrace();
        }
        return jsonObject;
    }
}
