// const createLi = employee => {
//     // Add user details to list
//     const li = document.createElement('li')
//     li.textContent = `${employee.id}: ${employee.name}, ${employee.email}, ${employee.dob}`

//     // Attach on click event to delete the user
//     li.onclick = e = deleteUser(li, employee.id)

//     return li
// }

// Handles the retrieval of users
const fetchUsers = () => {
    axios
      .get('http://18.130.79.148:8081/api/v1/employee')
      .then(response => {
        const employees = response.data;
        displayEmployees(employees)
      })
      .catch(error => console.error(error))
  };

// Display Users
function displayEmployees(employees) {
  var mainContainer = document.getElementById("employee-list")
  employees.forEach(employee => {
    var div = document.createElement("div");
    div.innerHTML = `ID: ${employee.id}:${employee.name}, ${employee.email}, ${employee.dob}`
    div.classList.add('employee-list')
    mainContainer.appendChild(div);
  });
}


//  Handle User Creation
const createUser = user => {
  axios
  .post('http://18.130.79.148:8081/api/v1/employee', user, {
    headers: headers
  }
  ) 
  .then(response => {
    const addedUser = response.data
  })
  .catch(error => console.error(error));
}

const headers = {
  'Access-Control-Allow-Origin' : '*',
  'Content-Type': 'application/json',
  'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
  'Access-Control-Allow-Headers': 'text/plain',
  'Access-Control-Max-Age': '86400'
}
  
const registerEmpForm = document.getElementById('register-employee-form');

const formEvent = registerEmpForm.addEventListener('submit', event => {
  event.preventDefault()

  const name = document.querySelector('#reg-name').value
  const email = document.querySelector('#reg-email').value
  const dob = document.querySelector('#reg-dob').value

  const user = {name, email, dob}
  createUser(user);
})

// Handle User Deletion
const deleteEmpForm = document.getElementById('delete-employee-form');

const deleteEvent = deleteEmpForm.addEventListener('submit', event => {
  event.preventDefault()

  const id = document.querySelector('#del-id').value

  deleteUser(id)
})


const deleteUser = id => {
  console.log(id)
  axios
      .delete(`http://18.130.79.148:8081/api/v1/employee/${id}`, {
        headers: headers
      })
      .catch(error => console.error(error))
}

