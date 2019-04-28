package net.wanho.controller;

import com.alibaba.fastjson.JSONObject;
import net.wanho.entity.Permission;
import net.wanho.entity.User;
import net.wanho.service.PermissionServiceI;
import net.wanho.service.UserServiceI;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class LoginController {

    @Resource
    UserServiceI userServiceI;
    @Resource
    PermissionServiceI permissionServiceI;
    @RequestMapping("/loginCheck")
    @ResponseBody
    public JSONObject login(@RequestParam("username") String username,@RequestParam("password") String password) {
        JSONObject jsonobj = new JSONObject();
        User u = null;
        try {
    /*        通过传过来的名字看有木有这个角色*/
            u=userServiceI.queryUserByUsername(username);
            if (u != null) {
                //获取uuid，并进行md5加密
                String salt=u.getSalt();
                //给传来的密码加密  这是个单例 直接调方法
                String loginPassword= DigestUtils.md5Hex(password+salt);
                if(u.getPassword().equals(loginPassword)){
                  //密码正确
                    jsonobj.put("code", 1);
                    UsernamePasswordToken token = new UsernamePasswordToken(username,password);
                    Subject subject = SecurityUtils.getSubject();
                    //id传入session
                    subject.getSession().setAttribute("id",u.getId());
                    subject.login(token);
                }
                else {
                    //密码错误
                    jsonobj.put("code", 0);
                }
            }
            jsonobj.put("status", 200);
        } catch (Exception e) {
            e.printStackTrace();
            jsonobj.put("status", 100);
        } finally {
            return jsonobj;
        }
    }
    //跳转到首页  查出一级权限
    @RequestMapping("/loginToCms")
    public ModelAndView loginToSecurity(User user){
        ModelAndView modelAndView=new ModelAndView("security");
        //查出所有一级权限
        List<Permission> parentList=null;
        try {
           parentList=permissionServiceI.queryParentPermission();
            modelAndView.addObject("parentList",parentList);
        } catch (Exception e) {
            modelAndView.addObject("msg","query error");
            e.printStackTrace();
        }
        return modelAndView ;
    }
}
