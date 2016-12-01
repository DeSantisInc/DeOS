DERUN "sudo apt-get install -y ipython"

DERUN "sudo apt-get install -y ipython-notebook"

DERUN "sudo pip install jupyter"

DERUN "sudo pip install ipyparallel"

DERUN "sudo ipcluster nbextension enable"

DERUN "sudo ipython profile create vagrant"

if [ -L /root/.ipython/profile_vagrant/ipython_kernel_config.py ]; then
  DERUN "sudo rm /root/.ipython/profile_vagrant/ipython_kernel_config.py"
fi

cat <<EOT >> /root/.ipython/profile_vagrant/ipython_kernel_config.py
c = get_config()
c.StoreMagics.autorestore = True
c.InteractiveShell.editor = 'vim'
c.AliasManager.user_aliases = [
    ('git', 'git'),
    ('vi', 'vim'),
    ('screen', 'screen'),
    ('make', 'make'),
    ('pip', 'pip'),
    ('node', 'node'),
    ('npm', 'npm'),
    ('yarn', 'yarn'),
]
EOT

sudo jupyter notebook --notebook-dir=/vagrant/var/notebook --no-browser --ip=0.0.0.0 &

EXIT_SUCCESS
