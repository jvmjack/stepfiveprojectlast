package net.wanho.mapper;

import net.wanho.entity.User;

import java.util.List;

public interface UserMapper {
    User login(User user)throws Exception;
    List<User> queryUser() throws Exception;
    void deleteUserById(int id)throws Exception;
    void addUserRole(int uid,int role) throws  Exception;
    void  deleteUserRole(int uid)throws Exception;
    int addUser(User user)throws Exception;
     User queryUserByUsername(String name)throws Exception;

}
