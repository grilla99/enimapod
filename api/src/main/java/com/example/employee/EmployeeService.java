package com.example.employee;

import com.example.department.Department;
import com.example.department.DepartmentRepository;
import com.example.user.User;
import com.example.user.UserRepository;
import org.apache.tomcat.util.json.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

//Service Layer
@Service
public class EmployeeService {
    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository;
    private final UserRepository userRepository;

    @Autowired
    public EmployeeService(EmployeeRepository employeeRepository, DepartmentRepository departmentRepository
    , UserRepository userRepository) {
        this.employeeRepository = employeeRepository;
        this.departmentRepository = departmentRepository;
        this.userRepository = userRepository;
    }

    public List<Employee> getEmployees() {
        return employeeRepository.findAll();
    }

    public void addNewEmployee(Employee employee){
        String employeeEmail = employee.getEmail();

        Optional<Employee> employeeOptional = employeeRepository
                .findEmployeeByEmail(employeeEmail);

        if (employeeOptional.isPresent()) {
            throw new IllegalStateException("Email Address Taken");
        }

        // Takes the string name of the employee department, retrieves the existing object
        // Then sets the incoming employee's department to this
        Department department =
                departmentRepository.findDepartmentByName(employee.getDepartment().getName());
        employee.setDepartment(department);

        // Each Employee Must have a matching user account
        // Username for Aaron Grill would be agrill
        String username = (employee.getFirstName().charAt(0) + employee.getLastName()).toLowerCase();
        String password = "ChangeMe";
        String email = employeeEmail;
        LocalDate dateCreated = LocalDate.now();

        User employeeUser = new User(username, password, email, dateCreated);
        employee.setUser(employeeUser);

        userRepository.save(employeeUser);
        employeeRepository.save(employee);
    }

    public void deleteEmployee(Long employeeId) {
        boolean exists = employeeRepository.existsById(employeeId);

        if (!exists) {
            throw new IllegalStateException("Employee with ID " + employeeId + "does not exist");
        }

        employeeRepository.deleteById(employeeId);
    }

    //ToDo:
    // Extract to a factory method and replace all the if ...
    @Transactional
    public void updateEmployee(Long employeeId, Employee updatedEmployee) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new IllegalStateException(
                        "Employee with ID" + employeeId + "does not exist"
                ));

        String firstName = updatedEmployee.getFirstName();
        String lastName = updatedEmployee.getLastName();
        String email = updatedEmployee.getEmail();
        LocalDate dob = updatedEmployee.getDob();
        Department department = updatedEmployee.getDepartment();

        if (firstName != null && firstName.length() > 0 && !Objects.equals(employee.getFirstName(), firstName)) {
            employee.setFirstName(firstName);
        }

        if (lastName != null && lastName.length() > 0 && !Objects.equals(employee.getLastName(), lastName)) {
            employee.setLastName(lastName);
        }

        if (email != null && email.length() > 0 && !Objects.equals(employee.getEmail(), email)) {
            Optional<Employee> employeeOptional = employeeRepository.findEmployeeByEmail(email);
            if (employeeOptional.isPresent()) {
                throw new IllegalStateException("Email address in use.");
            }
            employee.setEmail(email);
        }

        if (dob != null && !Objects.equals(employee.getDob(), dob)) {
            employee.setDob(dob);
        }

        if (department != null) {
            Department newDepartment = departmentRepository.findDepartmentByName(department.getName());
            employee.setDepartment(newDepartment);
        }
    }
}
