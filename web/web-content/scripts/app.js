// Handles the retrieval of users
const fetchUsers = () => {
    axios
      .get('http://localhost:8081/api/v1/employee')
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
  .post('http://localhost:8081/api/v1/employee', user, {
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
      .delete(`http://localhost:8081/api/v1/employee/${id}`, {
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
      user[key] = field.value
    }
  });
  
  axios
    .put(`http://localhost:8081/api/v1/employee/${id}`, user, {
      headers: headers
    })
    .catch(error => console.error(error))
}

