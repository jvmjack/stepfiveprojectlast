package net.wanho.service;

import net.wanho.entity.Role;

import java.util.List;

public interface RoleServiceI {
    List<Role> queryRole()throws Exception;
    List<Role> queryRoleByUid(int uid)throws Exception;
    void  updateRolePermisson(int uid,List<Integer> permissions) throws  Exception;
    void deleteRolePermisson(int id)throws Exception;
    List<Role>queryRoleByUId(int id)throws Exception;
}
