=begin
module Paperclip
  class EmptyProcessor < Processor

    def initialize(file, options = {}, attachment = nil)    
      super
      @file                = file
      @current_format      = File.extname(@file.path)
      @basename            = File.basename(@file.path, @current_format)
    end

    def make
      #@file.pos = 0                                               # в основном файле перевести каретку на начало, если ее уже сместил другой процессор 
      #src = @file                                                 # открыть источник
      #dst = Tempfile.new([@basename, @format].compact.join("."))  # открыть цель
      #dst.binmode                                                 # перевод цели в бинарный режим (не существенно)
      # Смотри, как преобразовывать данные
      Tempfile.new([@basename, @format].compact.join("."))
    end # make
  end
end
=end