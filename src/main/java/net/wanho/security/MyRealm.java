package net.wanho.security;

import net.wanho.entity.Role;
import net.wanho.service.RoleServiceI;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;

import javax.annotation.Resource;
import javax.crypto.SealedObject;
import java.util.List;

public class MyRealm  extends AuthorizingRealm {
    @Resource
    RoleServiceI roleServiceI;
    //授权
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
          Integer id=(Integer) SecurityUtils.getSubject().getSession().getAttribute("id");
         SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        List<Role> list=null;
        try {
            list= roleServiceI.queryRoleByUId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
       for (Role r : list){
            if(r.getId()==1){
                info.addRole("admin");
            }
           else if(r.getId()==2){
                info.addRole("user");
            }
            else {
                info.addRole("manager");
            }
       }
        return info;
    }
   //认证
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        UsernamePasswordToken token = (UsernamePasswordToken)authenticationToken;
        String pwd = new String((char[]) token.getCredentials());
        String username = (String) token.getPrincipal();
        return new SimpleAuthenticationInfo(username, pwd, getName());
    }
}
