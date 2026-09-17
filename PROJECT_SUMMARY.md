# Project Summary — To-Do API Cloud Deployment

A record of everything built and set up in this project, from a basic API
to a full-stack app deployed live on AWS using Infrastructure as Code.

---

## 1. Application (Backend)

Built a REST API using **Python + Flask**.

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

## 2. Frontend

Added a **React** frontend (loaded via CDN, no build tooling required),
served directly by Flask from a `static/` folder. This keeps the whole
app — frontend and backend — inside a single Docker container, so no
extra infrastructure was needed to support it.

**Files:** `static/index.html`

---

## 3. Version Control (Git & GitHub)

- Installed Git, configured user identity
- Created a GitHub repository and pushed code with clear commit messages
- Repo: `https://github.com/Ash0p/todo-api`

---

## 4. Containerization (Docker)

- Installed Docker Desktop (required enabling WSL2 on Windows first)
- Wrote a `Dockerfile` that installs dependencies, copies the app, and
  runs it on container start
- Built and tested the image locally, both with and without the frontend

**Files:** `Dockerfile`

---

## 5. Infrastructure as Code (Terraform)

Wrote Terraform configuration to provision AWS infrastructure
automatically instead of using the AWS Console manually.

**What it creates:**
- Uses AWS's default VPC (no custom networking needed)
- A Security Group allowing port 5000 (app) and port 22 (SSH)
- An SSH key pair, added after an early deployment issue, so the server
  can be inspected directly if something goes wrong
- An EC2 instance (`t2.micro`, free-tier eligible) that automatically
  installs Docker, clones this repo, builds the image, and runs the
  container on boot — with its setup logged to `/var/log/user-data.log`
  for debugging

**Files:** `terraform/main.tf`, `terraform/variables.tf`,
`terraform/outputs.tf`, `terraform/user_data.sh.tpl`

---

## 6. AWS Account & Deployment — what actually happened

- Created an IAM user with CLI access keys (instead of using root) and a
  zero-spend billing alert
- Connected AWS CLI (`aws configure`) using the IAM user's access key
- **First deploy** (`terraform apply`) succeeded and produced a public
  IP, but the app returned "Not Found" — traced this to the frontend
  files not having been pushed to GitHub yet, so the server had pulled
  an older version of the code
- Fixed the repo, then **redeployed** — this time the server became
  unreachable entirely. Since there was no way to inspect the server
  (no SSH key had been set up), added an `aws_key_pair` resource and
  startup logging to Terraform for future debugging
- **Redeployed again** with the SSH key in place — this time it worked:
  the live app was reachable at a public AWS IP, frontend and backend
  both working correctly, confirmed by testing and a screenshot
- Ran `terraform destroy` immediately after confirming it worked, to
  stop AWS charges. Verified in the AWS Console that the EC2 instance
  showed as **terminated**

---

## 7. Documentation

- `README.md` — project purpose, architecture, tech stack, API
  reference, how to run locally/Docker/AWS, and a live demo screenshot
- `.gitignore` — excludes Python cache files, Terraform state, and the
  private SSH key from ever being committed
- `LICENSE` — MIT License

---

## Skills demonstrated by this project

- REST API development (Python/Flask) and a React frontend
- Git & GitHub workflows
- Docker & containerization
- Infrastructure as Code (Terraform)
- AWS fundamentals: EC2, Security Groups, IAM, key pairs, default VPC
- **Real troubleshooting**: diagnosing a stale deployment from an
  out-of-date repo, recognizing that "running" in EC2 doesn't mean the
  app inside is healthy, and adding SSH access and logging specifically
  to debug a failure — then successfully redeploying
- Cost awareness: billing alerts, using free-tier resources, and
  tearing down infrastructure immediately after use

---

## Current status

The app is **not** currently running live (destroyed after testing, to
avoid ongoing AWS charges). Everything needed to bring it back is saved
in this repo — running `terraform apply` inside the `terraform` folder
recreates the exact same environment in a few minutes.
