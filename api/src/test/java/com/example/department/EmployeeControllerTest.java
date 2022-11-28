package com.example.department;

import com.example.employee.Employee;
import com.example.employee.EmployeeController;
import com.example.employee.EmployeeRepository;
import com.example.employee.EmployeeService;
import com.example.user.User;
import com.example.user.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.sql.Time;
import java.time.LocalDate;
import java.time.Month;
import java.util.List;
import java.util.Optional;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(EmployeeController.class)
class EmployeeControllerTest {

    @Autowired
    private WebApplicationContext context;
    protected MockMvc mockMvc;
    @MockBean
    private EmployeeService employeeService;

    @MockBean
    private EmployeeRepository employeeRepository;

    @MockBean
    private DepartmentRepository departmentRepository;

    @MockBean
    UserRepository userRepository;

    @BeforeEach
    public void setup() {
        this.mockMvc = MockMvcBuilders
                .webAppContextSetup(this.context)
                .build();
    }
    Department dummyDepartment = new Department("Test","London");
    Department dummyDepartmentTwo = new Department("TestTwo","London");

    User dummyUser = new User(
            "dummy","password","anemail@gmail.com",
            LocalDate.of(1999, Month.JUNE, 27));
    User dummyUserTwo = new User(
            "dummyTwo","password","anemailTwo@gmail.com",
            LocalDate.of(1999, Month.JUNE, 28));

    Employee employeeOne = new Employee(
            "Aaron",
            "Grill",
            "agrill123@gmail.com",
            LocalDate.of(1999, Month.JUNE, 27),
            dummyDepartment,
            dummyUser
    );

    Employee employeeTwo = new Employee(
            "Darren",
            "Gill",
            "darrengrill@gmail.com",
            LocalDate.of(1999, Month.JUNE, 28),
            dummyDepartment,
            dummyUser
    );

    @Test
    public void shouldReturnAllEmployees() throws Exception {
        when(employeeService.getEmployees())
                .thenReturn(List.of(employeeOne,employeeTwo));

        this.mockMvc
                .perform(MockMvcRequestBuilders.get("/api/v1/employee"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.size()").value(2))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].firstName").value("Aaron"))
                .andExpect(MockMvcResultMatchers.jsonPath("$[1].email").value("darrengrill@gmail.com"));
    }


    @Test
    public void shouldAllowCreationForUnauthenticatedUsers() throws Exception {
        this.mockMvc
                .perform(
                        post("/api/v1/employee")
                                .contentType(MediaType.APPLICATION_JSON)
                                .content("{\"firstName\": \"Aaron\"" +
                                        ", \"lastName\":\"Grill\"" +
                                        ",\"email\":\"anemail@gmail.com\"," +
                                        " \"dob\":\"2002-01-02\", " +
                                        "\"department\":" +
                                        "{\"name\": \"Marketing\", " +
                                        "\"location\": \"Deansgate\"}}"
                                )
                ).andExpect(status().isCreated());
    }

    @Test
    public void shouldUpdateEmployeeSuccessfully() throws Exception {
        when(employeeService.getEmployees())
                .thenReturn(List.of(employeeOne,employeeTwo));

        this.mockMvc
                .perform(
                        put("/api/v1/employee/1")
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(
                                        "{\"firstName\": \"Aaron\"" +
                                                ", \"lastName\":\"Grill\"" +
                                                ",\"email\":\"anemail@gmail.com\"," +
                                                " \"dob\":\"2002-01-02\", " +
                                                "\"department\":" +
                                                "{\"name\": \"Marketing\", " +
                                                "\"location\": \"Deansgate\"}}"
                                )
                ).andExpect(status().isOk());
    }

    @Test
    public void shouldDeleteEmployeeSuccessfully() throws Exception {
        this.mockMvc
                .perform(
                        delete("/api/v1/employee/3"))
                .andExpect(status().isOk());

        verify(employeeService).deleteEmployee(25L);

    }

}
