module.exports = {
	'default': ['build', 'watch'],
	'build': ['clean:build', 'wintersmith:local', 'sass', 'copy:images'],
	'github': ['clean:build', 'wintersmith:github', 'sass', 'copy:images']
};