# enimapod

# Architecture Diagram
![Screenshot 2022-12-13 at 14 32 17](https://user-images.githubusercontent.com/32545226/207360897-f37b8c32-4ccc-45e1-9b2b-3fd7c7b19dd5.png)

## Purpose
- To improve our AWS knowledge and Terraform writing skills using modules
- Gain a broader insight into components of a cloud native web application, interacting with all sections
to understand how components fit together.
- Improve architectural design skills and security considerations of apps in the cloud.

## What was built
- Multi-tier web Application
- Front end technologies:
  - HTML, CSS, JS, Nginx
- API written using Java with Spring Boot
- Backend used MySQL Hosted in RDS
  - 3 tables consisting of a 1 to many and 1 to 1 relationship.
- Using Terraform for deployment of all necessary infrastructure.
- CircleCI pipeline that runs the TF build and building / deployment of docker containers automatically 
on merging to master.

## Method
- Created an initial 3 sprints worth of tickets using Jira and assign them to the 2 team members
- Refined these tickets as we discovered more about the architecture and requirements
- Documenting development steps and build processes using a Confluence page for smoother testing
and picking up others work as and where was necessary.
- Reviewing architecture diagram and tickets at each sprint and refining these as necessary.

## Learning Takeaways
During the build of this project we've had the chance to try out many new technologies that we'd never
used previously including:
- Spring Boot and Java
- Nginx
- Docker
- AWS: Secrets Manager, RDS, ECS, ECR, R53 
- CircleCI

New Concepts:
- Build pipelines
- Automated testing with build pipelines
- Creating a cloud native app
- Database administration (Schema design, provisioning infrastructure)
- Terraform Modules to keep the primary main.tf clear and concise

Soft Skills: 
- Develop approaches to learning new technologies
- Problem decomposition 
  - Breaking down an unknown task of 'a cloud native web app' into reasonable logical steps and then
  executing it.
- Iterative Development Process
- Take charge of sprint planning and documenting processes using Confluence

Improvements for next time:
- Architectural Design
  - Put all ECS tasks inside of the private subnet and use an API gateway to route requests to this. 
  NAT gateway would be required also for updates.
- Spend less time on problems before asking for help, whilst it allowed for a lot of learning it was
sometimes to excessive detriment to development time.



