package net.wanho.service.impl;

import net.wanho.entity.Role;
import net.wanho.mapper.RoleMapper;
import net.wanho.service.RoleServiceI;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
@Service
public class RoleServiceImpl implements RoleServiceI {
    @Resource
    RoleMapper roleMapper;
    public List<Role> queryRole()throws Exception{
        return roleMapper.queryRole();
    }
    public List<Role> queryRoleByUid(int uid)throws Exception{
        return roleMapper.queryRoleByUid(uid);
    }
    public void deleteRolePermisson(int id)throws Exception{
        roleMapper.deleteRolePermisson(id);
    };
    public  void  updateRolePermisson(int id,List<Integer> permissions) throws  Exception{
             roleMapper.deleteRolePermisson(id);
             for(Integer p : permissions){
                 roleMapper.addRolePermission(id,p);
             }
    }
    public List<Role>queryRoleByUId(int id)throws Exception{
        return roleMapper.queryRoleByUId(id);
    }
}
