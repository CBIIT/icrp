/**
 * Grunt tasks for Toolbar Themes.
 * http://gruntjs.com/
 */

'use strict';

module.exports = function(grunt) {

	grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    sass: {
      styles: {
        files: [{
          expand: true,
          cwd: 'themes',
          src: ['**/*.scss'],
          dest: 'themes',
          ext: '.css'
        }],
        options: {
          precision: 5,
          outputStyle: 'expanded',
          sourceMap: true
        }
      }
    },

    grunticon: {
      toolbar: {
        files: [{
            expand: true,
            cwd: 'themes/base/grunticons/original',
            src: ['*.svg'],
            dest: 'themes/base/grunticons/processed'
        }],
        options: {
          enhanceSVG: true,
          cssprefix: '.'
        }
      }
    },

    postcss: {
      styles: {
        src: 'themes/**/*.css',
        options: {
          map: {
            inline: false
          },
          processors: [
            require('autoprefixer')({browsers: 'last 4 versions'})
          ]
        }
      }
    },

    watch: {
      styles: {
        files: 'themes/**/*.scss',
        tasks: ['sass:styles', 'postcss:styles']
      }
		}
	});

  grunt.loadNpmTasks('grunt-postcss');
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-grunticon');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.registerTask('default', ['watch:styles']);
};
