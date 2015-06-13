module.exports = {
	'default': ['build', 'watch'],
	'build': ['wintersmith:local', 'sass', 'copy:images'],
  'local': ['clean:build', 'build'],
	'github': ['clean:build', 'wintersmith:github', 'sass', 'copy:images'],
  'ordenen': ['clean:build', 'wintersmith:ordenen', 'sass', 'copy:images']
};