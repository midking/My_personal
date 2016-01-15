# 콤파스 설정
require 'compass/import-once/activate'

Encoding.default_external = "utf-8"

environment = :development

http_path       = "/"
css_dir         = "css"
# css_path        = ""
sass_dir        = "sass"
images_dir      = "images"
generated_images_dir = "images/sprites"
relative_assets = true
# images_path   = "/"
# fonts_dir      = "fonts"


output_style = (environment == :production) ? :compressed : :expanded
line_comments = false
preferred_syntax = :scss
sourcemap = false
cache = false


# smart layout에 spacing을 지정하기 위한 루비코드 override
# - 수정하지 마세요!
module Compass::SassExtensions::Sprites
	module LayoutMethods
		def compute_image_positions!
		  case layout
		  when SMART
			@images, @width, @height = Layout::Smart.new(@images, @kwargs).properties
		  when DIAGONAL
			require 'compass/sass_extensions/sprites/layout/diagonal'
			@images, @width, @height = Layout::Diagonal.new(@images, @kwargs).properties
		  when HORIZONTAL
			require 'compass/sass_extensions/sprites/layout/horizontal'
			@images, @width, @height = Layout::Horizontal.new(@images, @kwargs).properties
		  else
			require 'compass/sass_extensions/sprites/layout/vertical'
			@images, @width, @height = Layout::Vertical.new(@images, @kwargs).properties
		  end
		end	    
	end
	
	module Layout	
		class Smart < SpriteLayout

		  def layout!
			calculate_positions!
		  end

		private # ===========================================================================================>

		  def calculate_positions!
			fitter = ::Compass::SassExtensions::Sprites::RowFitter.new(@images)
			current_y = 0
			width = 0
			height = 0
			last_row_spacing = 9999
			fitter.fit!.each do |row|
				current_x = 0
				row_height = 0
				row.images.each_with_index do |image, index|
					extra_y = [image.spacing - last_row_spacing, 0].max
					if index > 0
						last_image = row.images[index-1]
						current_x += [image.spacing, last_image.spacing].max
					end
					image.left = current_x
					image.top = current_y + extra_y
					current_x += image.width
					width = [width, current_x].max
					row_height = [row_height, extra_y + image.height+image.spacing].max
				end
				current_y += row.height
				height = [height, current_y].max
				last_row_spacing = row_height - row.height
				current_y += last_row_spacing
			end
			@width = width
			@height = height
		  end

		end
	end
end

module Compass::SassExtensions::Functions::Sprites
  def sprite_url(map)
	verify_map(map, "sprite-url")
	map.generate
	generated_image_url(Sass::Script::String.new(map.name_and_hash + '?' +  `git rev-parse --short HEAD`.chomp))
  end
end

module Compass::SassExtensions::Sprites::SpriteMethods
  def name_and_hash
	"#{path}.png"
  end

  def cleanup_old_sprites
	Dir[File.join(::Compass.configuration.generated_images_path, "#{path}.png")].each do |file|
	  log :remove, file
	  FileUtils.rm file
	  ::Compass.configuration.run_sprite_removed(file)
	end
  end
end

module Compass
  class << SpriteImporter
	def find_all_sprite_map_files(path)
	  glob = "*{#{self::VALID_EXTENSIONS.join(",")}}"
	  Dir.glob(File.join(path, "**", glob))
	end
  end
end

# ---------------------------------------------------------------- #
# ############     Compass Configuration Properties     ############
# ---------------------------------------------------------------- #

# # Compass 설정 참고자료
# http://compass-style.org/help/documentation/configuration-reference/

# ------------------------------------------------------------------------
# 기본 언어 인코딩 설정
# Windows 사용자에게 주로 발생하는 오류(언어 인코딩: CP949)
# Encoding.default_external = "utf-8"


# ------------------------------------------------------------------------
# file-path 상대 경로 지정 설정 (localhost 작업시 상대 경로로 지정)
# relative_assets = true



# ------------------------------------------------------------------------
# project_type
# @type [Symbol]
# :stand_alone or :rails => 기본값 :stand_alone


# ------------------------------------------------------------------------
# project_path
# @type [string]
# 상황(context)을 유추할 수 있는 :stand_alone 모드에서는 project_path 가 필요하지 않습니다.
# 필요시 프로젝트의 루트 경로를 설정합니다.
# project_path = ""


# ------------------------------------------------------------------------
# http_path
# @type [String]
# 웹서버에서 실행할 경우의 프로젝트 경로
# 기본값 : "/" 으로 "/블라블라/..." => http://localhost:8080/블라블라/...
# compass의 helper functions 사용시 기준 경로.
# '/'로 시작하는 모든 URL의 URL 접두사.
# http_path = "/susy&compass-study/"


# ------------------------------------------------------------------------
# css_dir
# @type [String]
# css_dir CSS OUTPUT Setting
# CSS 스타일시트가 보관(출력)되는 곳의 디렉토리(컴파일된 css 결과물이 출력)
# css_dir = "css"

# ------------------------------------------------------------------------
# css_path
# @type [String]
# CSS 스타일시트가 보관되는 곳의 전체 경로입니다.
# 기본값 : <project_path>/<css_dir> 으로 구성되어 있습니다.
# 예) project_type 기본값인 :stand_alone 모드에서 project_path/css
# css_path = ""


# ------------------------------------------------------------------------
# sass_dir
# @type [String]
# sass가 보관되어 있는 곳의 경로
# 기본값 : "sass"
# sass_dir = "sass"

# ------------------------------------------------------------------------
# image_dir
# @type [String]
# 이미지가 보관되어 있는 폴더경로
# 기본값 images_dir = "images"
# images_dir = "images"


# ------------------------------------------------------------------------
# images_path
# @type [String]
# 이미지가 보관되어 있는 full path 지정
# 기본값 : <project_path>/<images_dir> 로 구성
# images_path = "images/"


# ------------------------------------------------------------------------
# environment
# @type [Symbol]
# 개발 또는 빌드 여부 환경설정
# :development 개발버전
# :production 배포버전
# environment = :development


# ------------------------------------------------------------------------
# outpu_style
# @type [Symbol]
# SASS => CSS 변경 시에 변경되는 아웃풋 스타일 설정
# :expanded
# :nested
# :compact
# :compressed
# output_style = :expanded
# output_style = (environment == :production) ? :compressed : :expanded


# ------------------------------------------------------------------------
# fonts_dir
# @type [String]
# 폰트 파일이 보관되어 있는 디렉토리.
# :stand_alone 모드는 <css_dir>/fonts :rails 모드는 "public/fonts"
# 기본값 : <css_dir>/fonts
# fonts_dir = "fonts"


# ------------------------------------------------------------------------
# line_comments
# @type [boolean]
# 변경된 내용 주석 처리 여부(컴파일된 CSS에 주석 출력)
# line_comments = false


# ------------------------------------------------------------------------
# preferred_syntax
# @type [Symbol]
# Sass/Scss 중 선호 문법을 설정
#preferred_syntax = :scss


# ------------------------------------------------------------------------
# sourcemap
# @type [boolean]
# Sass 컴파일된 css 내에서 Sass 파일을 역추적하기 위함(개발자 도구내에서)
# Sourcemap 사용 유무
# sourcemap = false


# ------------------------------------------------------------------------
# cache
# @type [boolean]
# 대형 프로젝트에서 캐시 사용하지 않을 경우 개발시 랜더링 느려질수 있음
# sass-cache file 사용 유무
# cache = false


# ------------------------------------------------------------------------
# 스프라이트 이미지 설정과 관계된 옵션
# generated_images_dir = "images/sprites"
# sprite_load_path     = [images_path]
# sprite_engine        = :chunky_png # :oily_png
# chunky_png_options   = {:compression => Zlib::BEST_COMPRESSION}

# 스프라이트 이미지 생성 엔진 참고URL
# [ chunky_png ] https://github.com/wvanbergen/chunky_png
# [ oily_png ] https://github.com/wvanbergen/oily_png