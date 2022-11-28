// Handles the retrieval of users
const fetchUsers = () => {
    axios
      .get('http://18.134.246.32:8081/api/v1/employee')
      .then(response => {
        const employees = response.data;
        const table = document.getElementById('table-row')
        generateTable(table, employees)
      })
      .catch(error => console.error(error))
  };

const generateTable = (table, data) => {
  for (let element of data) {
    let row = table.insertRow();

    for (key in element) {
      if (!key.includes("department")) {
        let cell = row.insertCell();
        let text = document.createTextNode(element[key])
        cell.appendChild(text);
      } else {
        let departmentDetails = Object.values(element[key])
        let cell = row.insertCell();
        // Response = [ID, DeparmtentName, Location]
        let departmentName = document.createTextNode(departmentDetails[1])
        cell.append(departmentName)
      }
    }
  }
}

//  Handle User Creation
const createUser = user => {
  axios
  .post('http://18.134.246.32:8081/api/v1/employee', user, {
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

  const firstName = document.querySelector('#reg-first_name').value
  const lastName = document.querySelector('#reg-last_name').value
  const email = document.querySelector('#reg-email').value
  const dob = document.querySelector('#reg-dob').value
  let department = document.querySelector('#reg-department').value

  department = createDepartmentObject(department)

  const user = {
    firstName,
    lastName,
    email,
    dob,
    department
  }

  createUser(user);
})

const createDepartmentObject = (departmentString) => {
  departmentString = departmentString.toLowerCase()
  switch (departmentString) {
    case 'finance':
      department = {
        name: "Finance",
        location: "Bishopsgate"
      }
      break;
    case 'marketing':
      department = {
        name: "Marketing",
        location: "Deansgate"
      }
      break;
    case 'ecs':
      department = {
        name: "ECS",
        location: "Farringdon"
      }
      break;
  }
  return department
}

// Handle User Deletion
const deleteEmpForm = document.getElementById('delete-employee-form');

const deleteEvent = deleteEmpForm.addEventListener('submit', event => {
  event.preventDefault()

  const id = document.querySelector('#del-id').value

  deleteUser(id)
})


const deleteUser = id => {
  axios
      .delete(`http://18.134.246.32:8081/api/v1/employee/${id}`, {
        headers: headers
      })
      .catch(error => console.error(error))
}

// Handle User Updating
const updateEmpForm = document.getElementById('update-employee-form')
const updateEvent = updateEmpForm.addEventListener('submit', event=> {
  event.preventDefault()
  const id = document.querySelector('#update-id').value

  updateUser(id)
})

const updateUser = id => {
  if (document.getElementById('update-id').value.length == 0) {
    alert("You need to enter a value for user ID")
    return false
  }

  const updateFields = document.querySelectorAll('input[type="text"][id^="update"]');
  const user = {}

  // If a field isn't empty. Remove the update from the field name
  // i.e. update-name become name. Add this to the user object to be replaced
  updateFields.forEach(field => {
    if (field.value) {
      key = (field.id).replace("update-", "")
      if (key == "department") {
        user[key] = createDepartmentObject(field.value)
      } else {
        user[key] = field.value
      }
    }
  });

  axios
    .put(`http://localhost:8081/api/v1/employee/${id}`, user, {
      headers: headers
    })
    .catch(error => console.error(error))
}

