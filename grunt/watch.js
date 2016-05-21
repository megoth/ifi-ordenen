module.exports = {
	files: ['contents/**/*.md', 'plugins/*', 'sass/*.scss', 'templates/*.jade'],
  tasks: ['wintersmith:local', 'sass', 'copy']
};