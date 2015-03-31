module.exports = {
	'images': {
		files: [
			{expand: true, cwd: 'contents', src: ['**/*.jpg'], dest: 'build'},
      {src: 'LICENSE', dest: 'build/LICENSE'}
		]
	}
};