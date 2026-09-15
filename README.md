# To-Do API — Cloud Deployment Project

A simple REST API, containerized with Docker and deployed to AWS using
Infrastructure as Code (Terraform). Built as a hands-on project to
demonstrate core DevOps/cloud skills: containerization, infrastructure
automation, and cloud networking.

## What this project demonstrates

- **Backend development** — REST API built with Flask (Python)
- **Containerization** — Dockerized for consistent, portable deployment
- **Infrastructure as Code** — AWS infrastructure defined and provisioned
  entirely with Terraform (no manual clicking in the AWS Console)
- **Cloud networking & security** — EC2 instance, security groups
  (firewall rules), and AWS's default VPC
- **Automated provisioning** — the server installs Docker and starts the
  app automatically on boot, with zero manual setup after deployment

## Architecture

```
GitHub Repo (code)
      |
      v
Terraform (main.tf, variables.tf, outputs.tf)
      |
      v
AWS EC2 Instance (t2.micro)
  - Security Group: allows HTTP (5000) + SSH (22)
  - Startup script: installs Docker, pulls this repo, builds & runs the container
      |
      v
Flask To-Do API (running in Docker, port 5000)
```

## Tech stack

| Layer | Tool |
|---|---|
| Backend | Python, Flask |
| Containerization | Docker |
| Infrastructure as Code | Terraform |
| Cloud provider | AWS (EC2, Security Groups, default VPC) |
| Version control | Git, GitHub |

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/health` | Health check (used by monitoring/load balancers) |
| GET | `/tasks` | List all tasks |
| POST | `/tasks` | Create a task — body: `{"title": "Buy milk"}` |
| DELETE | `/tasks/<id>` | Delete a task by ID |

## Running locally

```bash
pip install -r requirements.txt
python app.py
```

## Running with Docker

```bash
docker build -t todo-api .
docker run -p 5000:5000 todo-api
```

## Deploying to AWS with Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After deployment, Terraform prints the server's public URL. Test it with:

```bash
curl http://<public_ip>:5000/health
```

To avoid ongoing AWS charges, tear down the infrastructure when done:

```bash
terraform destroy
```

## What I'd improve with more time

- Replace in-memory storage with a managed database (AWS RDS)
- Add an Application Load Balancer + Auto Scaling Group for high availability
- Add a CI/CD pipeline (GitHub Actions) to auto-deploy on every push
- Add HTTPS via a certificate and custom domain
- Move to a private subnet with a NAT gateway for tighter security

## Author

Built by [Ash0p](https://github.com/Ash0p) as a learning project to
practice cloud infrastructure and DevOps fundamentals.
