module.exports = {
  options: {
    cwd: 'build'
  },
  master: {
    options: {
      message: 'Committing master using grunt-git'
    }
  },
  github: {
    options: {
      message: 'Committing gh-pages using grunt-git'
    }
  },
  ordenen: {
    options: {
      message: 'Committing ordenen using grunt-git'
    }
  }
};