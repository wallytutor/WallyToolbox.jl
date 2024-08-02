# Configuration file for jupyterhub.

c.JupyterHub.bind_url = 'http://0.0.0.0:8000/'
c.Authenticator.admin_users = {'user'}
c.Authenticator.allowed_users = {'user'}
c.LocalAuthenticator.create_system_users = True
