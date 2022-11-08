package com.example.department;

import com.example.employee.Employee;

import javax.persistence.*;
import java.util.Set;

@Entity
public class Department {
    @Id
    @GeneratedValue
    private long id;

    @Column
    private String name;

    private String location;

    @OneToMany(mappedBy="department")
    private Set<Employee> employees;

    public Department(String name, String location) {
        this.name = name;
        this.location = location;
    }

    public Department() {

    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Set<Employee> getEmployees() {
        return employees;
    }

    public void setEmployees(Set<Employee> employees) {
        this.employees = employees;
    }
}
