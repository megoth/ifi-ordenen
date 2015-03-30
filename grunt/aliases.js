module.exports = {
	'default': ['build', 'watch'],
	'build': ['wintersmith:local', 'sass', 'copy:images'],
	'github': ['wintersmith:github', 'sass', 'copy:images']
};