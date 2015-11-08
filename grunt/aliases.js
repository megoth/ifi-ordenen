module.exports = {
	'default': ['build', 'watch'],
	'build': ['clean:build', 'wintersmith:local', 'sass', 'copy'],
	'buildGithub': ['clean:build', 'wintersmith:github', 'sass', 'copy'],
  'buildOrdenen': ['clean:build', 'wintersmith:ordenen', 'sass', 'copy'],
  'deployGithub': [
    'gitcheckout:github', 
    'buildGithub', 
    'gitadd:all', 
    'gitcommit:github',
    'gitpush:github'
  ],
  'deployOrdenen': [
    'gitcheckout:ordenen', 
    'buildOrdenen', 
    'gitadd:all', 
    'gitcommit:ordenen',
    'gitpush:ordenen'
  ],
  'updateOrdenen': ['gitpull:ordenen']
};