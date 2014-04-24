require 'ostruct'

module Uploadcare
  module Operations
    operations = [
      :format, 
      :quality, 
      :crop, 
      :resize,
      :scale_crop,
      :preview,
      :stretch,
      :rotate,
      :effect,
      :setfill 
    ]

    operations.each do |method|
      # binding.pry
      define_method method do |*args|
        # op = const_get(method.to_s.capitalize).new(operations)
      end
    end

    class Operation < OpenStruct
    end

    class Format < Operation
      def initialize format
        unless [:png, :jpeg].include?(format)
          raise ArgumentError.new 'only :png and :jpeg format are supported as output'
        end
        super({:format => format})
      end

      def to_s
        "/format/#{format.to_s}/"
      end
    end

    class Quality < Operation
      def initialize quality=:normal
        unless [:normal, :better].include?(quality)
          raise ArgumentError.new 'quality may be only :normal or :better and supported only to :jpeg format'
        end
        super({:quality => quality})
      end

      def to_s
        "/quality/#{quality}/"
      end
    end

    class Crop < Operation
      def initilize options={}
        unless options[:width] && options[:height]
          raise ArgumentError.new 'Crop operation requires :height and :width params'
        end

        if options[:center] && options[:offset_x] && options[:offset_y]
          raise ArgumentError.new 'Crop operation requires either :offset_x && :offset_y params or :center parameter'
        end

        super(options)
      end

      def to_s
        str = "/#{width}x#{height}/"
        str += "#{offset_x},#{offset_y}/" if offset_x && offset_y
        str += "center/" if center
        
        str
      end
    end


    class Resize < Operation
      def initialize options={}
        unless options[:width] || options[:height]
          raise ArgumentError.new 'Resize operation requires :height or :width param'
        end
        options[:width] ||= ""
        options[:height] ||= ""

        super(options)
      end

      def to_s
        "resize/#{width}x#{height}/"
      end
    end


    class ScaleCrop < Operation
      def initialize options={}
        unless options[:width] && options[:height]
          raise ArgumentError.new 'Resize operation requires :height and :width param'
        end

        super(options)
      end

      def to_s
        str = "scale_crop/#{width}x#{height}/"
        str += "center/" if center

        str
      end
    end


    class Preview < Operation
      def initialize options={}
        unless (options[:width] && options[:height]) || (options[:width].nil? && options[:height].nil?) 
          raise ArgumentError.new 'Resize operation requires :height and :width params or no dimensions params at all'
        end

        super(options)
      end

      def to_s
        str = "preview/"
        str += "#{width}x#{height}/" if width && height
        
        str
      end
    end


    class Stretch < Operation
      def initialize stretch
        unless [:on, :off, :fill].include?(stretch)
          raise ArgumentError.new 'Strecth mode may be only :on, :offf or :fill'
        end
        super({:stretch => stretch})
      end

      def to_s
        "/stretch/#{stretch.to_s}/"
      end
    end


    class Rotate < Operation
      def initilize angle
        unless angle % 90 == 0
          raise ArgumentError.new 'Rotation angle must be a multiple of 90 (0, 90, 180, 270 etc)'
        end
        super({:angle => angle})
      end

      def to_s
        "/rotate/#{angle}/"
      end
    end


    class Effect < Operation
      def initialize effect
        unless [:flip, :grayscale, :invert, :mirror].include?(effect)
          raise ArgumentError.new 'Effects may be only :flip, :grayscale, :invert or :mirror'
        end
        super({:effect => effect})
      end

      def to_s
        "/effect/#{effect.to_s}/"
      end
    end


    class SetFill < Operation
      def initialize colour
        color_regex = /^#?(?<colour>[0-9a-fA-F]{3}){1,2}$/
        matched = color_regex.match(colour)

        unless matched && matched[:colour]
          raise ArgumentError.new 'Color must be given in hexadecimal notation like \"FF1010\"'
        end

        colour_str = matched[:colour]

        if colour_str.length == 3
          colour_str = colour_str.split(//).map!{|l| l*2}.join("")
        end

        super({:colour => colour_str})
      end

      def to_s
        "/setfill/#{colour.downcase}/"
      end
    end
    binding.pry
  end
end