'use strict';
/*
	name: 이미지명 추출
	info: 폴더안에 이미지파일 이름을 추출하여 html문서에 뿌려준다.

	1. 지정된 폴더를 검색한다. dirList=[]
	2. 검색된 폴더안의 모든 이미지를 찾아낸다.
	3. 확장자(.png)를 뺀 name을 html문서로 뿌려준다.
 */

/* package */
var fs = require('fs'),
	path = require('path'),
	cheerio = require('cheerio');

/* root 경로*/
var basePath = path.join(__dirname, '/web');

/* 이미지명을 추출하기 위한 폴더명 추가 반드시 basePath 안에 있는 폴더여야 합니다. */
var dirList = ['icon', 'sp'];

/* 참고할 tamplate 파일 경로 */
var templatePath = path.join(basePath, '/@template/@spriteTemplate.html');

/* 배출되는 html 파일 경로 */
var indexPath = path.join(basePath, '/@guide/@guide_sprite.html');

/* template 파일을 복사하여 배출파일을 만든다 */
var htmlTemplate = fs.readFileSync(templatePath, 'utf8');
fs.writeFileSync(indexPath, htmlTemplate, 'utf8');

/* doc 타입을 사용하기 위한 준비 */
var $ = cheerio.load(fs.readFileSync(indexPath, 'utf8'));

/* 재귀호출로 파일 경로 찾기 */
var findFile = function findFile(searchPath, searchFile, callback){
	fs.readdir(searchPath, function (err, files){
		if(err) { return callback(err); }
		files.forEach(function (file){
			fs.stat(searchPath+'/'+file, function (err, stats){
				if(err) { return callback(err); }
				
				if(file == searchFile){
					return callback(undefined, searchPath+'/'+file);
				}else if(file != searchFile && stats.isDirectory()){
					findFile(searchPath+'/'+file, searchFile, callback);
				}
			});
		});
	});
}

dirList.forEach(function(dir, i){
	findFile(basePath, dir, function(err, dirPath, callback) {
		if(err) { throw err; }
		$('#spriteContent').append('<div class="guide_title">'+ dirList[i] +'</div>\n<ul class="spriteList'+ i +'">\n</ul>\n');
		fs.writeFileSync(indexPath, $.html(), 'utf8');
		fs.readdir(dirPath, function(err, files){
			if(err){ throw err; }
			files.forEach(function(file){
				var fileName = path.basename(file, '.png');
				$('.spriteList'+i).append('\t<li><span class="'+ fileName +'"></span><p>'+ fileName +'</p></li>\n');
				fs.writeFileSync(indexPath, $.html(), 'utf8');
			});
		});
	});
});

console.log("성공!!!");