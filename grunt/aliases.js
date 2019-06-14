module.exports = {
	'default': ['build', 'watch'],
	'build': ['clean:build', 'sass', 'copy'],
	'buildGithub': ['clean:build', 'sass', 'copy'],
  'buildOrdenen': ['clean:build', 'sass', 'copy'],
  'deployGithub': [
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