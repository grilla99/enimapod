const fetchUsers = () => {
    axios
      .get('http://3.9.118.254:8081/api/v1/employee')
      .then(response => {
        data = response.data;
        appendData(data);
      })
      .catch(error => console.error(error))
  };

const headers = {
    'Access-Control-Allow-Origin' : '*',
    'Content-Type': 'application/json',
    'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE,PATCH,OPTIONS',
    'Access-Control-Allow-Headers': 'text/plain',
    'Access-Control-Max-Age': '86400'
  }

const createUser = user => {
  axios
  .post('http://3.9.118.254:8081/api/v1/employee', user, {
    headers: headers
  }
  ) 
  .then(response => {
    const addedUser = response.data
    console.log(addedUser);
  })
  .catch(error => console.error(error));
}
  
const form = document.querySelector('form');

const formEvent = form.addEventListener('submit', event => {
  event.preventDefault()

  const name = document.querySelector('#name').value
  const email = document.querySelector('#email').value
  const dob = document.querySelector('#dob').value

  const user = {name, email, dob}
  createUser(user);
})
  
function appendData(data) {
  var mainContainer = document.getElementById("employee");
  data.forEach(element => {
    var div = document.createElement("div");
    div.innerHTML = "Name " + element.name;
    mainContainer.appendChild(div);
  });
}
