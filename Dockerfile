FROM python:3.9

WORKDIR /app

# # Install Poetry
# RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python && \
#     cd /usr/local/bin && \
#     ln -s /opt/poetry/bin/poetry && \
#     poetry config virtualenvs.create false

# # Copy using poetry.lock* in case it doesn't exist yet
# COPY ./app/pyproject.toml ./app/poetry.lock* /app/

# RUN poetry install --no-root --no-dev

# Install pipenv and compilation dependencies
RUN pip install --upgrade pip
RUN pip install pipenv
RUN apt-get update && apt-get install -y --no-install-recommends gcc

COPY app/backend/Pipfile .
COPY app/backend/Pipfile.lock .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

COPY ./app /app

CMD ["uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0", "--port", "80"]
