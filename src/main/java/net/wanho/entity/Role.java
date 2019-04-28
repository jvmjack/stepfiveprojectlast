package net.wanho.entity;

public class Role
{int id;
 String name;

    public int getId() {
        return id;
    }

    public Role() {
    }

    public Role(int id, String name) {

        this.id = id;
        this.name = name;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
