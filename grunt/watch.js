module.exports = {
	files: ['contents/**/*.md', 'sass/*.scss', 'templates/*.jade'],
  tasks: ['wintersmith:local', 'sass', 'copy']
};