RUN "pip install virtualenv"
RUN "cd /deos/venv/linux/ && virtualenv python --no-site-packages"
cat << EOF >> /deos/venv/linux/python/.gitignore
#[ignore]
*

#[except]
!.gitignore
EOF
EXIT_SUCCESS
