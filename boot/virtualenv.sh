RUN "pip install virtualenv"
RUN "cd /deos/ && virtualenv venv --no-site-packages"
cat << EOF >> /deos/venv/.gitignore
#[ignore]
*
#[except]
!.gitignore
EOF
EXIT_SUCCESS
