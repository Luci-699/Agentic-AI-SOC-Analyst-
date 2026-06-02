# Agentic SOC Analyst 🛡️

An AI-powered Security Operations Center (SOC) analyst built on Wazuh SIEM. The system autonomously ingests security alerts, investigates threats, enriches findings with threat intelligence, and recommends or executes response actions.

## Architecture

```
Wazuh SIEM → Alert Collector → PostgreSQL → Multi-Agent AI → SOC Dashboard
                                                ↑
                                    ChromaDB (Incident Memory)
```

## Quick Start (Phase 1)

### Prerequisites
- Windows 10/11 with WSL2 enabled
- Docker Desktop installed and running
- PowerShell 7+ (or Windows PowerShell 5.1)
- 8GB+ RAM recommended (Wazuh needs ~4GB)

### 1. Clone & Setup

```powershell
# Navigate to project
cd "Agentic AI SOC Analyst"

# Copy environment config
cp .env.example .env

# Run setup (as Administrator)
.\setup.ps1
```

### 2. Enroll Your Windows Machine as a Wazuh Agent

```powershell
.\scripts\enroll-agent.ps1
```

### 3. Verify Everything Is Running

```powershell
.\scripts\health-check.ps1
```

### 4. Open the Dashboard

```
https://localhost:443
Username: admin
Password: SecretPassword
```

---

## Project Phases

| Phase | Description | Status |
|-------|-------------|--------|
| 1 | Security Monitoring Foundation (Wazuh Stack) | 🚧 In Progress |
| 2 | Generate Security Events | ⏳ Pending |
| 3 | Wazuh Data Flow & API | ⏳ Pending |
| 4 | Alert Collection Service | ⏳ Pending |
| 5 | First AI Analyst | ⏳ Pending |
| 6 | Investigation Tools (VT, AbuseIPDB, OTX) | ⏳ Pending |
| 7 | Multi-Step Investigation Workflows | ⏳ Pending |
| 8 | Multi-Agent SOC Architecture | ⏳ Pending |
| 9 | Incident Memory | ⏳ Pending |
| 10 | Automated Response | ⏳ Pending |
| 11 | SOC Dashboard (React) | ⏳ Pending |
| 12 | Capstone Integration | ⏳ Pending |

---

## Service Ports

| Service | URL | Credentials |
|---------|-----|-------------|
| Wazuh Dashboard | https://localhost:443 | admin / SecretPassword |
| Wazuh API | https://localhost:55000 | wazuh-wui / MyS3cr37P450r.*- |
| Wazuh Indexer | https://localhost:9200 | admin / SecretPassword |
| PostgreSQL | localhost:5432 | soc_user / soc_password |
| ChromaDB | http://localhost:8001 | — |
| FastAPI (Phase 4+) | http://localhost:8000 | — |
| React Dashboard (Phase 11) | http://localhost:3000 | — |

---

## Common Commands

```powershell
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f wazuh.manager
docker-compose logs -f wazuh.indexer

# Restart a service
docker-compose restart wazuh.manager

# Check container status
docker-compose ps

# Enter manager container
docker exec -it wazuh.manager bash
```

## Tech Stack

- **SIEM**: Wazuh 4.7.3 (Manager + Indexer + Dashboard)
- **Alert DB**: PostgreSQL 16
- **Vector DB**: ChromaDB
- **AI Framework**: LangGraph + CrewAI
- **LLM**: Ollama (local, free)
- **Backend**: FastAPI
- **Frontend**: React + Vite
- **Threat Intel**: VirusTotal, AbuseIPDB, AlienVault OTX
