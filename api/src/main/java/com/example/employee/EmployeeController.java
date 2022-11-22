package com.example.employee;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "api/v1/employee")
public class EmployeeController {
    private final EmployeeService employeeService;

    @Autowired
    public EmployeeController(EmployeeService employeeService) {this.employeeService = employeeService;}

    @CrossOrigin("*")
    @GetMapping
    public List<Employee> getEmployees(){
        return employeeService.getEmployees();
    }

    @CrossOrigin("*")
    @PostMapping
    public void registerNewEmployee(@RequestBody Employee employee) {
        employeeService.addNewEmployee(employee);
    }

    @CrossOrigin("*")
    @DeleteMapping(path = "{employeeId}")
    public void deleteEmployee(
            @PathVariable("employeeId") Long employeeId) {
        employeeService.deleteEmployee(employeeId);
    }

    @CrossOrigin("*")
    @PutMapping(path = "{employeeId}")
    public void updateStudent(
            @PathVariable("employeeId") Long studentId,
            @RequestBody Employee updatedDetails
    ) {
        employeeService.updateEmployee(studentId, updatedDetails);
    }
}
