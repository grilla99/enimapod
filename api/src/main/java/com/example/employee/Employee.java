package com.example.employee;

import com.example.department.Department;
import com.example.user.User;
import com.fasterxml.jackson.annotation.*;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.Period;

//Data Access Layer
@Entity
@Table
@JsonIdentityInfo(
        generator = ObjectIdGenerators.PropertyGenerator.class,
        property = "id"
)
public class Employee {

    @Id
    @SequenceGenerator(
            name = "employee_sequence",
            sequenceName = "employee_sequence",
            allocationSize = 1
    )
    @GeneratedValue (
            strategy = GenerationType.SEQUENCE,
            generator = "employee_sequence"
    )
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private LocalDate dob;
    @Transient
    private Integer age;

    @ManyToOne
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @OneToOne
    @JoinColumn(name="user_id", nullable = false)
    @JsonBackReference
    private User user;

    public Employee() {}

    public Employee(Long id, String firstName, String lastName, String email, LocalDate dob, Department department) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.dob = dob;
        this.age = getAge();
        this.department = department;
    }

    public Employee(String firstName, String lastName, String email, LocalDate dob, Department department, User user) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.dob = dob;
        this.age = getAge();
        this.department = department;
        this.user = user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public Integer getAge() {
        return Period.between(dob, LocalDate.now()).getYears();
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }


    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + firstName + " " + lastName +
                '\'' +
                ", email='" + email + '\'' +
                ", dob=" + dob +
                ", age=" + age +
                ", department=" + department +
                ", user=" + user +
                '}';
    }
}
