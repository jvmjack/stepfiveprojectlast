package net.wanho.service.impl;

import net.wanho.entity.Permission;
import net.wanho.mapper.PermissionMapper;
import net.wanho.service.PermissionServiceI;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class PermissionSericeImpl implements PermissionServiceI {
    @Resource
    PermissionMapper permissionMapper;

    public List<Permission> queryParentPermission() throws Exception {
        return permissionMapper.queryParentPermission();
    }

    public List<Permission> queryPermissionByParentId(int id) throws Exception {
        return permissionMapper.queryPermissionByParentId(id);
    }

    public List<Permission> queryAllPermission() throws Exception {
        return permissionMapper.queryAllPermission();
    }

    public List<Permission> queryPermissionByRoleId(int id) throws Exception {
        return permissionMapper.queryPermissionByRoleId(id);
    }

    public void deletePermission(int id) throws Exception {
        permissionMapper.deletePermission(id);
    }

    public void updatePermission(Permission permission) throws Exception {
        permissionMapper.updatePermission(permission);
    }

    public Permission queryPermissionByName(String name) throws Exception {
        return permissionMapper.queryPermissionByName(name);
    }

    public void addPermission(Permission permission) throws Exception {
        permissionMapper.addPermission(permission);
    }
}
