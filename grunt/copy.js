module.exports = {
	'images': {
		files: [
      {expand: true, cwd: 'public', src: ['*'], dest: 'build'},
			{expand: true, cwd: 'contents', src: ['**/*.jpg'], dest: 'build'}
		]
	},
  'scripts': {
    src: [
      'bower_components/zepto/zepto.min.js'
    ],
    dest: 'build/all.min.js'
  }
};