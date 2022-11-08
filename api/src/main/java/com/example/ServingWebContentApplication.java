package com.example;

import com.example.department.Department;
import com.example.department.DepartmentRepository;
import com.example.employee.Employee;
import com.example.employee.EmployeeRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.time.LocalDate;
import java.time.Month;
import java.util.List;

@SpringBootApplication
public class ServingWebContentApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServingWebContentApplication.class, args);
    }


    @Bean
    public CommandLineRunner commandLineRunner(EmployeeRepository employeeRepository, DepartmentRepository departmentRepository) {
        return args -> {
            Department finance = new Department(
                    "Finance",
                    "Bishopsgate"
            );
            Department ecs = new Department(
                    "ECS",
                    "Farringdon"
            );

            departmentRepository.saveAll(
                    List.of(finance, ecs)
            );

            Employee aaron = new Employee(
                    "Aaron",
                    "aarongrill@gmail.com",
                    LocalDate.of(1999, Month.JUNE, 27),
                    finance
            );

            Employee tim = new Employee(
                    "Tim",
                    "tim@anemail.com",
                    LocalDate.of(1993, Month.MAY, 15),
                    ecs
            );
            employeeRepository.saveAll(
                    List.of(aaron, tim)
            );
        };
    }

}
