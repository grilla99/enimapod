package com.example;

import com.example.department.Department;
import com.example.department.DepartmentRepository;
import com.example.employee.Employee;
import com.example.employee.EmployeeRepository;
import com.example.user.User;
import com.example.user.UserRepository;
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
    public CommandLineRunner commandLineRunner(EmployeeRepository employeeRepository, DepartmentRepository departmentRepository,
                                               UserRepository userRepository) {
        return args -> {
            Department finance = new Department(
                    "Finance",
                    "Bishopsgate"
            );
            Department ecs = new Department(
                    "ECS",
                    "Farringdon"
            );

            Department marketing = new Department(
                    "Marketing",
                    "Deansgate"
            );

//            departmentRepository.saveAll(
//                    List.of(finance, ecs, marketing)
//            );

            User userAaron = new User(
                    "grilla99",
                    "aHashedPassword",
                    "aarongrill99@gmail.com",
                    LocalDate.now()
            );
            User userTim = new User(
                    "timtim",
                    "aHashedPassword",
                    "tim@gft.com",
                    LocalDate.now()
            );
            User userTom = new User(
                    "timtim",
                    "aHashedPassword",
                    "tim@gft.com",
                    LocalDate.now()
            );

//            userRepository.saveAll(
//                    List.of(userAaron, userTim, userTom)
//            );

            Employee aaron = new Employee(
                    "Aaron",
                    "Grill",
                    "aarongrill@gmail.com",
                    LocalDate.of(1999, Month.JUNE, 27),
                    finance,
                    userAaron
            );

            Employee tim = new Employee(
                    "Tim",
                    "Ellis",
                    "tim@anemail.com",
                    LocalDate.of(1993, Month.MAY, 15),
                    ecs,
                    userTim
            );
            Employee tom = new Employee(
                    "Tom",
                    "Hardy",
                    "tom@anemail.com",
                    LocalDate.of(1993, Month.MAY, 15),
                    marketing,
                    userTom
            );
//            employeeRepository.saveAll(
//                    List.of(aaron, tim, tom)
//            );
        };
    }

}
