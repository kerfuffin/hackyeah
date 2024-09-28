# Makefile

# Nazwa katalogu środowiska wirtualnego
VENV_DIR = venv

# Plik z zależnościami
REQUIREMENTS = requirements.txt

# Detekcja systemu operacyjnego
ifeq ($(OS),Windows_NT)
    PLATFORM = windows
    PYTHON = $(VENV_DIR)\Scripts\python.exe
    ACTIVATE = $(VENV_DIR)\Scripts\Activate.ps1
    PIP = $(VENV_DIR)\Scripts\pip.exe
    RM = rm $(VENV_DIR) -r -Force
else
    PLATFORM = unix
    PYTHON = $(VENV_DIR)/bin/python
	ACTIVATE = source $(VENV_DIR)/bin/activate
    PIP = $(VENV_DIR)/bin/pip
    RM = rm -rf $(VENV_DIR)
endif

# Deklaracja celów, które nie są plikami
.PHONY: env clean run

# Cel: env - tworzy środowisko wirtualne i instaluje zależności
env: 
	@echo Creating virtual environment...
	@python -m venv $(VENV_DIR)
	@$(PYTHON) -m pip install --upgrade pip
	@$(PIP) install -r $(REQUIREMENTS)
	@echo Virtual environment has been created and dependencies have been installed.

# Cel: clean - usuwa środowisko wirtualne
clean:
	@echo Cleaning up...
	$(RM)
	@echo Done.

# Cel: run - uruchamia aplikację w środowisku wirtualnym bez aktywacji
run:
	@echo Starting the application...
	@$(PYTHON) src/run.py
