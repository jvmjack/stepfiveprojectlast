package net.wanho.mapper;

import net.wanho.entity.Role;

import java.util.List;

public interface RoleMapper {
    List<Role> queryRole() throws Exception;

    List<Role> queryRoleByUid(int uid) throws Exception;

    void deleteRolePermisson(int rid) throws Exception;

    void addRolePermission(int rid,int pid)throws Exception;

    List<Role>queryRoleByUId(int id)throws Exception;

}
