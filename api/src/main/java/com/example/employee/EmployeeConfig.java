package com.example.employee;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;
import java.time.Month;
import java.util.List;

@Configuration
public class EmployeeConfig {

    @Bean
    CommandLineRunner commandLineRunner(EmployeeRepository repository) {
        return args -> {
            Employee aaron = new Employee(
                    "Aaron",
                    "aarongrill@gmail.com",
                    LocalDate.of(1999, Month.JUNE, 27)
            );
            Employee tim = new Employee(
                    "Tim",
                    "tim@anemail.com",
                    LocalDate.of(1993, Month.MAY, 15)
            );

            repository.saveAll(
                    List.of(aaron, tim)
            );
        };
    }
}
