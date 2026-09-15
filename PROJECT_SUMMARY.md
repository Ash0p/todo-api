# Project Summary — To-Do API Cloud Deployment

A record of everything built and set up in this project, from a basic API
to a cloud-deployable, Infrastructure-as-Code system.

---

## 1. Application (Backend)

Built a simple REST API using **Python + Flask**.

**Endpoints:**
- `GET /health` — health check
- `GET /tasks` — list all tasks
- `POST /tasks` — create a task
- `DELETE /tasks/<id>` — delete a task by ID

Data is stored in-memory (resets when the app restarts) — kept simple
since the project's focus is infrastructure and deployment, not the app
itself.

**Files:** `app.py`, `requirements.txt`

---

## 2. Version Control (Git & GitHub)

- Installed Git, configured user identity
- Initialized a local Git repository
- Created a GitHub repository (`todo-api`)
- Committed and pushed code with clear, descriptive commit messages
- Repo: `https://github.com/Ash0p/todo-api`

---

## 3. Containerization (Docker)

- Installed Docker Desktop (required enabling WSL2 on Windows first)
- Wrote a `Dockerfile` that:
  - Uses a lightweight Python base image
  - Installs dependencies
  - Copies the app code
  - Runs the Flask app on container start
- Built and tested the image locally (`docker build`, `docker run`)
- Verified the app works identically inside a container as it did running
  directly

**Files:** `Dockerfile`

---

## 4. Infrastructure as Code (Terraform)

- Installed Terraform and added it to the system PATH
- Wrote Terraform configuration to provision AWS infrastructure
  automatically, instead of manually clicking through the AWS Console

**What the Terraform code defines:**
- Uses AWS's **default VPC** (network) — no need to build networking
  from scratch
- A **Security Group** (firewall) allowing:
  - Port 5000 (the app) from anywhere
  - Port 22 (SSH) for server access
- An **EC2 instance** (`t2.micro`, free-tier eligible) that:
  - Automatically installs Docker on boot
  - Clones the project from GitHub
  - Builds and runs the Docker container — no manual setup needed after
    deployment

**Files:** `terraform/main.tf`, `terraform/variables.tf`,
`terraform/outputs.tf`, `terraform/user_data.sh.tpl`

---

## 5. Cloud Account Setup (AWS)

- Created an IAM user (instead of using the root account — a security
  best practice)
- Attached permissions and generated CLI access keys
- Connected AWS CLI on the local machine (`aws configure`)
- Set up a zero-spend billing alert to catch unexpected charges early

**Status:** Original AWS account was found closed; submitted a
reactivation request to AWS Support and is currently waiting on a
response. Deployment (`terraform apply`) will run once account access is
restored.

---

## 6. Documentation

- Wrote a `README.md` covering:
  - Project purpose and architecture diagram
  - Tech stack
  - API reference
  - How to run locally, in Docker, and deploy via Terraform
  - Honest list of what could be improved with more time/scope

---

## Skills demonstrated by this project

- REST API development (Python/Flask)
- Git & GitHub workflows
- Docker & containerization
- Infrastructure as Code (Terraform)
- AWS fundamentals: EC2, Security Groups, IAM, VPC
- Reading and troubleshooting real error messages (WSL setup, PATH
  configuration, AWS account issues)

---

## Not yet done / possible next steps

- [ ] Run `terraform apply` once AWS account is reactivated
- [ ] Test the live deployed app and capture a screenshot/recording
- [ ] Run `terraform destroy` after testing to avoid ongoing charges
- [ ] (Optional) Add GitHub Actions for CI/CD automation
- [ ] (Optional) Replace in-memory storage with AWS RDS
- [ ] (Optional) Add a Load Balancer + Auto Scaling Group
