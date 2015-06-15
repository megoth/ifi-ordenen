module.exports = {
	'default': ['build', 'watch'],
	'build': ['wintersmith:local', 'sass', 'copy'],
  'local': ['clean:build', 'build'],
	'github': ['clean:build', 'wintersmith:github', 'sass', 'copy'],
  'ordenen': ['clean:build', 'wintersmith:ordenen', 'sass', 'copy']
};