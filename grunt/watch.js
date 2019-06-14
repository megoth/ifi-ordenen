module.exports = {
	files: ['contents/**/*.md', 'plugins/*', 'sass/*.scss', 'templates/*.pug'],
  tasks: ['wintersmith:local', 'sass', 'copy']
};