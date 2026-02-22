#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository universe
sudo apt update -y

sudo apt install python3.12-venv -y

sudo apt install -y python3
sudo apt install -y python3-pip

mkdir -p /home/adminuser/app
mkdir -p /home/adminuser/venv
cd /home/adminuser/venv
python3 -m venv venv
source venv/bin/activate
#cd /home/adminuser/PyTodoBackendMonolith Navigate to the project directory, #After cloning the repository, move into the project folder:
# source /home/adminuser/venv/venv/bin/activate.  Activate the virtual environment
# Then Install the required Python dependencies pip install -r requirements.txt
pip install fastapi uvicorn

cat > /home/adminuser/app/app.py <<EOF
from fastapi import FastAPI
app = FastAPI()
@app.get("/")
def home():
    return {"msg": "FastAPI running"}
EOF


cat > /etc/systemd/system/uvicorn.service <<EOF
[Unit]
Description=Uvicorn FastAPI Backend
After=network.target

[Service]
User=root
WorkingDirectory=/home/adminuser/app
ExecStart=/home/adminuser/venv/venv/bin/python -m uvicorn app:app --host 0.0.0.0 --port 8000
EnvironmentFile=/home/adminuser/app/.env
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

cat > /home/adminuser/app/.env <<EOF
CONNECTION_STRING=$(CONNECTION_STRING)
EOF


sudo systemctl daemon-reload
sudo systemctl stop uvicorn
sudo systemctl start uvicorn
sudo systemctl enable uvicorn
