package net.wanho.service;

import net.wanho.entity.User;

import java.util.List;

public interface UserServiceI {
    User login(User user) throws Exception;
    List<User> queryUser()throws Exception;
    void deleteUserById(int id)throws Exception;
    void  updateUserRole(int uid,int[] roles) throws  Exception;
    void addUser(User user)throws Exception;
    User queryUserByUsername(String name)throws Exception;
}
