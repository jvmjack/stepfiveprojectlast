package net.wanho.entity;

public class Permission {
    private int id;
    private  int parentid;
    private String name;
    private String  method;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getParentid() {
        return parentid;
    }

    public void setParentid(int parentid) {
        this.parentid = parentid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public Permission() {

    }

    public Permission(int id, int parentid, String name, String method) {

        this.id = id;
        this.parentid = parentid;
        this.name = name;
        this.method = method;
    }
}
