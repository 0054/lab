import pyinfra.operations as o
import pyinfra
from pyinfra.operations import yum, server, apt


server.shell(
        name = 'Run shell command',
        commands = 'df -h')

yum.packages(
        packages = ['bash-completions']
        )



