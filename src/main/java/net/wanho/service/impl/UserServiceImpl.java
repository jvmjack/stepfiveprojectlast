package net.wanho.service.impl;

import net.wanho.entity.User;
import net.wanho.mapper.UserMapper;
import net.wanho.service.UserServiceI;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class UserServiceImpl implements UserServiceI {
    @Resource
    UserMapper userMapper;
    public User login(User user) throws Exception{
        return userMapper.login(user);
    }
    public List<User> queryUser()throws Exception{
        return userMapper.queryUser();
    }

    public void deleteUserById(int id)throws Exception{
        userMapper.deleteUserById(id);
    }

    public void updateUserRole(int uid, int[] roles) throws Exception {
        userMapper.deleteUserRole(uid);
        for(int role : roles){
            System.out.println("uid====="+uid);
            userMapper.addUserRole(uid,role);
        }

    }

    public void addUser(User user) throws Exception {
          userMapper.addUser(user);
         userMapper.addUserRole(user.getId(),2);
    }
    public User queryUserByUsername(String name)throws Exception{
       return userMapper.queryUserByUsername(name);
    }
}
