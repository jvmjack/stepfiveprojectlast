package net.wanho.mapper;

import net.wanho.entity.Permission;

import java.util.List;

public interface PermissionMapper {
    List<Permission> queryParentPermission() throws Exception;

    List<Permission> queryPermissionByParentId(int id) throws Exception;

    List<Permission> queryAllPermission() throws Exception;

    List<Permission> queryPermissionByRoleId(int id) throws Exception;
    void   deletePermission(int id) throws  Exception;
     void  updatePermission(Permission permission)throws Exception;
      Permission queryPermissionByName(String name)throws Exception;
      void addPermission(Permission permission) throws Exception;
}
