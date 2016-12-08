RUN "pip install virtualenv"
RUN "cd /deos/ && virtualenv venv --no-site-packages"
EXIT_SUCCESS
