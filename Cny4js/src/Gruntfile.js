module.exports = function(grunt) {
	grunt.loadNpmTasks('grunt-shell');
	// grunt.process.on("exit", function(code) {
	// 	console.log(code);
	// });
	// console.log(grunt);
	grunt.initConfig({
		shell: {
			ls: {
				command: "lsss"
			}
		}
	});
	grunt.registerTask("default", ["shell:ls"]);

};
process.on("exit", function(err) {
	throw "jjjjj"
});